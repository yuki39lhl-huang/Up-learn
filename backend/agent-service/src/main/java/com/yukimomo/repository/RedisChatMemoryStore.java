package com.yukimomo.repository;

import cn.hutool.core.util.StrUtil;
import dev.langchain4j.data.message.ChatMessage;
import dev.langchain4j.data.message.ChatMessageDeserializer;
import dev.langchain4j.data.message.ChatMessageSerializer;
import dev.langchain4j.store.memory.chat.ChatMemoryStore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Collections;
import java.util.List;

/**
 * 一点通会话记忆（Redis）。
 * <p>
 * 只在 {@link #getMessages} 时做轻量清洗；{@link #updateMessages} 原样写入，
 * 避免工具调用半途把 Ai(tool_calls) 清掉导致模型空转。
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class RedisChatMemoryStore implements ChatMemoryStore {

    private static final String KEY_PREFIX = "chat:memory:";

    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public List<ChatMessage> getMessages(Object memoryId) {
        String json = stringRedisTemplate.opsForValue().get(KEY_PREFIX + memoryId);
        if (StrUtil.isBlank(json)) {
            return Collections.emptyList();
        }
        try {
            List<ChatMessage> raw = ChatMessageDeserializer.messagesFromJson(json);
            return ChatMemorySanitizer.sanitize(raw);
        } catch (Exception e) {
            log.warn("Corrupt chat memory {}, clearing: {}", memoryId, e.getMessage());
            deleteMessages(memoryId);
            return Collections.emptyList();
        }
    }

    @Override
    public void updateMessages(Object memoryId, List<ChatMessage> list) {
        // 不要在这里 sanitize：MessageWindowChatMemory 每次 add 都是 get→add→update，
        // 若此时丢掉末尾 tool_calls，工具回包会对不上，表现为一直打日志无回复。
        String json = ChatMessageSerializer.messagesToJson(list == null ? List.of() : list);
        stringRedisTemplate.opsForValue().set(KEY_PREFIX + memoryId, json, Duration.ofDays(1));
    }

    @Override
    public void deleteMessages(Object memoryId) {
        stringRedisTemplate.delete(KEY_PREFIX + memoryId);
    }
}
