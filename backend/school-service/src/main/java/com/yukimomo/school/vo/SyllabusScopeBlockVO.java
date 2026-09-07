package com.yukimomo.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 考试范围块：标题 / 段落 / 条目 / 子块。
 */
@Data
public class SyllabusScopeBlockVO {

    private String heading;
    private List<String> paragraphs = new ArrayList<>();
    private List<String> items = new ArrayList<>();
    private List<SyllabusScopeBlockVO> children = new ArrayList<>();
    /** 强调块（如时事政治时间窗） */
    private Boolean highlight = false;
}
