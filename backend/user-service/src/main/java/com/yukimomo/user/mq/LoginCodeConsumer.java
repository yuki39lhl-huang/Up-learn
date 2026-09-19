package com.yukimomo.user.mq;

import com.yukimomo.user.service.LoginCodeMailSender;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * 异步消费验证码投递：开发模式打日志，否则 QQ SMTP 发信。
 */
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.login", name = "mq-enabled", havingValue = "true", matchIfMissing = true)
public class LoginCodeConsumer {

    private final LoginCodeMailSender loginCodeMailSender;

    @RabbitListener(queues = LoginCodeMqConstants.QUEUE)
    public void onMessage(LoginCodeMessage message) {
        if (message == null) {
            return;
        }
        loginCodeMailSender.dispatch(message.email(), message.code(), message.scene());
    }
}
