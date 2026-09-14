package com.yukimomo.practice.client;

import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.api.client.AgentFeignClient;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * practice → agent 主观评分（Feign）。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AgentScoreClient {

    private final AgentFeignClient agentFeignClient;

    public ScoreResultVO score(
            String subject,
            String qType,
            String stem,
            String userAnswer,
            String standardAnswer,
            String rubric,
            Integer maxScore) {
        ScoreRequestDTO dto = new ScoreRequestDTO();
        dto.setSubject(subject);
        dto.setQType(qType);
        dto.setStem(stem);
        dto.setUserAnswer(userAnswer);
        dto.setStandardAnswer(standardAnswer);
        dto.setRubric(rubric);
        dto.setMaxScore(maxScore);
        try {
            Result<ScoreResultVO> result = agentFeignClient.score(dto);
            if (result == null || result.getCode() != ErrorCode.SUCCESS.getCode() || result.getData() == null) {
                String msg = result != null ? result.getMsg() : "空响应";
                log.warn("agent score business fail: {}", msg);
                throw new BizException(ErrorCode.AGENT_SCORE_FAILED, msg);
            }
            return result.getData();
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            log.warn("agent score Feign failed: {}", e.getMessage());
            throw new BizException(ErrorCode.AGENT_SCORE_FAILED);
        }
    }
}
