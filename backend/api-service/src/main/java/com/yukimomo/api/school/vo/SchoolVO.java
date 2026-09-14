package com.yukimomo.api.school.vo;

import lombok.Data;

/**
 * 院校摘要（跨服务契约，对齐 school-service 列表字段）。
 */
@Data
public class SchoolVO {

    private Long id;
    private String name;
    private String province;
    private String city;
    private String type;
    private String typeTag;
    private Boolean preferPublic;
    private Integer majorCount;
    private Integer enrollment;
    private Integer tuition;
    private Integer minScore;
}
