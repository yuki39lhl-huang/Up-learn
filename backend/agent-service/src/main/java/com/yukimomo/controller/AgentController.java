package com.yukimomo.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.dto.ChatRequestDTO;
import com.yukimomo.service.ChatService;
import com.yukimomo.vo.ChatReplyVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.util.UUID;

/**
 * 一点通 AI 对话入口（路径前缀 /api/agent）。
 * <p>
 * 鉴权：走网关 JWT，{@link UserContext#requireUserId()} 获取当前用户；
 * 会话记忆按 {@code userId:sessionId} 隔离，支持 RAG 检索增强回答。
 */
@RestController
@RequestMapping("/api/agent")
@RequiredArgsConstructor
public class AgentController {

    private final ChatService chatService;

    @PostMapping("/chat")
    public Result<ChatReplyVO> chat(@Valid @RequestBody ChatRequestDTO dto) {
        Long userId = UserContext.requireUserId();
        String sessionId = resolveSessionId(dto.getSessionId());
        String memoryId = memoryKey(userId, sessionId);

        String reply = chatService.fluChat(memoryId, dto.getMessage())
                .collectList()
                .map(chunks -> String.join("", chunks))
                .block();

        ChatReplyVO vo = new ChatReplyVO();
        vo.setReply(reply != null ? reply : "");
        vo.setSessionId(sessionId);
        return Result.ok(vo);
    }

    @GetMapping(value = "/chat/stream", produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
    public Flux<String> streamChat(
            @RequestParam String message,
            @RequestParam(required = false) String sessionId) {
        Long userId = UserContext.requireUserId();
        String sid = resolveSessionId(sessionId);
        return chatService.fluChat(memoryKey(userId, sid), message);
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
