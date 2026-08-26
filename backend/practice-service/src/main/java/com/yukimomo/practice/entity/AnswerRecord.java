package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 作答历史表 {@code answer_record}。
 * <p>
 * 每次提交答案插入一行；跨服务只存 {@link #userId}，不存用户详情。
 * 本表无逻辑删除字段，历史永久保留便于统计与回溯。
 */
@Data
@TableName("answer_record")
public class AnswerRecord {

    @TableId(type = IdType.AUTO)
    private Long id;
    /** 答题用户，对应 user-service 的 user.id */
    @TableField("user_id")
    private Long userId;
    /** 题目 ID，对应 {@link Question#getId()} */
    @TableField("question_id")
    private Long questionId;
    /** 用户所选答案（一般已规范化为大写 A/B/C/D） */
    @TableField("user_answer")
    private String userAnswer;
    /** 是否正确：1 正确，0 错误 */
    private Integer correct;
    /** 来源标识：daily / random / submit 等，便于前端区分入口 */
    private String source;
    @TableField("created_at")
    private LocalDateTime createdAt;
}
