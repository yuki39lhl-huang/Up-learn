package com.yukimomo.school.vo;

import lombok.Data;

/**
 * 单条考纲维度（用于筛选联动）。
 */
@Data
public class SyllabusOptionItemVO {

    private String province;
    private Integer year;
    private String subject;
}
