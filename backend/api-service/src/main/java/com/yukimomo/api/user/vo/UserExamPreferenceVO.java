package com.yukimomo.api.user.vo;

import com.yukimomo.api.user.dto.ExamSubjectSelectionDTO;
import lombok.Data;

/**
 * 当前用户备考设置（跨服务契约）。
 */
@Data
public class UserExamPreferenceVO {

    private Long id;
    private Long userId;
    private String province;
    private Integer cohortYear;
    private String majorCategory;
    private ExamSubjectSelectionDTO subjectSelection;
    private String dailySubject;
    private String dailySubjectMode;
    private String randomSubjectMode;
    private String randomSubject;
}
