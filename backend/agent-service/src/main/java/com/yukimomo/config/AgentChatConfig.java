package com.yukimomo.config;

import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.store.memory.chat.ChatMemoryStore;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * 一点通对话基础：会话记忆。
 * RAG 向量入库见 {@link AgentRagConfig}；知识库检索走 Tool {@link com.yukimomo.tool.KnowledgeSearchTools}；
 * 查库 Tool 见 {@link com.yukimomo.tool.UpLearnQueryTools}；主观题评分见 {@link com.yukimomo.service.ScoreService}。
 */
@Configuration
@RequiredArgsConstructor
@EnableConfigurationProperties(AgentProperties.class)
public class AgentChatConfig {

    private final ChatMemoryStore redisChatMemoryStore;

    @Bean
    ChatMemoryProvider chatMemoryProvider() {
        return memoryId -> MessageWindowChatMemory.builder()
                .id(memoryId)
                .maxMessages(20)
                .chatMemoryStore(redisChatMemoryStore)
                .build();
    }

    /**
     * 未开 RAG 时的空检索；开启时由 {@link AgentRagConfig#contentRetriever} 提供同名 Bean。
     */
    @Bean
    @ConditionalOnProperty(prefix = "ul.agent.rag", name = "enabled", havingValue = "false", matchIfMissing = true)
    ContentRetriever contentRetriever() {
        return query -> List.of();
    }
}
