package com.yukimomo.practice.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.domain.Result;
import com.yukimomo.practice.dto.AddPracticeNoteDTO;
import com.yukimomo.practice.dto.AddWrongBookDTO;
import com.yukimomo.practice.dto.RandomResetDTO;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.service.PracticeService;
import com.yukimomo.practice.vo.DailyStatusVO;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.PracticeNoteVO;
import com.yukimomo.practice.vo.QuestionVO;
import com.yukimomo.practice.vo.RandomPendingHintVO;
import com.yukimomo.practice.vo.RandomResetVO;
import com.yukimomo.practice.vo.StudyStatsVO;
import com.yukimomo.practice.vo.SubmitResultVO;
import com.yukimomo.practice.vo.WrongQuestionVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 刷题 HTTP 入口（路径前缀 /api/practice）。
 */
@Tag(name = "刷题")
@RestController
@RequestMapping("/api/practice")
@RequiredArgsConstructor
public class PracticeController {

    private final PracticeService practiceService;

    @GetMapping("/daily/status")
    public Result<DailyStatusVO> dailyStatus() {
        return Result.ok(practiceService.dailyStatus());
    }

    @Operation(summary = "每日一练", description = "当天同一用户返回同一题；可选 subject 精确科目")
    @GetMapping("/daily")
    public Result<QuestionVO> daily(@RequestParam(required = false) String subject) {
        return Result.ok(practiceService.daily(subject));
    }

    @Operation(summary = "重置每日一练签到", description = "清除 daily 答题记录与学习统计（累计/连续签到）")
    @DeleteMapping("/daily/checkin")
    public Result<Void> resetDailyCheckIn() {
        practiceService.resetDailyCheckIn();
        return Result.ok();
    }

    @Operation(summary = "随机刷题", description = "按备考设置与随机筛选范围出题；科目在刷题面板「自定义范围」中切换")
    @GetMapping("/random")
    public Result<QuestionVO> random() {
        return Result.ok(practiceService.random());
    }

    @Operation(summary = "其它科目待复习提示", description = "当前筛选范围外仍有 WRONG 且今日未做的科目列表")
    @GetMapping("/random/pending-hint")
    public Result<RandomPendingHintVO> randomPendingHint() {
        return Result.ok(practiceService.randomPendingHint());
    }

    @Operation(summary = "清空重刷", description = "清除复习调度与当日已做记录，可指定全部备考科目或单科")
    @PostMapping("/random/reset")
    public Result<RandomResetVO> resetRandom(@Valid @RequestBody RandomResetDTO dto) {
        return Result.ok(practiceService.resetRandom(dto));
    }

    @Operation(summary = "备考重置时清空随机刷题", description = "清除全部复习进度、当日已做与随机刷题答题统计")
    @DeleteMapping("/random/progress")
    public Result<Void> clearRandomProgressOnExamReset() {
        practiceService.resetRandomProgress();
        return Result.ok();
    }

    @Operation(summary = "提交答案")
    @PostMapping("/submit")
    public Result<SubmitResultVO> submit(@Valid @RequestBody SubmitAnswerDTO dto) {
        return Result.ok(practiceService.submit(dto));
    }

    @Operation(summary = "错题列表", description = "手动加入的错题本；date=yyyy-MM-dd 按加入日筛选；subject=题库科目名，不传为全部")
    @GetMapping("/wrong")
    public Result<PageDTO<WrongQuestionVO>> wrong(
            @ParameterObject PageQuery query,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String subject) {
        return Result.ok(practiceService.listWrong(query, date, subject));
    }

    @Operation(summary = "加入错题本")
    @PostMapping("/wrong")
    public Result<WrongQuestionVO> addWrong(@Valid @RequestBody AddWrongBookDTO dto) {
        return Result.ok(practiceService.addWrongBook(dto));
    }

    @Operation(summary = "错题详情")
    @GetMapping("/wrong/{id}")
    public Result<WrongQuestionVO> wrongDetail(@PathVariable Long id) {
        return Result.ok(practiceService.getWrongBook(id));
    }

    @Operation(summary = "移出错题本")
    @DeleteMapping("/wrong/{id}")
    public Result<Void> deleteWrong(@PathVariable Long id) {
        practiceService.deleteWrongBook(id);
        return Result.ok();
    }

    @Operation(summary = "批量清空错题本", description = "date/subject 可选，组合筛选后删除")
    @DeleteMapping("/wrong/batch")
    public Result<Integer> deleteWrongBatch(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String subject) {
        return Result.ok(practiceService.deleteAllWrongBook(date, subject));
    }

    @Operation(summary = "备忘录列表", description = "date=yyyy-MM-dd 按创建日筛选；subject=题库科目名，不传为全部")
    @GetMapping("/notes")
    public Result<PageDTO<PracticeNoteVO>> notes(
            @ParameterObject PageQuery query,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String subject) {
        return Result.ok(practiceService.listNotes(query, date, subject));
    }

    @Operation(summary = "添加到备忘录")
    @PostMapping("/notes")
    public Result<PracticeNoteVO> addNote(@Valid @RequestBody AddPracticeNoteDTO dto) {
        return Result.ok(practiceService.addNote(dto));
    }

    @Operation(summary = "备忘录详情")
    @GetMapping("/notes/{id}")
    public Result<PracticeNoteVO> noteDetail(@PathVariable Long id) {
        return Result.ok(practiceService.getNote(id));
    }

    @Operation(summary = "删除备忘录")
    @DeleteMapping("/notes/{id}")
    public Result<Void> deleteNote(@PathVariable Long id) {
        practiceService.deleteNote(id);
        return Result.ok();
    }

    @Operation(summary = "批量清空备忘录", description = "date/subject 可选，组合筛选后删除")
    @DeleteMapping("/notes/batch")
    public Result<Integer> deleteNotesBatch(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String subject) {
        return Result.ok(practiceService.deleteAllNotes(date, subject));
    }

    @Operation(summary = "答题历史")
    @GetMapping("/history")
    public Result<PageDTO<AnswerHistoryVO>> history(@ParameterObject PageQuery query) {
        return Result.ok(practiceService.listHistory(query));
    }

    @Operation(summary = "学习统计", description = "source=random 时仅统计随机刷题，不含连续打卡")
    @GetMapping("/stats")
    public Result<StudyStatsVO> stats(@RequestParam(required = false) String source) {
        return Result.ok(practiceService.stats(source));
    }
}
