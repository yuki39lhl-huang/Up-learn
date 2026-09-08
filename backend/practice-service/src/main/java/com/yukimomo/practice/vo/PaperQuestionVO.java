package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperQuestionVO {
    private Long id;
    private Integer seq;
    private String qType;
    private String stem;
    private List<String> options;
    private Integer score;
    private String inputMode;
    /** 仅交卷后返回 */
    private String answer;
    private String analysis;
    private String userAnswer;
    private Boolean correct;
}
