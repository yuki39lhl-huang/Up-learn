package com.yukimomo.api.agent.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

/**
 * 主观题单次 LLM 评分请求（跨服务契约）。
 */
@Data
public class ScoreRequestDTO {

    private String subject;
    private String qType;

    @NotBlank(message = "题干不能为空")
    private String stem;

    @NotBlank(message = "考生作答不能为空")
    private String userAnswer;

    private String standardAnswer;
    private String rubric;

    @NotNull(message = "满分不能为空")
    @Positive(message = "满分须为正数")
    private Integer maxScore;
}
