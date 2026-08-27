package com.yukimomo.school.service;

import com.yukimomo.school.vo.ExamSubjectOptionsVO;

/**
 * 备考考试科目规则查询服务。
 */
public interface ExamSubjectService {

    /**
     * 根据省份和专业类型返回三类科目的候选项及默认值。
     */
    ExamSubjectOptionsVO getOptions(String province, String majorCategory);
}
