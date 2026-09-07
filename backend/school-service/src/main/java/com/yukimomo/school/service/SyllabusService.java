package com.yukimomo.school.service;

import com.yukimomo.school.vo.SyllabusOptionsVO;
import com.yukimomo.school.vo.SyllabusVO;

/**
 * 考纲查询（只读）。
 */
public interface SyllabusService {

    /** 省份维度 + 已入库省/年/科目组合 */
    SyllabusOptionsVO getOptions();

    /**
     * 按省 + 年 + 科目查询详情；无数据返回 {@code null}。
     */
    SyllabusVO getDetail(String province, Integer year, String subject);
}
