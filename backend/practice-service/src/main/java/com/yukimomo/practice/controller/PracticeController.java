package com.yukimomo.practice.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.domain.Result;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.service.PracticeService;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.QuestionVO;
import com.yukimomo.practice.vo.StudyStatsVO;
import com.yukimomo.practice.vo.SubmitResultVO;
import com.yukimomo.practice.vo.WrongQuestionVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 刷题 HTTP 入口（路径前缀 /api/practice）。
 * <p>
 * 鉴权说明：
 * <ul>
 *   <li>不进网关白名单 → 必须带 {@code Authorization: Bearer &lt;AccessToken&gt;}</li>
 *   <li>网关验签后透传 Header {@code user-id}，由 common 的 UserInfoInterceptor 写入 UserContext</li>
 *   <li>Controller 本身不读 Token，业务层 {@code requireUserId()} 即可</li>
 * </ul>
 * 统一用 {@link Result} 包装响应，便于前端约定 code/data。
 */
@Tag(name = "刷题")
@RestController
@RequestMapping("/api/practice")
@RequiredArgsConstructor
public class PracticeController {

    private final PracticeService practiceService;

    /**
     * 每日一练。
     *
     * @param subject 可选精确科目；当天已有缓存时忽略，仍返回缓存题
     */
    @Operation(summary = "每日一练", description = "当天同一用户返回同一题；可选 subject 精确科目")
    @GetMapping("/daily")
    public Result<QuestionVO> daily(@RequestParam(required = false) String subject) {
        return Result.ok(practiceService.daily(subject));
    }

    /**
     * 随机刷题（每次可能不同）；响应不含答案与解析。
     */
    @Operation(summary = "随机刷题", description = "库内随机一题；不返回答案与解析")
    @GetMapping("/random")
    public Result<QuestionVO> random(@RequestParam(required = false) String subject) {
        return Result.ok(practiceService.random(subject));
    }

    /**
     * 提交答案并判分。
     * {@code @Valid} 触发 DTO 校验；失败由全局异常切面转 400。
     */
    @Operation(summary = "提交答案")
    @PostMapping("/submit")
    public Result<SubmitResultVO> submit(@Valid @RequestBody SubmitAnswerDTO dto) {
        return Result.ok(practiceService.submit(dto));
    }

    /**
     * 错题本分页。pageNo/pageSize 来自 {@link PageQuery} 查询参数。
     */
    @Operation(summary = "错题列表")
    @GetMapping("/wrong")
    public Result<PageDTO<WrongQuestionVO>> wrong(@ParameterObject PageQuery query) {
        return Result.ok(practiceService.listWrong(query));
    }

    /**
     * 答题历史分页，时间倒序。
     */
    @Operation(summary = "答题历史")
    @GetMapping("/history")
    public Result<PageDTO<AnswerHistoryVO>> history(@ParameterObject PageQuery query) {
        return Result.ok(practiceService.listHistory(query));
    }

    /**
     * 学习统计汇总。
     */
    @Operation(summary = "学习统计")
    @GetMapping("/stats")
    public Result<StudyStatsVO> stats() {
        return Result.ok(practiceService.stats());
    }
}
