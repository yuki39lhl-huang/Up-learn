package com.yukimomo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * agent-service：对话 + 主观评分。
 * <p>
 * 排除 MySQL / MyBatis，以及 Redis 向量库<strong>自动</strong>配置（RAG 开启时由 {@code AgentRagConfig} 手工建库）。
 * 跨服务调用经 {@code api-service} Feign（user / school / practice）。
 */
@SpringBootApplication(excludeName = {
        "org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration",
        "com.baomidou.mybatisplus.autoconfigure.MybatisPlusAutoConfiguration",
        "dev.langchain4j.community.store.embedding.redis.spring.RedisEmbeddingStoreAutoConfiguration"
})
@EnableFeignClients(basePackages = "com.yukimomo.api.client")
public class AgentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AgentServiceApplication.class, args);
    }
}
