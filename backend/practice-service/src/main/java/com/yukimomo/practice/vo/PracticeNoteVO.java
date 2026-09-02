package com.yukimomo.practice.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 备忘录列表/详情 VO。
 */
@Data
public class PracticeNoteVO {

    private Long id;
    private Long questionId;
    private String subject;
    private String stem;
    private List<String> options;
    private String analysis;
    private String userNote;
    private String answer;
    private LocalDateTime createdAt;
}
