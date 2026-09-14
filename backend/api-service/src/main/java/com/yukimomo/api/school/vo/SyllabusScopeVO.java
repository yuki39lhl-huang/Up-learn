package com.yukimomo.api.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SyllabusScopeVO {

    private List<SyllabusScopeBlockVO> blocks = new ArrayList<>();
}
