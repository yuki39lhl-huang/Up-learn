package com.yukimomo.school.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * 备考设置所需的考试科目选项。
 */
@Data
public class ExamSubjectOptionsVO {

    /** 请求匹配的省份。 */
    private String province;

    /** 请求匹配的专业类型。 */
    private String majorCategory;

    /** 公共课选项。 */
    private ExamSubjectGroupVO publicSubjects;

    /** 专业基础课选项。 */
    private ExamSubjectGroupVO foundation;

    /** 专业综合课选项。 */
    private ExamSubjectGroupVO comprehensive;

    /** 以接口契约中的 public 字段输出公共课。 */
    @JsonProperty("public")
    public ExamSubjectGroupVO getPublicSubjects() {
        return publicSubjects;
    }
}
