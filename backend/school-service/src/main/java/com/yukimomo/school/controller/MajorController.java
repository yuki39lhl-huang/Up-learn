package com.yukimomo.school.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.school.dto.MajorOptionQuery;
import com.yukimomo.school.service.SchoolService;
import com.yukimomo.school.vo.MajorOptionVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 专业公开接口：词典选项（网关白名单，无需 Token）。
 */
@Tag(name = "专业")
@RestController
@RequestMapping("/api/major")
@RequiredArgsConstructor
public class MajorController {

    private final SchoolService schoolService;

    /**
     * 专业词典 Combobox 选项。
     * 有 kw 按名称模糊；无 kw 分页滚动。选中后的 id → list.majorDictId。
     */
    @Operation(summary = "专业词典选项（筛选 Combobox）",
            description = "查 major_dict。有 kw 模糊；无 kw 分页滚动。"
                    + "选中后把返回的 id 作为 /api/school/list 的 majorDictId")
    @GetMapping("/options")
    public Result<PageDTO<MajorOptionVO>> options(@ParameterObject MajorOptionQuery query) {
        return Result.ok(schoolService.listMajorOptions(query));
    }

    @Operation(summary = "专业类列表", description = "词典 major_category 去重，供级联筛选第一级")
    @GetMapping("/categories")
    public Result<List<String>> categories() {
        return Result.ok(schoolService.listMajorCategories());
    }
}
