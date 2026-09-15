package com.yukimomo.controller;

import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.service.AgentService;
import com.yukimomo.vo.AgentStatusVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.nio.charset.StandardCharsets;

/**
 * AI 入口（路径前缀 /api/agent），仅做鉴权与参数转发。
 * <ul>
 *   <li>{@code /chat/stream}：一点通流式答疑</li>
 *   <li>{@code /score}：主观题单次 LLM 评分</li>
 *   <li>{@code /status}：能力开关</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/agent")
@RequiredArgsConstructor
public class AgentController {

    private final AgentService agentService;

    @GetMapping("/status")
    public Result<AgentStatusVO> status() {
        return Result.ok(agentService.status());
    }

    @GetMapping(value = "/chat/stream", produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<Flux<String>> streamChat(
            @RequestParam String message,
            @RequestParam(required = false) String sessionId) {
        Long userId = UserContext.requireUserId();
        Flux<String> body = agentService.streamChat(userId, sessionId, message);
        return ResponseEntity.ok()
                .contentType(new MediaType(MediaType.TEXT_PLAIN, StandardCharsets.UTF_8))
                .header(HttpHeaders.CACHE_CONTROL, "no-cache, no-transform")
                .header(HttpHeaders.CONNECTION, "keep-alive")
                .header("X-Accel-Buffering", "no")
                .body(body);
    }

    @PostMapping("/score")
    public Result<ScoreResultVO> score(@Valid @RequestBody ScoreRequestDTO dto) {
        UserContext.requireUserId();
        return Result.ok(agentService.score(dto));
    }
}
