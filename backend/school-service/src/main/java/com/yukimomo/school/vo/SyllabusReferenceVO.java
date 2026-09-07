package com.yukimomo.school.vo;

import lombok.Data;

/**
 * 参考书目条目。
 */
@Data
public class SyllabusReferenceVO {

    private String title;
    private String editors;
    private String edition;
    private String publisher;
    private String publishedAt;
    private String note;
}
