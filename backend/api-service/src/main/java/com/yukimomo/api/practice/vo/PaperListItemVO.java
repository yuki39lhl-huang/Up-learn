package com.yukimomo.api.practice.vo;

import lombok.Data;

/**
 * 真题列表项（跨服务契约；不含题目正文）。
 */
@Data
public class PaperListItemVO {

    private Long id;
    private String province;
    private String subject;
    private Integer year;
    private String title;
    private Boolean hasAnswer;
    private Boolean pdfAvailable;
    private Integer questionCount;
}
