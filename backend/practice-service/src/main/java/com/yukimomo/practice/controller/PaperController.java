package com.yukimomo.practice.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.practice.dto.PaperSaveAnswersDTO;
import com.yukimomo.practice.service.PaperService;
import com.yukimomo.practice.vo.PaperDetailVO;
import com.yukimomo.practice.vo.PaperListItemVO;
import com.yukimomo.practice.vo.PaperOptionsVO;
import com.yukimomo.practice.vo.PaperStartVO;
import com.yukimomo.practice.vo.PaperSubmitResultVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "历年真题")
@RestController
@RequestMapping("/api/practice/papers")
@RequiredArgsConstructor
public class PaperController {

    private final PaperService paperService;

    @Operation(summary = "真题筛选选项")
    @GetMapping("/options")
    public Result<PaperOptionsVO> options() {
        return Result.ok(paperService.options());
    }

    @Operation(summary = "某省某科历年试卷列表")
    @GetMapping
    public Result<List<PaperListItemVO>> list(
            @RequestParam String province,
            @RequestParam String subject) {
        return Result.ok(paperService.list(province, subject));
    }

    @Operation(summary = "试卷详情（含题目；交卷前不返答案）")
    @GetMapping("/{id}")
    public Result<PaperDetailVO> detail(@PathVariable Long id) {
        return Result.ok(paperService.detail(id));
    }

    @Operation(summary = "开始作答（复用进行中会话）")
    @PostMapping("/{id}/start")
    public Result<PaperStartVO> start(@PathVariable Long id) {
        return Result.ok(paperService.start(id));
    }

    @Operation(summary = "保存选择题草稿")
    @PutMapping("/attempts/{attemptId}/answers")
    public Result<Void> saveAnswers(
            @PathVariable Long attemptId,
            @Valid @RequestBody PaperSaveAnswersDTO dto) {
        paperService.saveAnswers(attemptId, dto);
        return Result.ok();
    }

    @Operation(summary = "交卷（判选择题并揭晓填空/计算参考答案）")
    @PostMapping("/attempts/{attemptId}/submit")
    public Result<PaperSubmitResultVO> submit(@PathVariable Long attemptId) {
        return Result.ok(paperService.submit(attemptId));
    }
}
