package com.yukimomo.config;

import com.yukimomo.repository.RedisChatMemoryStore;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.concurrent.ConcurrentHashMap;

/**
 * 可重置的会话记忆 Provider（Bean 名须为 chatMemoryProvider，供 @AiService 引用）。
 * <p>
 * AiServices 会缓存 ChatMemory 实例；出错时必须 {@link #evict} 调用同一实例的 clear()，
 * 只删 Redis 无法清掉 JVM 里的坏 tool 消息。
 */
@Slf4j
@Component("chatMemoryProvider")
@RequiredArgsConstructor
public class ResettableChatMemoryProvider implements ChatMemoryProvider {

    private final RedisChatMemoryStore redisChatMemoryStore;
    private final ConcurrentHashMap<Object, ChatMemory> cache = new ConcurrentHashMap<>();

    @Override
    public ChatMemory get(Object memoryId) {
        return cache.computeIfAbsent(memoryId, this::create);
    }

    /**
     * 清空 AiServices 持有的同一 ChatMemory 实例 + Redis。
     * 不要 remove 缓存项：AiServices 仍引用原实例，clear 后即可安全重试。
     */
    public void evict(Object memoryId) {
        ChatMemory memory = cache.get(memoryId);
        if (memory == null) {
            // 尚未经本 Provider 创建时，仍清 Redis；并预创建空记忆供后续 get 命中
            memory = cache.computeIfAbsent(memoryId, this::create);
        }
        try {
            memory.clear();
        } catch (Exception e) {
            log.debug("ChatMemory.clear ignored: {}", e.getMessage());
        }
        redisChatMemoryStore.deleteMessages(memoryId);
        log.info("Cleared chat memory {}", memoryId);
    }

    private ChatMemory create(Object memoryId) {
        return MessageWindowChatMemory.builder()
                .id(memoryId)
                .maxMessages(40)
                .chatMemoryStore(redisChatMemoryStore)
                .build();
    }
}
