package com.yukimomo.user.mq;

import com.yukimomo.user.config.UlLoginProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;

/**
 * 验证码投递：优先 RabbitMQ，失败或关闭时由调用方降级同步处理。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LoginCodePublisher {

    private final UlLoginProperties loginProperties;
    private final ObjectProvider<RabbitTemplate> rabbitTemplateProvider;

    /**
     * @return true 已投递 MQ；false 应降级同步 dispatch
     */
    public boolean tryPublish(String email, String code, String scene) {
        if (!loginProperties.isMqEnabled()) {
            return false;
        }
        RabbitTemplate rabbitTemplate = rabbitTemplateProvider.getIfAvailable();
        if (rabbitTemplate == null) {
            return false;
        }
        try {
            rabbitTemplate.convertAndSend(
                    LoginCodeMqConstants.EXCHANGE,
                    LoginCodeMqConstants.ROUTING_KEY,
                    new LoginCodeMessage(email, code, scene));
            return true;
        } catch (Exception e) {
            log.warn("验证码 MQ 投递失败，将降级同步发送: {}", e.getMessage());
            return false;
        }
    }
}
