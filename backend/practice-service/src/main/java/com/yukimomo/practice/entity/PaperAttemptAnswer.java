package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("paper_attempt_answer")
public class PaperAttemptAnswer {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("attempt_id")
    private Long attemptId;
    @TableField("paper_question_id")
    private Long paperQuestionId;
    @TableField("user_answer")
    private String userAnswer;
    private Integer correct;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
