package com.yukimomo.school.vo;

import lombok.Data;

import java.util.List;

/**
 * 一类考试科目的候选项和默认选中项。
 */
@Data
public class ExamSubjectGroupVO {

    /** 当前科目类型可选的全部科目名称。 */
    private List<String> options;

    /** 按省份/专业规则推断出的默认选中科目。 */
    private List<String> defaults;
}
