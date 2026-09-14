package com.yukimomo.api.school.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SyllabusOptionsVO {

    private List<String> provinces = new ArrayList<>();
    private List<SyllabusOptionItemVO> items = new ArrayList<>();
}
