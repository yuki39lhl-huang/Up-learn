package com.yukimomo.user.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.user.dto.AddUserTargetDTO;
import com.yukimomo.user.service.UserTargetService;
import com.yukimomo.user.vo.UserTargetVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 用户目标院校接口。
 */
@Tag(name = "用户目标院校")
@RestController
@RequestMapping("/api/user/targets")
@RequiredArgsConstructor
public class UserTargetController {

    private final UserTargetService userTargetService;

    @Operation(summary = "目标院校列表")
    @GetMapping
    public Result<List<UserTargetVO>> list() {
        return Result.ok(userTargetService.list(UserContext.requireUserId()));
    }

    @Operation(summary = "加入目标", description = "body: schoolId 必填，majorId 可选（school_major.id）")
    @PostMapping
    public Result<UserTargetVO> add(@Valid @RequestBody AddUserTargetDTO dto) {
        return Result.ok(userTargetService.add(UserContext.requireUserId(), dto));
    }

    @Operation(summary = "移除目标")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        userTargetService.remove(UserContext.requireUserId(), id);
        return Result.ok();
    }
}
