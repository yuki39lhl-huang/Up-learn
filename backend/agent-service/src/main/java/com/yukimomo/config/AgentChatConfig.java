package com.yukimomo.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * 一点通对话基础配置。
 * 会话记忆见 {@link ResettableChatMemoryProvider}；
 * RAG 见 {@link AgentRagConfig}；Tool 见 UpLearnQueryTools / KnowledgeSearchTools。
 */
@Configuration
@RequiredArgsConstructor
@EnableConfigurationProperties(AgentProperties.class)
public class AgentChatConfig {
}
