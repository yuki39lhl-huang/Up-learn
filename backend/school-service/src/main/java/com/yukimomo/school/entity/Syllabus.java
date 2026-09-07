package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 专升本考纲（省 + 年 + 科目 → 结构化正文）。
 * <p>
 * JSON 列在实体中以 {@link String} 存放，业务层用 Hutool 解析。
 */
@Data
@TableName("syllabus")
public class Syllabus {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 省份：广东 / 山东 */
    private String province;

    /** 考纲年份 */
    private Integer year;

    /** 科目展示名（与官方一致） */
    private String subject;

    /** 来源说明 */
    @TableField("source_title")
    private String sourceTitle;

    /** 考试范围树 JSON */
    @TableField("scope_json")
    private String scopeJson;

    /** 参考书目 JSON 数组 */
    @TableField("references_json")
    private String referencesJson;

    /** 指定篇目 JSON 数组（可空） */
    @TableField("designated_works_json")
    private String designatedWorksJson;

    @TableField("created_at")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
