package com.yukimomo.practice.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 学习统计对外 VO。
 * <p>
 * 库中无记录时 Service 返回全 0，避免前端判空。
 */
@Data
public class StudyStatsVO {

    /** 累计答题数 */
    private Integer totalAnswered;
    /** 累计答对数 */
    private Integer correctCount;
    /** 正确率百分比，保留两位小数 */
    private BigDecimal accuracy;
    /** 连续打卡天数（仅 daily 签到） */
    private Integer streak;
    /** 累计签到天数（完成 daily 的去重日期数） */
    private Integer totalCheckInDays;
}
