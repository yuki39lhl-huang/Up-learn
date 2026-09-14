package com.yukimomo.api.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SyllabusScopeBlockVO {

    private String heading;
    private List<String> paragraphs = new ArrayList<>();
    private List<String> items = new ArrayList<>();
    private List<SyllabusScopeBlockVO> children = new ArrayList<>();
    private Boolean highlight = false;
}
