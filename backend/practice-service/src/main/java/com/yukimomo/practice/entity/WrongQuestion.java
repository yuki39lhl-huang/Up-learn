package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 错题本表 {@code wrong_question}。
 * <p>
 * 唯一键 {@code (user_id, question_id)}：同一用户同一题只一行，
 * 再次答错则 {@link #wrongCount}+1 并刷新 {@link #lastWrongAt}。
 * 一期答对不自动从错题本移除。
 */
@Data
@TableName("wrong_question")
public class WrongQuestion {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("user_id")
    private Long userId;
    @TableField("question_id")
    private Long questionId;
    /** 累计错误次数 */
    @TableField("wrong_count")
    private Integer wrongCount;
    /** 最近一次答错时间，列表按此倒序 */
    @TableField("last_wrong_at")
    private LocalDateTime lastWrongAt;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
