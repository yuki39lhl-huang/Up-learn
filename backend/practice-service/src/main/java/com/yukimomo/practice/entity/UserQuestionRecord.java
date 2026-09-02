package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户题目调度表 {@code user_question_record}。
 * <p>
 * 驱动随机刷题间隔复习；与手动错题本（{@code wrong_question}）独立。
 */
@Data
@TableName("user_question_record")
public class UserQuestionRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    @TableField("question_id")
    private Long questionId;

    /** NEW / WRONG / RIGHT，见 {@link com.yukimomo.practice.constant.QuestionRecordStatus}。 */
    private String status;

    @TableField("last_answer_time")
    private LocalDateTime lastAnswerTime;

    /** 允许再次进入随机池的最早时间；WRONG 时可为 null。 */
    @TableField("next_review_time")
    private LocalDateTime nextReviewTime;

    @TableField("wrong_count")
    private Integer wrongCount;

    @TableField("right_count")
    private Integer rightCount;

    @TableField("review_interval_days")
    private Integer reviewIntervalDays;

    @TableField("created_at")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
