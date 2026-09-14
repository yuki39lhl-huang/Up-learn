package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperDetailVO {
    private Long id;
    private String province;
    private String subject;
    private Integer year;
    private String title;
    private Boolean hasAnswer;
    private Boolean pdfAvailable;
    private Long attemptId;
    private String attemptStatus;
    /** 选择题总数（answerable） */
    private Integer choiceCount;
    /** 有标准答案、可机判的选择题数 */
    private Integer gradableChoiceCount;
    /** 已交卷时的客观题得分 */
    private Integer objectiveScore;
    /** 已交卷时的客观题满分 */
    private Integer objectiveTotal;
    private List<PaperQuestionVO> questions;
}
