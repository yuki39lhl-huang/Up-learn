package com.yukimomo.school.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.school.service.ExamSubjectService;
import com.yukimomo.school.vo.ExamSubjectOptionsVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 备考考试科目公开接口。
 */
@Tag(name = "考试科目")
@RestController
@RequestMapping("/api/exam-subjects")
@RequiredArgsConstructor
public class ExamSubjectController {

    private final ExamSubjectService examSubjectService;

    @Operation(summary = "备考考试科目选项",
            description = "按省份和专业类型返回公共课、专业基础课、专业综合课候选项及默认值")
    @GetMapping("/options")
    public Result<ExamSubjectOptionsVO> options(
            @RequestParam String province,
            @RequestParam(required = false) String majorCategory) {
        return Result.ok(examSubjectService.getOptions(province, majorCategory));
    }
}
