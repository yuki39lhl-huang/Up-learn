package com.yukimomo.user.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Refresh Token 配置（仅存 Redis，非 JWT）。
 */
@Data
@ConfigurationProperties(prefix = "ul.jwt")
public class UlRefreshTokenProperties {

    /** Refresh Token 在 Redis 中的有效期（秒），默认 7 天 */
    private int refreshTtlSeconds = 604_800;
}
