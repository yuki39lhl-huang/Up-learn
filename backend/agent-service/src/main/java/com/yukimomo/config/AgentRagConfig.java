package com.yukimomo.config;

import cn.hutool.core.util.StrUtil;
import dev.langchain4j.community.store.embedding.redis.RedisEmbeddingStore;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentSplitter;
import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.document.splitter.DocumentSplitters;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.onnx.allminilml6v2.AllMiniLmL6V2EmbeddingModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import redis.clients.jedis.DefaultJedisClientConfig;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.UnifiedJedis;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 一点通 RAG：现有 Redis 8（已带 RediSearch）+ DashScope / 本地 embedding。
 * <p>
 * 向量与会话记忆共用 {@code ul.redis}，索引名按维度隔离（如 {@code ul-agent-rag-384}）。
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.agent.rag", name = "enabled", havingValue = "true")
public class AgentRagConfig {

    private static final Pattern YEAR_IN_NAME = Pattern.compile("(20\\d{2})");
    private static final List<String> META_KEYS =
            List.of("province", "subject", "year", "source", "subjectFolder");

    private final AgentProperties agentProperties;

    @Value("${ul.redis.host:localhost}")
    private String redisHost;

    @Value("${ul.redis.port:6380}")
    private int redisPort;

    @Bean
    EmbeddingModel ragEmbeddingModel() {
        String mode = StrUtil.blankToDefault(agentProperties.getRag().getEmbedding(), "auto").trim().toLowerCase();
        String dashKey = System.getenv("DASHSCOPE_API_KEY");
        boolean hasDash = StrUtil.isNotBlank(dashKey);

        if ("dashscope".equals(mode) || ("auto".equals(mode) && hasDash)) {
            if (!hasDash) {
                throw new IllegalStateException("ul.agent.rag.embedding=dashscope 但未设置环境变量 DASHSCOPE_API_KEY");
            }
            log.info("RAG embedding: DashScope (qwen3.7-text-embedding)");
            return OpenAiEmbeddingModel.builder()
                    .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                    .apiKey(dashKey.trim())
                    .modelName("qwen3.7-text-embedding")
                    .maxSegmentsPerBatch(20)
                    .logRequests(false)
                    .logResponses(false)
                    .build();
        }

        log.warn("RAG embedding: local AllMiniLm（未配置 DASHSCOPE_API_KEY 或 embedding=local；中文召回弱于通义）");
        return new AllMiniLmL6V2EmbeddingModel();
    }

    @Bean
    EmbeddingStore<TextSegment> ragEmbeddingStore(EmbeddingModel ragEmbeddingModel) {
        int dimension = ragEmbeddingModel.dimension();
        String indexName = "ul-agent-rag-" + dimension;
        String prefix = "ul:agent:emb:" + dimension + ":";
        log.info("RAG Redis store host={}:{} index={} dim={}", redisHost, redisPort, indexName, dimension);

        UnifiedJedis jedis = new UnifiedJedis(
                new HostAndPort(redisHost, redisPort),
                DefaultJedisClientConfig.builder().build());

        return RedisEmbeddingStore.builder()
                .unifiedJedis(jedis)
                .indexName(indexName)
                .prefix(prefix)
                .dimension(dimension)
                .metadataKeys(META_KEYS)
                .build();
    }

    /**
     * 知识库改为由 {@link com.yukimomo.tool.KnowledgeSearchTools} 按需检索；
     * 此处仅占位，避免每轮自动 RAG 抢答/串年。
     */
    @Bean
    ContentRetriever contentRetriever() {
        return query -> List.of();
    }

    @Bean
    ApplicationRunner ragIngestRunner(
            EmbeddingModel ragEmbeddingModel,
            EmbeddingStore<TextSegment> ragEmbeddingStore) {
        return args -> {
            if (!agentProperties.getRag().isIngestOnStartup()) {
                log.info("Skip RAG ingest (ul.agent.rag.ingest-on-startup=false)");
                return;
            }
            try {
                List<Document> documents = loadContentMarkdown();
                if (documents.isEmpty()) {
                    log.warn("No markdown under classpath:content/**/*.md");
                    return;
                }
                // 避免每次启动重复写入同一批向量
                ragEmbeddingStore.removeAll();
                AgentProperties.Rag rag = agentProperties.getRag();
                DocumentSplitter splitter = DocumentSplitters.recursive(
                        rag.getSegmentSize(), rag.getSegmentOverlap());
                long t0 = System.currentTimeMillis();
                EmbeddingStoreIngestor.builder()
                        .embeddingStore(ragEmbeddingStore)
                        .documentSplitter(splitter)
                        .embeddingModel(ragEmbeddingModel)
                        .build()
                        .ingest(documents);
                log.info("RAG ingest done, documents={}, elapsedMs={}",
                        documents.size(), System.currentTimeMillis() - t0);
            } catch (Exception e) {
                log.warn("RAG ingest failed: {}", e.getMessage(), e);
            }
        };
    }

    private static List<Document> loadContentMarkdown() throws Exception {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:content/**/*.md");
        List<Document> docs = new ArrayList<>();
        for (Resource resource : resources) {
            if (!resource.isReadable() || resource.getFilename() == null) {
                continue;
            }
            if ("README.md".equalsIgnoreCase(resource.getFilename())) {
                continue;
            }
            String relative = relativeContentPath(resource);
            String raw = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            if (StrUtil.isBlank(raw)) {
                continue;
            }
            Metadata meta = metadataFromPath(relative, resource.getFilename());
            String prefix = buildPrefix(meta);
            docs.add(Document.from(prefix + raw, meta));
        }
        return docs;
    }

    private static String relativeContentPath(Resource resource) {
        try {
            String uri = resource.getURI().toString().replace('\\', '/');
            int idx = uri.indexOf("/content/");
            if (idx >= 0) {
                return uri.substring(idx + "/content/".length());
            }
            return resource.getFilename();
        } catch (Exception e) {
            return resource.getFilename();
        }
    }

    private static Metadata metadataFromPath(String relativePath, String filename) {
        Metadata meta = new Metadata();
        meta.put("source", relativePath == null ? filename : relativePath);
        if (relativePath == null) {
            return meta;
        }
        String[] parts = relativePath.split("/");
        for (String part : parts) {
            if (part.contains("广东")) {
                meta.put("province", "广东");
            } else if (part.contains("山东")) {
                meta.put("province", "山东");
            }
        }
        if (parts.length >= 2) {
            String folder = parts[parts.length - 2];
            meta.put("subjectFolder", folder);
            meta.put("subject", mapSubjectFolder(folder));
        }
        Matcher m = YEAR_IN_NAME.matcher(filename == null ? relativePath : filename);
        if (m.find()) {
            meta.put("year", m.group(1));
        }
        return meta;
    }

    private static String mapSubjectFolder(String folder) {
        if (folder == null) {
            return "";
        }
        return switch (folder) {
            case "高数", "高数一", "高数二", "高数三" -> "高等数学";
            case "英语" -> "英语";
            case "语文" -> "大学语文";
            case "政治", "政治理论" -> folder.contains("理论") ? "政治理论" : "政治";
            case "计算机" -> "计算机";
            default -> folder;
        };
    }

    private static String buildPrefix(Metadata meta) {
        String province = meta.getString("province");
        String subject = meta.getString("subject");
        String year = meta.getString("year");
        String source = meta.getString("source");
        StringBuilder sb = new StringBuilder();
        sb.append("【知识库文档");
        if (StrUtil.isNotBlank(province)) {
            sb.append('|').append(province);
        }
        if (StrUtil.isNotBlank(subject)) {
            sb.append('|').append(subject);
        }
        if (StrUtil.isNotBlank(year)) {
            sb.append('|').append(year);
        }
        sb.append("】");
        if (StrUtil.isNotBlank(source)) {
            sb.append(" 来源：").append(source);
        }
        sb.append('\n');
        return sb.toString();
    }
}
