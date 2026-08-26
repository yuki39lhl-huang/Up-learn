package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

/**
 * 出题对外 VO（每日一练 / 随机刷题）。
 * <p>
 * 刻意不含 answer、analysis，避免前端未提交前泄露正确答案。
 */
@Data
public class QuestionVO {

    private Long id;
    /** 科目名 */
    private String subject;
    /** 题干 */
    private String stem;
    /** 选项列表，已从 options_json 解析，如 ["A.xxx","B.xxx",...] */
    private List<String> options;
    /** 难度，可空 */
    private Integer difficulty;
}
