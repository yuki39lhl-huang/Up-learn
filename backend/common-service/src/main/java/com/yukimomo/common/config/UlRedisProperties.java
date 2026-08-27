package com.yukimomo.common.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Redis 连接占位符（{@code ul.redis.*}）。
 */
@Data
@ConfigurationProperties(prefix = "ul.redis")
public class UlRedisProperties {

    /** 主机：local 用 localhost，dev/Docker 用 ul-redis-master */
    private String host = "localhost";

    /** 端口：local 映射 6380，容器内 6379 */
    private int port = 6380;
}
