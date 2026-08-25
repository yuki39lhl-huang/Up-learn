package com.yukimomo.school.vo;

import lombok.Data;

/**
 * 院校开设专业 VO（某校专业列表 / 开设详情）。
 * <p>
 * {@code id} 为 school_major 主键（目标院校等用）；{@code majorDictId} 为词典 ID。
 */
@Data
public class MajorVO {

    /** school_major.id */
    private Long id;
    private Long schoolId;
    private Long majorDictId;
    private String name;
    private String majorCategory;
    private String examSubjects;
    private Integer avgScore;
    private Integer enrollment;
    private Integer tuition;
    private Integer minScore;
    private Integer year;
}
