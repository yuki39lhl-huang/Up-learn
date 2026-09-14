package com.yukimomo.api.agent.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 主观题 AI 评分结果（跨服务契约）。
 */
@Data
public class ScoreResultVO {

    private BigDecimal score;
    private Integer maxScore;
    private String feedback;
}
