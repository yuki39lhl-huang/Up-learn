package com.yukimomo.config;

import com.yukimomo.service.ChatService;
import dev.langchain4j.community.store.embedding.redis.RedisEmbeddingStore;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentSplitter;
import dev.langchain4j.data.document.loader.ClassPathDocumentLoader;
import dev.langchain4j.data.document.loader.FileSystemDocumentLoader;
import dev.langchain4j.data.document.parser.apache.pdfbox.ApachePdfBoxDocumentParser;
import dev.langchain4j.data.document.splitter.DocumentSplitters;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import dev.langchain4j.store.memory.chat.ChatMemoryStore;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.util.List;

@Configuration
@RequiredArgsConstructor
public class CommonConfig {

    private final OpenAiChatModel llm;
    private final ChatMemoryStore redisChatMemoryStore;
    private final EmbeddingModel embeddingModel;
    private final RedisEmbeddingStore redisEmbeddingStore;

    /*@Bean
    ChatService chatService(){
        return AiServices.builder(ChatService.class)
                .chatModel(llm)
                .build();
    }*/

    //构建会话记忆对象
    @Bean
    ChatMemory chatMemory(){
        return MessageWindowChatMemory.builder()
                .maxMessages(20)
                .build();
    }

    //构建 chatMemoryProvider对象
    @Bean
    ChatMemoryProvider chatMemoryProvider(){
        return new ChatMemoryProvider() {
            @Override
            public ChatMemory get(Object memoryId) {
                return MessageWindowChatMemory.builder()
                        .id(memoryId)
                        .maxMessages(20)
                        .chatMemoryStore(redisChatMemoryStore)
                        .build();
            }
        };
    }

    //构建向量数据库操作对象
    //@Bean//缓存一次到redis之后可以注释掉
    @Primary
    EmbeddingStore story(){
        //加载文档进内存
        //List<Document> documents = List.of(FileSystemDocumentLoader.loadDocument("E:\\GrammarPractice\\IdeaProject\\up-learn\\backend\\agent-service\\src\\main\\resources\\content\\天坑专业top10.md"));
        //List<Document> documents = ClassPathDocumentLoader.loadDocuments("content");
        List<Document> documents = ClassPathDocumentLoader.loadDocuments("content",new ApachePdfBoxDocumentParser());
        //构建向量数据库操作对象-操作内存版本的向量数据库
        //InMemoryEmbeddingStore story = new InMemoryEmbeddingStore();


        //构建文档分割器对象
        DocumentSplitter ds = DocumentSplitters.recursive(500, 100);
        //构建一个 EmbeddingStoreIngestor对象,完成本地数据切割向量化,存储
        EmbeddingStoreIngestor.builder()
                //.embeddingStore(story)
                .embeddingStore(redisEmbeddingStore)
                .documentSplitter(ds)
                .embeddingModel(embeddingModel)
                .build()
                .ingest(documents);
        return redisEmbeddingStore;
    }

    //构建向量数据库检索对象
    @Bean
    ContentRetriever contentRetriever(/*EmbeddingStore store*/){
        return EmbeddingStoreContentRetriever.builder()
                .embeddingStore(redisEmbeddingStore)
                .minScore(0.5)
                .maxResults(3)
                .embeddingModel(embeddingModel)
                .build();
    }
}
