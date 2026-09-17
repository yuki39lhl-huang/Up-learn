package com.yukimomo.user.mq;

import com.yukimomo.user.config.UlLoginProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * 异步消费验证码投递：开发模式打日志（预留真实邮件）。
 */
@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.login", name = "mq-enabled", havingValue = "true", matchIfMissing = true)
public class LoginCodeConsumer {

    private final UlLoginProperties loginProperties;

    @RabbitListener(queues = LoginCodeMqConstants.QUEUE)
    public void onMessage(LoginCodeMessage message) {
        if (message == null) {
            return;
        }
        if (loginProperties.isDevLogCode()) {
            log.info("【开发模式·MQ】邮箱 {} {}验证码: {}（{} 秒内有效）",
                    message.email(),
                    message.scene(),
                    message.code(),
                    loginProperties.getCodeTtlSeconds());
            return;
        }
        log.warn("未开启 dev-log-code 且未配置邮件服务，验证码仅应通过 dev-log-code 调试");
        log.info("【MQ】邮箱 {} {}验证码: {}", message.email(), message.scene(), message.code());
    }
}
