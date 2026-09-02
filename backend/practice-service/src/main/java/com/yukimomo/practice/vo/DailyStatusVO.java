package com.yukimomo.practice.vo;

import lombok.Data;

/**
 * 每日一练当日状态（是否已完成、锁定科目、当日题目 id）。
 */
@Data
public class DailyStatusVO {

    /** 今日是否已完成每日一练（仅计 source=daily 的提交） */
    private boolean completedToday;
    /** 今日锁定的练习科目；未完成前可切换并换题 */
    private String subject;
    /** 当日题目 id；未抽题时为 null */
    private Long questionId;
    /** 今日已提交时回填，用于刷新后恢复作答与解析 */
    private String userAnswer;
    private Boolean correct;
    private String answer;
    private String analysis;
    /** 今日已完成时随机展示的鼓励寄语 */
    private String encouragement;
}
