package com.yukimomo.practice.dto;

import lombok.Data;

import java.util.List;

/**
 * 交卷后按需触发主观题 AI 评分。
 */
@Data
public class PaperAiScoreDTO {

    /** 指定题目；空则对本卷全部可评主观题评分 */
    private List<Long> questionIds;

    /** 已有 AI 分时是否强制重评 */
    private Boolean force;

    /**
     * 模考模式：为 true 时拒绝评分（练习开 / 模考关）。
     */
    private Boolean mockExam;
}
