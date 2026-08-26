package com.yukimomo.practice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 提交答案请求体（POST /api/practice/submit）。
 * <p>
 * 配合 {@code @Valid}：缺 questionId / userAnswer 时由全局异常处理返回 400。
 */
@Data
public class SubmitAnswerDTO {

    /** 题目主键，必填 */
    @NotNull(message = "题目 ID 不能为空")
    private Long questionId;

    /** 用户选项，如 "B"；服务端会 trim + 转大写再比对 */
    @NotBlank(message = "答案不能为空")
    private String userAnswer;

    /**
     * 作答来源：daily / random 等。
     * 可空，空则落库为 "submit"。
     */
    private String source;
}
