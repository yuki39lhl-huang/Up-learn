package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperQuestionVO {
    private Long id;
    private Integer seq;
    /** 卷面题号；材料为空 */
    private Integer paperNo;
    private String qType;
    /** 卷面大题标题 */
    private String sectionTitle;
    private String stem;
    private List<String> options;
    private Integer score;
    private String inputMode;
    /** 是否有标准答案（不泄露答案内容；无答案选择题交卷不计入客观分母） */
    private Boolean hasStandardAnswer;
    /** 仅交卷后返回 */
    private String answer;
    private String analysis;
    private String userAnswer;
    private Boolean correct;
    /** AI 建议分（仅供参考；交卷后按需评分） */
    private java.math.BigDecimal aiScore;
    /** AI 评语（仅供参考） */
    private String aiFeedback;
}
