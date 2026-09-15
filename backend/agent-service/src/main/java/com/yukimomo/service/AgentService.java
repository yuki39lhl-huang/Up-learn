package com.yukimomo.service;

import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.config.AgentProperties;
import com.yukimomo.config.ResettableChatMemoryProvider;
import com.yukimomo.vo.AgentStatusVO;
import dev.langchain4j.exception.InvalidRequestException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import reactor.core.publisher.Flux;

import java.util.UUID;

/**
 * agent-service 应用层编排：会话键、备考档案注入、状态汇总；
 * 真正的 LLM 调用交给 {@link ChatService} / {@link ScoreService}。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AgentService {

    private final ChatService chatService;
    private final ScoreService scoreService;
    private final UserProfileContextBuilder profileContextBuilder;
    private final AgentProperties agentProperties;
    private final ResettableChatMemoryProvider chatMemoryProvider;

    public AgentStatusVO status() {
        AgentProperties.Rag rag = agentProperties.getRag();
        AgentStatusVO vo = new AgentStatusVO();
        vo.setRagEnabled(rag.isEnabled());
        vo.setRagIngestOnStartup(rag.isIngestOnStartup());
        if (!rag.isEnabled()) {
            vo.setRagEmbedding("off");
            return vo;
        }
        String mode = StringUtils.hasText(rag.getEmbedding())
                ? rag.getEmbedding().trim().toLowerCase()
                : "auto";
        boolean hasDash = StringUtils.hasText(System.getenv("DASHSCOPE_API_KEY"));
        if ("local".equals(mode) || ("auto".equals(mode) && !hasDash)) {
            vo.setRagEmbedding("local");
        } else {
            vo.setRagEmbedding("dashscope");
        }
        return vo;
    }

    public Flux<String> streamChat(Long userId, String sessionId, String message) {
        String sid = resolveSessionId(sessionId);
        String memoryId = memoryKey(userId, sid);
        String profileContext = profileContextBuilder.build(userId);
        return chatService.fluChat(memoryId, profileContext, message)
                .onErrorResume(err -> {
                    if (!isBrokenToolMemory(err)) {
                        return Flux.error(err);
                    }
                    log.warn("Broken tool memory for {}, evict JVM+Redis and retry once", memoryId);
                    chatMemoryProvider.evict(memoryId);
                    return chatService.fluChat(memoryId, profileContext, message)
                            .onErrorResume(err2 -> {
                                if (!isBrokenToolMemory(err2)) {
                                    return Flux.error(err2);
                                }
                                chatMemoryProvider.evict(memoryId);
                                return Flux.just("会话记忆已重置（工具调用记录不完整）。请再发送一次相同问题即可。");
                            });
                });
    }

    public ScoreResultVO score(ScoreRequestDTO dto) {
        return scoreService.score(dto);
    }

    private static boolean isBrokenToolMemory(Throwable err) {
        Throwable cur = err;
        while (cur != null) {
            String msg = cur.getMessage();
            if (cur instanceof InvalidRequestException || (msg != null && msg.contains("invalid_request"))) {
                if (msg != null && (msg.contains("tool_calls") || msg.contains("role 'tool'") || msg.contains("tool messages"))) {
                    return true;
                }
            }
            if (msg != null && msg.contains("tool") && (msg.contains("tool_calls") || msg.contains("role 'tool'"))) {
                return true;
            }
            cur = cur.getCause();
        }
        return false;
    }

    private static String resolveSessionId(String sessionId) {
        if (StringUtils.hasText(sessionId)) {
            return sessionId.trim();
        }
        return UUID.randomUUID().toString().replace("-", "");
    }

    private static String memoryKey(Long userId, String sessionId) {
        return userId + ":" + sessionId;
    }
}
