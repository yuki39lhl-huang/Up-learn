package com.yukimomo.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 考纲筛选选项：固定省份维度 + 库内已有省/年/科目组合。
 */
@Data
public class SyllabusOptionsVO {

    /** 一期固定：广东、山东（即使暂无正文也展示） */
    private List<String> provinces = new ArrayList<>();

    /** 已入库的考纲维度列表 */
    private List<SyllabusOptionItemVO> items = new ArrayList<>();
}
