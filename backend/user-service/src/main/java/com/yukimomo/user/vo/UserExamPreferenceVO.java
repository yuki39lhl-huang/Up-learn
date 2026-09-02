package com.yukimomo.user.vo;

import com.yukimomo.user.dto.ExamSubjectSelectionDTO;
import lombok.Data;

/**
 * 当前用户的备考设置。
 */
@Data
public class UserExamPreferenceVO {

    /** 记录主键。 */
    private Long id;

    /** 用户 ID。 */
    private Long userId;

    /** 报考省份。 */
    private String province;

    /** 报考届别年份。 */
    private Integer cohortYear;

    /** 专业类型。 */
    private String majorCategory;

    /** 用户选择的三类考试科目。 */
    private ExamSubjectSelectionDTO subjectSelection;

    /** 每日一练科目。 */
    private String dailySubject;

    /** 每日一练模式。 */
    private String dailySubjectMode;

    /** 随机刷题模式：all / single。 */
    private String randomSubjectMode;

    /** single 时的题库科目。 */
    private String randomSubject;
}
