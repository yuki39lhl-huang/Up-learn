package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 院校开设专业表 {@code school_major}：某校某年对该词典专业的招生信息。
 */
@Data
@TableName("school_major")
public class SchoolMajor {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("school_id")
    private Long schoolId;
    /** 关联 {@link MajorDict#getId()} */
    @TableField("major_dict_id")
    private Long majorDictId;
    @TableField("exam_subjects")
    private String examSubjects;
    @TableField("avg_score")
    private Integer avgScore;
    private Integer enrollment;
    private Integer tuition;
    @TableField("min_score")
    private Integer minScore;
    private Integer year;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
