package com.yukimomo.common.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * JWT 相关配置，绑定 {@code ul.jwt.*}。
 * <p>
 * 双 Token 模式下仅 Access Token 使用 JWT；Refresh Token 由 user-service 存 Redis。
 */
@Data
@ConfigurationProperties(prefix = "ul.jwt")
public class UlJwtProperties {

    /**
     * HMAC 签名密钥。开发环境有默认值，生产必须覆盖。
     */
    private String secret = "up-learn-dev-jwt-secret-key-change-in-production!!";

    /**
     * Access Token 有效期（毫秒）。默认 1_800_000 = 30 分钟。
     */
    private long accessTtlMs = 1_800_000L;
}
