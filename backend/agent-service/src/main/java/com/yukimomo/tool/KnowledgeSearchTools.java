package com.yukimomo.tool;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.yukimomo.config.AgentProperties;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingMatch;
import dev.langchain4j.store.embedding.EmbeddingSearchRequest;
import dev.langchain4j.store.embedding.EmbeddingSearchResult;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.filter.Filter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static dev.langchain4j.store.embedding.filter.MetadataFilterBuilder.metadataKey;

/**
 * 知识库检索 Tool：由 LLM 决定是否调用、传什么省/年/科/问句。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class KnowledgeSearchTools {

    private static final int MAX_SNIPPET_CHARS = 900;

    private final AgentProperties agentProperties;
    private final ObjectProvider<EmbeddingStore<TextSegment>> embeddingStoreProvider;
    private final ObjectProvider<EmbeddingModel> embeddingModelProvider;

    @Tool("""
            检索历年真题「答案解析」知识库（向量库）。
            何时调用：用户问某年某科考什么、考点、某题怎么解、要解析摘要等。
            由你从用户话里自行提取 province / year / subject / query，不要让用户改提问方式。
            科目尽量用库内名：高等数学、英语、政治理论、大学语文、计算机基础与程序设计、管理学等。
            大学英语→英语；高数→高等数学；广东政治→政治理论。
            """)
    public String searchKnowledge(
            @P("检索用问句：可沿用用户原话，或改写成「2025广东高等数学考点/题型」之类") String query,
            @P(value = "省份，如广东、山东；用户没提可空或用备考档案省", required = false) String province,
            @P(value = "试卷年份，如 2025；用户没提可空", required = false) Integer year,
            @P(value = "科目（库内名）；用户没提可空或用档案科目", required = false) String subject) {
        if (!agentProperties.getRag().isEnabled()) {
            return "{\"error\":\"知识库未启用（ul.agent.rag.enabled=false）\"}";
        }
        EmbeddingStore<TextSegment> store = embeddingStoreProvider.getIfAvailable();
        EmbeddingModel model = embeddingModelProvider.getIfAvailable();
        if (store == null || model == null) {
            return "{\"error\":\"知识库向量组件未就绪\"}";
        }
        if (StrUtil.isBlank(query)) {
            return "{\"error\":\"query 不能为空\"}";
        }

        try {
            Filter filter = buildFilter(province, year, subject);
            AgentProperties.Rag rag = agentProperties.getRag();
            int maxResults = Math.max(rag.getMaxResults(), 8);
            double minScore = filter != null ? Math.min(rag.getMinScore(), 0.25) : rag.getMinScore();

            Embedding embedding = model.embed(query.trim()).content();
            var reqBuilder = EmbeddingSearchRequest.builder()
                    .queryEmbedding(embedding)
                    .maxResults(maxResults)
                    .minScore(minScore);
            if (filter != null) {
                reqBuilder.filter(filter);
            }

            EmbeddingSearchResult<TextSegment> result = store.search(reqBuilder.build());
            List<EmbeddingMatch<TextSegment>> matches = result == null ? List.of() : result.matches();

            // 带过滤无结果时，放宽为仅语义检索一次，避免科目别名过严
            if (matches.isEmpty() && filter != null) {
                log.debug("searchKnowledge filtered empty, retry without filter: {}", query);
                result = store.search(EmbeddingSearchRequest.builder()
                        .queryEmbedding(embedding)
                        .maxResults(maxResults)
                        .minScore(rag.getMinScore())
                        .build());
                matches = result == null ? List.of() : result.matches();
            }

            List<Map<String, Object>> snippets = new ArrayList<>();
            for (EmbeddingMatch<TextSegment> match : matches) {
                TextSegment seg = match.embedded();
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("score", match.score());
                if (seg != null && seg.metadata() != null) {
                    row.put("province", seg.metadata().getString("province"));
                    row.put("subject", seg.metadata().getString("subject"));
                    row.put("year", seg.metadata().getString("year"));
                    row.put("source", seg.metadata().getString("source"));
                }
                String text = seg == null ? "" : seg.text();
                if (text.length() > MAX_SNIPPET_CHARS) {
                    text = text.substring(0, MAX_SNIPPET_CHARS) + "…";
                }
                row.put("text", text);
                snippets.add(row);
            }

            Map<String, Object> out = new LinkedHashMap<>();
            out.put("query", query.trim());
            out.put("province", blankToNull(province));
            out.put("year", year);
            out.put("subject", blankToNull(subject));
            out.put("hitCount", snippets.size());
            out.put("snippets", snippets);
            out.put("hint", snippets.isEmpty()
                    ? "无命中；可换科目名再试，或 listPapers 确认是否有该年试卷"
                    : "请依据 snippets 作答，并标明年份/科目；勿编造未出现的题目");
            return JSONUtil.toJsonStr(out);
        } catch (Exception e) {
            log.warn("searchKnowledge failed: {}", e.getMessage());
            return "{\"error\":\"知识库检索异常: " + escape(e.getMessage()) + "\"}";
        }
    }

    private static Filter buildFilter(String province, Integer year, String subject) {
        List<Filter> parts = new ArrayList<>();
        if (StrUtil.isNotBlank(province)) {
            parts.add(metadataKey("province").isEqualTo(province.trim()));
        }
        if (year != null) {
            parts.add(metadataKey("year").isEqualTo(String.valueOf(year)));
        }
        if (StrUtil.isNotBlank(subject)) {
            parts.add(metadataKey("subject").isEqualTo(SubjectAlias.normalize(subject.trim())));
        }
        if (parts.isEmpty()) {
            return null;
        }
        Filter acc = parts.get(0);
        for (int i = 1; i < parts.size(); i++) {
            acc = acc.and(parts.get(i));
        }
        return acc;
    }

    private static String blankToNull(String s) {
        return StrUtil.isBlank(s) ? null : s.trim();
    }

    private static String escape(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
