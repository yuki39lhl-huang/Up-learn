package com.yukimomo.user.config;

import com.yukimomo.user.mq.LoginCodeMqConstants;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ：验证码投递交换机 / 队列 / JSON 转换器。
 */
@Configuration
@ConditionalOnProperty(prefix = "ul.login", name = "mq-enabled", havingValue = "true", matchIfMissing = true)
public class LoginCodeMqConfig {

    @Bean
    public DirectExchange loginCodeExchange() {
        return new DirectExchange(LoginCodeMqConstants.EXCHANGE, true, false);
    }

    @Bean
    public Queue loginCodeQueue() {
        return new Queue(LoginCodeMqConstants.QUEUE, true);
    }

    @Bean
    public Binding loginCodeBinding(Queue loginCodeQueue, DirectExchange loginCodeExchange) {
        return BindingBuilder.bind(loginCodeQueue)
                .to(loginCodeExchange)
                .with(LoginCodeMqConstants.ROUTING_KEY);
    }

    @Bean
    public MessageConverter loginCodeMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
