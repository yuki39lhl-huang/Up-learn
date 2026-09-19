package com.yukimomo.community.mq;

import com.yukimomo.community.entity.CommunityNotification;
import com.yukimomo.community.mapper.CommunityNotificationMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.community", name = "mq-enabled", havingValue = "true", matchIfMissing = true)
public class CommunityEventConsumer {

    private final CommunityNotificationMapper notificationMapper;

    @RabbitListener(queues = CommunityMqConstants.QUEUE)
    public void onMessage(CommunityEventMessage message) {
        if (message == null || message.targetUserId() == null) {
            return;
        }
        if (message.actorId() != null && message.actorId().equals(message.targetUserId())) {
            return;
        }
        CommunityNotification row = new CommunityNotification();
        row.setUserId(message.targetUserId());
        row.setType(message.type());
        row.setRefId(message.refId());
        row.setActorId(message.actorId());
        row.setContent(message.content());
        row.setReadFlag(0);
        row.setCreatedAt(LocalDateTime.now());
        notificationMapper.insert(row);
        log.debug("社区通知已写入 userId={} type={}", message.targetUserId(), message.type());
    }
}
