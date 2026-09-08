package com.yukimomo.practice.vo;

import lombok.Data;

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
