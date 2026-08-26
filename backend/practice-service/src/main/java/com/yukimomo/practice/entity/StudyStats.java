package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 学习统计汇总表 {@code study_stats}。
 * <p>
 * 每用户一行（唯一键 user_id）；每次提交 upsert：
 * 累加答题数/正确数，重算正确率，按「日」规则维护 {@link #streak}。
 * {@link #updatedAt} 兼作「上次有提交的日期」依据（读出后再 update）。
 */
@Data
@TableName("study_stats")
public class StudyStats {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("user_id")
    private Long userId;
    /** 累计答题次数 */
    @TableField("total_answered")
    private Integer totalAnswered;
    /** 累计答对次数 */
    @TableField("correct_count")
    private Integer correctCount;
    /** 正确率百分比，如 85.00 表示 85% */
    private BigDecimal accuracy;
    /** 连续打卡天数（一期简单规则：当日维持 / 昨日则 +1 / 否则重置为 1） */
    private Integer streak;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
    @TableField("created_at")
    private LocalDateTime createdAt;
}
