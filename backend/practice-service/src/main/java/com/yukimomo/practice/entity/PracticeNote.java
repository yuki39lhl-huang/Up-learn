package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 随机刷题备忘录 {@code practice_note}。
 */
@Data
@TableName("practice_note")
public class PracticeNote {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    @TableField("question_id")
    private Long questionId;

    private String stem;

    private String analysis;

    @TableField("user_note")
    private String userNote;

    @TableField("created_at")
    private LocalDateTime createdAt;
}
