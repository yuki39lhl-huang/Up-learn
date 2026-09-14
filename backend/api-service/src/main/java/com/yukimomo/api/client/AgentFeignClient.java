package com.yukimomo.api.client;

import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.api.feign.FeignUserIdConfig;
import com.yukimomo.common.domain.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * 调用 agent-service：主观题评分。
 */
@FeignClient(
        name = "agent-service",
        contextId = "agentFeignClient",
        path = "/api/agent",
        configuration = FeignUserIdConfig.class
)
public interface AgentFeignClient {

    @PostMapping("/score")
    Result<ScoreResultVO> score(@RequestBody ScoreRequestDTO dto);
}
