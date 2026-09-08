package com.yukimomo.practice.vo;

import lombok.Data;

import java.util.List;

@Data
public class PaperOptionsVO {
    private List<String> provinces;
    /** 已入库的省+科目组合（去重科目列表按省聚合前端自行过滤） */
    private List<PaperOptionItemVO> items;
}
