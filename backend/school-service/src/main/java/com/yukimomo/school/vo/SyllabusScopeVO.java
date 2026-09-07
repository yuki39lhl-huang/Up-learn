package com.yukimomo.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 考试范围根节点。
 */
@Data
public class SyllabusScopeVO {

    private List<SyllabusScopeBlockVO> blocks = new ArrayList<>();
}
