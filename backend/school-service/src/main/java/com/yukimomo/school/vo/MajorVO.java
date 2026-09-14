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
    /** 词典标准名 */
    private String name;
    /** 招生展示名（含方向）；空则与 name 相同 */
    private String displayName;
    private String discipline;
    private String majorCategory;
    /** 专业组（院校目录） */
    private String majorGroup;
    /** 专业号 */
    private String majorCode;
    /** 批次，如普通批 */
    private String batchName;
    private String campus;
    /** 统考 / 校考 */
    private String examType;
    /** 公共课科目 */
    private String publicSubjects;
    /** 专业基础课 */
    private String foundationSubject;
    /** 专业综合课 */
    private String comprehensiveSubject;
    /** 前置要求：不限 / 限招 等 */
    private String prerequisite;
    /** 兼容旧展示：公共+基础+综课拼接 */
    private String examSubjects;
    private Integer avgScore;
    private Integer enrollment;
    private Integer tuition;
    private Integer minScore;
    private Integer year;
}
