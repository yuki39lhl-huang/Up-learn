package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

/**
 * 清空重刷结果：告知前端清除了哪些科目、多少条调度记录。
 */
@Data
public class RandomResetVO {

    /** 实际清除的题库科目列表 */
    private List<String> subjects;

    /** 删除的 user_question_record 行数 */
    private int clearedRecordCount;
}
