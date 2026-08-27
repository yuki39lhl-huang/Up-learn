package com.yukimomo.user.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.user.dto.UserExamPreferenceSaveDTO;
import com.yukimomo.user.service.UserExamPreferenceService;
import com.yukimomo.user.vo.UserExamPreferenceVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 当前用户备考设置接口。
 */
@Tag(name = "用户备考设置")
@RestController
@RequestMapping("/api/user/exam-preference")
@RequiredArgsConstructor
public class UserExamPreferenceController {

    private final UserExamPreferenceService preferenceService;

    @Operation(summary = "获取当前用户备考设置")
    @GetMapping
    public Result<UserExamPreferenceVO> get() {
        return Result.ok(preferenceService.get(UserContext.requireUserId()));
    }

    @Operation(summary = "保存当前用户备考设置")
    @PutMapping
    public Result<UserExamPreferenceVO> save(@Valid @RequestBody UserExamPreferenceSaveDTO dto) {
        return Result.ok(preferenceService.save(UserContext.requireUserId(), dto));
    }

    @Operation(summary = "删除当前用户备考设置")
    @DeleteMapping
    public Result<Void> delete() {
        preferenceService.delete(UserContext.requireUserId());
        return Result.ok();
    }
}
