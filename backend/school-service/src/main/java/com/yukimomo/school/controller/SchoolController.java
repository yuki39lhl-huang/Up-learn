package com.yukimomo.school.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.school.dto.SchoolQuery;
import com.yukimomo.school.service.SchoolService;
import com.yukimomo.school.vo.MajorVO;
import com.yukimomo.school.vo.SchoolVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 院校公开接口（网关白名单，无需 Token）。
 */
@Tag(name = "院校")
@RestController
@RequestMapping("/api/school")
@RequiredArgsConstructor
public class SchoolController {

    private final SchoolService schoolService;

    /**
     * 院校分页查询：校名模糊 + 筛选条件 AND。
     * 专业筛选用 {@code majorDictId}（来自 /api/major/options 选中项）。
     */
    @Operation(summary = "院校分页查询",
            description = "kw=校名模糊；专业筛选用 majorDictId（来自 /api/major/options 选中项，精确）。"
                    + "例：kw=深圳&type=公办&majorDictId=1")
    @GetMapping("/list")
    public Result<PageDTO<SchoolVO>> list(@ParameterObject SchoolQuery query) {
        return Result.ok(schoolService.listSchools(query));
    }

    /**
     * 按院校主键查详情。
     *
     * @param id school.id
     */
    @Operation(summary = "院校详情")
    @GetMapping("/{id}")
    public Result<SchoolVO> detail(@PathVariable Long id) {
        return Result.ok(schoolService.getSchool(id));
    }

    /**
     * 某校开设专业列表（school_major + 词典名称）。
     *
     * @param id school.id
     */
    @Operation(summary = "院校开设专业列表",
            description = "返回 school_major；id 用于目标院校，majorDictId 为词典 ID")
    @GetMapping("/{id}/majors")
    public Result<List<MajorVO>> majors(@PathVariable Long id) {
        return Result.ok(schoolService.listMajorsBySchoolId(id));
    }
}
