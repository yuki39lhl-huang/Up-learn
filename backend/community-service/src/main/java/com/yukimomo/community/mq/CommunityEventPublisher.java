package com.yukimomo.community.mq;

import com.yukimomo.community.config.UlCommunityProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class CommunityEventPublisher {

    private final UlCommunityProperties properties;
    private final ObjectProvider<RabbitTemplate> rabbitTemplateProvider;

    public void publish(CommunityEventMessage message) {
        if (!properties.isMqEnabled()) {
            return;
        }
        RabbitTemplate template = rabbitTemplateProvider.getIfAvailable();
        if (template == null) {
            return;
        }
        try {
            template.convertAndSend(
                    CommunityMqConstants.EXCHANGE,
                    CommunityMqConstants.ROUTING_KEY,
                    message);
        } catch (Exception e) {
            log.warn("社区事件投递失败: {}", e.getMessage());
        }
    }
}
