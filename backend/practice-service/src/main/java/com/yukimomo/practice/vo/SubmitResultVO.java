package com.yukimomo.practice.vo;

import lombok.Data;

/**
 * 提交判分结果 VO。
 * <p>
 * 提交后才返回标准答案与解析，供前端展示对错反馈。
 */
@Data
public class SubmitResultVO {

    private Long questionId;
    /** true=答对，false=答错 */
    private Boolean correct;
    /** 标准答案字母 */
    private String answer;
    /** 题目解析 */
    private String analysis;
    /** 用户实际提交的答案（规范化后） */
    private String userAnswer;
}
