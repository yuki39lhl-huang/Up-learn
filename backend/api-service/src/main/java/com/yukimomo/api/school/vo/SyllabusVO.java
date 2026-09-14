package com.yukimomo.api.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 考纲详情（跨服务契约）。
 */
@Data
public class SyllabusVO {

    private Long id;
    private String province;
    private Integer year;
    private String subject;
    private String sourceTitle;
    private SyllabusScopeVO scope = new SyllabusScopeVO();
    private List<SyllabusReferenceVO> references = new ArrayList<>();
    private List<SyllabusDesignatedWorkVO> designatedWorks = new ArrayList<>();
}
