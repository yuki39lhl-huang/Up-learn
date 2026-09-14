package com.yukimomo.controller;

import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.config.AgentProperties;
import com.yukimomo.dto.ChatRequestDTO;
import com.yukimomo.service.ChatService;
import com.yukimomo.service.ScoreService;
import com.yukimomo.service.UserProfileContextBuilder;
import com.yukimomo.vo.AgentStatusVO;
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
 * AI 入口（路径前缀 /api/agent）。
 * <ul>
 *   <li>{@code /chat}：一点通多轮答疑（记忆 + 备考档案 + 可选 RAG + Tool）</li>
 *   <li>{@code /score}：主观题单次 LLM 评分（不走对话循环）</li>
 *   <li>{@code /status}：能力开关（供前端状态条）</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/agent")
@RequiredArgsConstructor
public class AgentController {

    private final ChatService chatService;
    private final ScoreService scoreService;
    private final UserProfileContextBuilder profileContextBuilder;
    private final AgentProperties agentProperties;

    @GetMapping("/status")
    public Result<AgentStatusVO> status() {
        AgentProperties.Rag rag = agentProperties.getRag();
        AgentStatusVO vo = new AgentStatusVO();
        vo.setRagEnabled(rag.isEnabled());
        vo.setRagIngestOnStartup(rag.isIngestOnStartup());
        if (!rag.isEnabled()) {
            vo.setRagEmbedding("off");
        } else {
            String mode = StringUtils.hasText(rag.getEmbedding()) ? rag.getEmbedding().trim().toLowerCase() : "auto";
            boolean hasDash = StringUtils.hasText(System.getenv("DASHSCOPE_API_KEY"));
            if ("local".equals(mode) || ("auto".equals(mode) && !hasDash)) {
                vo.setRagEmbedding("local");
            } else {
                vo.setRagEmbedding("dashscope");
            }
        }
        return Result.ok(vo);
    }

    @PostMapping("/chat")
    public Result<ChatReplyVO> chat(@Valid @RequestBody ChatRequestDTO dto) {
        Long userId = UserContext.requireUserId();
        String sessionId = resolveSessionId(dto.getSessionId());
        String memoryId = memoryKey(userId, sessionId);
        String profileContext = profileContextBuilder.build(userId);

        String reply = chatService.fluChat(memoryId, profileContext, dto.getMessage())
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
        String profileContext = profileContextBuilder.build(userId);
        return chatService.fluChat(memoryKey(userId, sid), profileContext, message);
    }

    @PostMapping("/score")
    public Result<ScoreResultVO> score(@Valid @RequestBody ScoreRequestDTO dto) {
        UserContext.requireUserId();
        return Result.ok(scoreService.score(dto));
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
