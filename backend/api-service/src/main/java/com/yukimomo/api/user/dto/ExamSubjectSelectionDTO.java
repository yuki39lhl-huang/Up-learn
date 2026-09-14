package com.yukimomo.api.user.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

/**
 * 用户选择的三类考试科目（跨服务契约）。
 */
@Data
public class ExamSubjectSelectionDTO {

    private List<String> publicSubjects;
    private List<String> foundation;
    private List<String> comprehensive;

    @JsonProperty("public")
    public List<String> getPublicSubjects() {
        return publicSubjects;
    }

    @JsonProperty("public")
    public void setPublicSubjects(List<String> publicSubjects) {
        this.publicSubjects = publicSubjects;
    }
}
