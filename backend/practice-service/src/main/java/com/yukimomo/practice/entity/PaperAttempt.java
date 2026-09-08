package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("paper_attempt")
public class PaperAttempt {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("user_id")
    private Long userId;
    @TableField("paper_id")
    private Long paperId;
    /** in_progress | submitted */
    private String status;
    @TableField("objective_score")
    private Integer objectiveScore;
    @TableField("objective_total")
    private Integer objectiveTotal;
    @TableField("submitted_at")
    private LocalDateTime submittedAt;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
