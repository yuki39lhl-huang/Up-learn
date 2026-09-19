package com.yukimomo.community.config;

import com.yukimomo.community.mq.CommunityMqConstants;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnProperty(prefix = "ul.community", name = "mq-enabled", havingValue = "true", matchIfMissing = true)
public class CommunityMqConfig {

    @Bean
    public DirectExchange communityExchange() {
        return new DirectExchange(CommunityMqConstants.EXCHANGE, true, false);
    }

    @Bean
    public Queue communityQueue() {
        return new Queue(CommunityMqConstants.QUEUE, true);
    }

    @Bean
    public Binding communityBinding(Queue communityQueue, DirectExchange communityExchange) {
        return BindingBuilder.bind(communityQueue).to(communityExchange).with(CommunityMqConstants.ROUTING_KEY);
    }

    @Bean
    public MessageConverter communityMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
