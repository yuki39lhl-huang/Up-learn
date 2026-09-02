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
 * 仅用户手动「加入错题本」时写入；与间隔复习调度表 {@code user_question_record} 独立。
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
    /** 加入错题本时用户的错选快照。 */
    @TableField("user_answer")
    private String userAnswer;
    /** 加入时的解析快照。 */
    @TableField("analysis_snapshot")
    private String analysisSnapshot;
    /** 累计加入/答错次数（重复加入时 +1）。 */
    @TableField("wrong_count")
    private Integer wrongCount;
    /** 最近一次加入时间，列表按此倒序。 */
    @TableField("last_wrong_at")
    private LocalDateTime lastWrongAt;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
