package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

/**
 * 随机刷题：当前筛选范围外，仍有待复习错题的其它题库科目。
 */
@Data
public class RandomPendingHintVO {

    /** 其它科目名称（题库科目，如「高等数学」） */
    private List<String> otherSubjects;

    /** 是否应在科目标签旁展示切换提示 */
    private boolean showHint;
}
