package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperSubmitResultVO {
    private Long attemptId;
    private Long paperId;
    private Integer objectiveScore;
    private Integer objectiveTotal;
    private List<PaperQuestionVO> questions;
}
