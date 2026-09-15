package com.yukimomo.user.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.user.dto.UserUiPreferenceSaveDTO;
import com.yukimomo.user.service.UserUiPreferenceService;
import com.yukimomo.user.vo.UserUiPreferenceVO;
import com.yukimomo.user.vo.WallpaperUploadVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 当前用户界面偏好（主题、语言、壁纸、透明度）。
 */
@Tag(name = "用户界面偏好")
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserUiPreferenceController {

    private final UserUiPreferenceService preferenceService;

    @Operation(summary = "获取界面偏好")
    @GetMapping("/ui-preference")
    public Result<UserUiPreferenceVO> get() {
        return Result.ok(preferenceService.get(UserContext.requireUserId()));
    }

    @Operation(summary = "保存界面偏好")
    @PutMapping("/ui-preference")
    public Result<UserUiPreferenceVO> save(@Valid @RequestBody UserUiPreferenceSaveDTO dto) {
        return Result.ok(preferenceService.save(UserContext.requireUserId(), dto));
    }

    @Operation(summary = "上传壁纸", description = "target=shell 底层背景；target=panel 主展示区；需配置 ul.oss")
    @PostMapping("/ui/wallpaper")
    public Result<WallpaperUploadVO> uploadWallpaper(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "target", defaultValue = "shell") String target) {
        return Result.ok(preferenceService.uploadWallpaper(UserContext.requireUserId(), file, target));
    }
}
