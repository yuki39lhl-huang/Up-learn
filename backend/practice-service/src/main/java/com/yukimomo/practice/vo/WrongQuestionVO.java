package com.yukimomo.practice.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 错题列表项 VO。
 * <p>
 * 来自 wrong_question + 批量查出的 question（题干/选项），避免列表 N+1。
 */
@Data
public class WrongQuestionVO {

    /** 错题本行主键 */
    private Long id;
    private Long questionId;
    private String subject;
    private String stem;
    private List<String> options;
    private Integer difficulty;
    /** 用户错选快照 */
    private String userAnswer;
    /** 正确答案 */
    private String answer;
    /** 解析（优先快照） */
    private String analysis;
    /** 累计加入次数 */
    private Integer wrongCount;
    /** 最近加入时间 */
    private LocalDateTime lastWrongAt;
    private LocalDateTime createdAt;
}
