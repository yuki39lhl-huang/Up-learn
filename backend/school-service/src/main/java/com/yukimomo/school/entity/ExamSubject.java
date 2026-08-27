package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 备考考试科目字典。
 */
@Data
@TableName("exam_subject")
public class ExamSubject {

    /** 主键。 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 科目名称。 */
    private String name;

    /** 科目类型：PUBLIC、FOUNDATION、COMPREHENSIVE。 */
    @TableField("subject_type")
    private String subjectType;

    /** 稳定业务编码，便于后续对接题库。 */
    private String code;

    /** 同类科目的展示顺序。 */
    @TableField("sort_order")
    private Integer sortOrder;

    /** 是否启用：1 启用，0 停用。 */
    private Integer enabled;

    /** 创建时间。 */
    @TableField("created_at")
    private LocalDateTime createdAt;

    /** 更新时间。 */
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
