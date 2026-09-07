package com.yukimomo.school.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.school.service.SyllabusService;
import com.yukimomo.school.vo.SyllabusOptionsVO;
import com.yukimomo.school.vo.SyllabusVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 专升本考纲公开查询。
 */
@Tag(name = "考纲查询")
@RestController
@RequestMapping("/api/syllabus")
@RequiredArgsConstructor
public class SyllabusController {

    private final SyllabusService syllabusService;

    @Operation(summary = "考纲筛选选项", description = "返回广东/山东维度及已入库的省+年+科目组合")
    @GetMapping("/options")
    public Result<SyllabusOptionsVO> options() {
        return Result.ok(syllabusService.getOptions());
    }

    @Operation(summary = "考纲详情", description = "按省、年、科目查询；无数据时 data 为 null")
    @GetMapping
    public Result<SyllabusVO> detail(
            @RequestParam String province,
            @RequestParam Integer year,
            @RequestParam String subject) {
        return Result.ok(syllabusService.getDetail(province, year, subject));
    }
}
