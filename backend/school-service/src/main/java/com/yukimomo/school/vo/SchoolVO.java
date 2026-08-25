package com.yukimomo.school.vo;

import lombok.Data;

/**
 * 院校对外展示 VO（列表 / 详情）。
 */
@Data
public class SchoolVO {

    private Long id;
    private String name;
    private String province;
    private String city;
    /** 办学类型：公办/民办等 */
    private String type;
    /** 展示标签 */
    private String typeTag;
    /** 是否公办（前端布尔） */
    private Boolean preferPublic;
    private Integer majorCount;
    private Integer enrollment;
    private Integer tuition;
    private Integer minScore;
}
