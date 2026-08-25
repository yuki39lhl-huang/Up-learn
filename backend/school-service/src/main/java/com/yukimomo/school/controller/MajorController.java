package com.yukimomo.school.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.school.dto.MajorOptionQuery;
import com.yukimomo.school.service.SchoolService;
import com.yukimomo.school.vo.MajorOptionVO;
import com.yukimomo.school.vo.MajorVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 专业公开接口：词典选项 + 开设详情（网关白名单，无需 Token）。
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

    /**
     * 院校开设专业详情。
     *
     * @param id school_major.id（不是 major_dict.id）
     */
    @Operation(summary = "院校开设专业详情",
            description = "按 school_major.id 查询（含词典名称与招生信息）")
    @GetMapping("/{id}")
    public Result<MajorVO> detail(@PathVariable Long id) {
        return Result.ok(schoolService.getSchoolMajor(id));
    }
}
