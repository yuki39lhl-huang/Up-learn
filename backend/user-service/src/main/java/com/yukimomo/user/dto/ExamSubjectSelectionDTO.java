package com.yukimomo.user.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

/**
 * 用户选择的三类考试科目。
 */
@Data
public class ExamSubjectSelectionDTO {

    /** 公共课。 */
    private List<String> publicSubjects;

    /** 专业基础课。 */
    private List<String> foundation;

    /** 专业综合课。 */
    private List<String> comprehensive;

    /** 以接口契约中的 public 字段读写公共课。 */
    @JsonProperty("public")
    public List<String> getPublicSubjects() {
        return publicSubjects;
    }

    @JsonProperty("public")
    public void setPublicSubjects(List<String> publicSubjects) {
        this.publicSubjects = publicSubjects;
    }
}
