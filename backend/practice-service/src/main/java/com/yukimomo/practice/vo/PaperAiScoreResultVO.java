package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperAiScoreResultVO {
    private Long attemptId;
    private Long paperId;
    /** 本次成功评分题数 */
    private Integer scoredCount;
    /** 跳过（无作答/高数/已评等）题数 */
    private Integer skippedCount;
    private List<PaperQuestionVO> questions;
}
