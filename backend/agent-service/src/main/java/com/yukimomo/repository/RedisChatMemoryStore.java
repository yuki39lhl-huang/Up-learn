package com.yukimomo.repository;

import dev.langchain4j.data.message.ChatMessage;
import dev.langchain4j.data.message.ChatMessageDeserializer;
import dev.langchain4j.data.message.ChatMessageSerializer;
import dev.langchain4j.store.memory.chat.ChatMemoryStore;
import jakarta.annotation.Resource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.List;

@Repository//交给 IOC容器管理
public class RedisChatMemoryStore implements ChatMemoryStore {

    private static final String prerequisite = "chat:sql:";

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public List<ChatMessage> getMessages(Object memoryId) {
        //获取会话信息
        String json = stringRedisTemplate.opsForValue().get(prerequisite + memoryId.toString());
        //反序列化
        return ChatMessageDeserializer.messagesFromJson(json);
    }

    @Override
    public void updateMessages(Object memoryId, List<ChatMessage> list) {
        //更新会话消息
        //把list序列化json
        String json = ChatMessageSerializer.messagesToJson(list);
        //把json数据存储到 redis
        stringRedisTemplate.opsForValue().set(prerequisite+memoryId.toString(), json, Duration.ofDays(1));
    }

    @Override
    public void deleteMessages(Object memoryId) {
        //根据 Id删除会话消息
        stringRedisTemplate.delete(prerequisite + memoryId.toString());
    }
}
