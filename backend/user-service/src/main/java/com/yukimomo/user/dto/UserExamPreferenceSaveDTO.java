package com.yukimomo.user.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 保存用户备考设置的请求参数。
 */
@Data
public class UserExamPreferenceSaveDTO {

    /** 报考省份。 */
    @NotBlank
    private String province;

    /** 报考届别年份。 */
    @NotNull
    private Integer cohortYear;

    /** 专业类型。 */
    @NotBlank
    private String majorCategory;

    /** 用户选择的考试科目。 */
    @NotNull
    @Valid
    private ExamSubjectSelectionDTO subjectSelection;

    /** 每日一练科目。 */
    @NotBlank
    private String dailySubject;

    /** 每日一练模式：fixed 或 random。 */
    @NotBlank
    private String dailySubjectMode;
}
