package com.yukimomo.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Agent RAG / 评分相关配置。
 */
@Data
@ConfigurationProperties(prefix = "ul.agent")
public class AgentProperties {

    private Rag rag = new Rag();

    @Data
    public static class Rag {
        /**
         * 是否启用向量检索（一点通 RAG）。
         * 向量写入现有 Redis 8（RediSearch），与会话记忆共用 {@code ul.redis}。
         */
        private boolean enabled = false;

        /** 启动时是否把 classpath:content 下答案 md 向量化（会先清空本索引） */
        private boolean ingestOnStartup = false;

        /**
         * embedding 后端：{@code auto}（有 DASHSCOPE_API_KEY 用通义，否则本地 AllMiniLm）、
         * {@code dashscope}、{@code local}。
         */
        private String embedding = "auto";

        /** 文档切割块大小 */
        private int segmentSize = 500;

        /** 切割重叠 */
        private int segmentOverlap = 80;

        /** 检索最低相似度 */
        private double minScore = 0.45;

        /** 检索条数 */
        private int maxResults = 5;
    }
}
