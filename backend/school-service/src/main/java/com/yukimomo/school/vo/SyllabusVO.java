package com.yukimomo.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 考纲详情：考试范围树 + 参考书目 + 可选指定篇目。
 */
@Data
public class SyllabusVO {

    private Long id;
    private String province;
    private Integer year;
    private String subject;
    private String sourceTitle;

    /** 考试范围 */
    private SyllabusScopeVO scope = new SyllabusScopeVO();

    /** 参考书目 */
    private List<SyllabusReferenceVO> references = new ArrayList<>();

    /** 指定篇目（无则空列表） */
    private List<SyllabusDesignatedWorkVO> designatedWorks = new ArrayList<>();
}
