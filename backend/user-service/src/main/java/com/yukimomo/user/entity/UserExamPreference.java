package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户备考设置持久化实体。
 */
@Data
@TableName("user_exam_preference")
public class UserExamPreference {

    /** 主键。 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户 ID；跨服务只保存 ID。 */
    @TableField("user_id")
    private Long userId;

    /** 报考省份。 */
    private String province;

    /** 报考届别年份。 */
    @TableField("cohort_year")
    private Integer cohortYear;

    /** 专业类型。 */
    @TableField("major_category")
    private String majorCategory;

    /** 三类考试科目选择的 JSON 文本。 */
    @TableField("subject_selection_json")
    private String subjectSelectionJson;

    /** 每日一练科目。 */
    @TableField("daily_subject")
    private String dailySubject;

    /** 每日一练模式。 */
    @TableField("daily_subject_mode")
    private String dailySubjectMode;

    /** 随机刷题模式：all / single。 */
    @TableField("random_subject_mode")
    private String randomSubjectMode;

    /** single 时的题库科目。 */
    @TableField("random_subject")
    private String randomSubject;

    /** 创建时间。 */
    @TableField("created_at")
    private LocalDateTime createdAt;

    /** 更新时间。 */
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
