package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperDetailVO {
    private Long id;
    private String province;
    private String subject;
    private Integer year;
    private String title;
    private Boolean hasAnswer;
    private Boolean pdfAvailable;
    private Long attemptId;
    private String attemptStatus;
    private List<PaperQuestionVO> questions;
}
