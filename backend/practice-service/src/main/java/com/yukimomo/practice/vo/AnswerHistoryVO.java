package com.yukimomo.practice.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 答题历史列表项 VO。
 * <p>
 * 以 answer_record 为主，补科目与题干便于前端展示；不含完整选项。
 */
@Data
public class AnswerHistoryVO {

    /** 作答记录主键 */
    private Long id;
    private Long questionId;
    private String subject;
    private String stem;
    private String userAnswer;
    /** 是否正确 */
    private Boolean correct;
    /** daily / random / submit 等 */
    private String source;
    private LocalDateTime createdAt;
}
