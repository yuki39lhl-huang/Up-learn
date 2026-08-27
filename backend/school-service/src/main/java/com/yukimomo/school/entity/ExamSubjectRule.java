package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 省份/专业类型与考试科目的匹配规则。
 */
@Data
@TableName("exam_subject_rule")
public class ExamSubjectRule {

    @TableId(type = IdType.AUTO)
    /** 主键。 */
    private Long id;

    /** 省份名称。 */
    private String province;

    /** 专业类型；为空表示该省通用规则。 */
    @TableField("major_category")
    private String majorCategory;

    /** 关联的考试科目字典 ID。 */
    @TableField("subject_id")
    private Long subjectId;

    /** 是否默认选中：1 是，0 否。 */
    @TableField("is_default")
    private Integer defaultFlag;

    /** 候选科目展示顺序。 */
    @TableField("sort_order")
    private Integer sortOrder;

    /** 规则适用年份；为空表示通用规则。 */
    private Integer year;

    /** 是否启用：1 启用，0 停用。 */
    private Integer enabled;

    /** 创建时间。 */
    @TableField("created_at")
    private LocalDateTime createdAt;

    /** 更新时间。 */
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
