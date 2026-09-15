package com.yukimomo.api.school.vo;

import lombok.Data;

/**
 * 院校开设专业摘要（跨服务契约，对齐 school-service MajorVO 常用字段）。
 */
@Data
public class SchoolMajorVO {

    private Long id;
    private Long schoolId;
    private Long majorDictId;
    private String name;
    private String displayName;
    private String discipline;
    private String majorCategory;
    private String majorGroup;
    private String majorCode;
    private String batchName;
    private String campus;
    private String examType;
    private String publicSubjects;
    private String foundationSubject;
    private String comprehensiveSubject;
    private String prerequisite;
    private Integer tuition;
    private Integer year;
}
