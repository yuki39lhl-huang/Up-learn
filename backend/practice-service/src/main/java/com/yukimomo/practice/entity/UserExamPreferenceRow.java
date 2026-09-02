package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 用户备考设置只读投影（表 {@code user_exam_preference}，与 user-service 同库）。
 * <p>
 * practice-service 直接读取备考科目与随机筛选，避免一期引入 Feign。
 */
@Data
@TableName("user_exam_preference")
public class UserExamPreferenceRow {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    private String province;

    @TableField("cohort_year")
    private Integer cohortYear;

    @TableField("major_category")
    private String majorCategory;

    /** 三类考试科目 JSON，字段 public/foundation/comprehensive。 */
    @TableField("subject_selection_json")
    private String subjectSelectionJson;

    @TableField("daily_subject")
    private String dailySubject;

    /** 仅每日一练使用：fixed / random。 */
    @TableField("daily_subject_mode")
    private String dailySubjectMode;

    /** 随机刷题筛选：all / single。 */
    @TableField("random_subject_mode")
    private String randomSubjectMode;

    /** single 时的题库科目名，如高等数学。 */
    @TableField("random_subject")
    private String randomSubject;
}
