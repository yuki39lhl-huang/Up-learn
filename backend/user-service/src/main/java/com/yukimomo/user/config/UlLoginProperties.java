package com.yukimomo.user.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 邮箱验证码登录相关配置（{@code ul.login.*}）。
 */
@Data
@ConfigurationProperties(prefix = "ul.login")
public class UlLoginProperties {

    /** 验证码在 Redis 中的有效期（秒），默认 5 分钟 */
    private int codeTtlSeconds = 300;
    /** 同一邮箱两次发送的最小间隔（秒） */
    private int sendIntervalSeconds = 60;
    /** 开发模式：验证码仅打日志，不真实发邮件 */
    private boolean devLogCode = true;
    /** 是否经 RabbitMQ 异步投递验证码；MQ 不可用时自动降级同步 */
    private boolean mqEnabled = true;
}
