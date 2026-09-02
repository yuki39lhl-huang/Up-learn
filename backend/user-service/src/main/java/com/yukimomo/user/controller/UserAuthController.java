package com.yukimomo.user.controller;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.dto.LoginSendCodeDTO;
import com.yukimomo.user.dto.RefreshTokenDTO;
import com.yukimomo.user.dto.UserProfileUpdateDTO;
import com.yukimomo.user.service.UserAuthService;
import com.yukimomo.user.vo.AvatarUploadVO;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;
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

@Tag(name = "用户认证")
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserAuthController {

    private final UserAuthService userAuthService;

    @Operation(summary = "发送登录验证码", description = "邮箱验证码登录；未注册邮箱验证通过后自动注册")
    @PostMapping("/login/send-code")//valid是检测dto是否符合要求,如果不符合要求,则返回400错误
    public Result<Void> sendLoginCode(@Valid @RequestBody LoginSendCodeDTO dto) {
        userAuthService.sendLoginCode(dto.getEmail());
        return Result.ok();
    }

    @Operation(summary = "邮箱验证码登录", description = "返回 Access JWT（30 分钟）+ Refresh Token（Redis 7 天）")
    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO dto) {
        return Result.ok(userAuthService.loginByCode(dto));
    }

    @Operation(summary = "刷新 Access Token", description = "使用 Refresh Token 换取新的 Access + Refresh（轮换）")
    @PostMapping("/token/refresh")
    public Result<LoginVO> refresh(@Valid @RequestBody RefreshTokenDTO dto) {
        return Result.ok(userAuthService.refreshToken(dto.getRefreshToken()));
    }

    @Operation(summary = "登出", description = "吊销 Refresh Token；Access 仍自然过期")
    @PostMapping("/logout")
    public Result<Void> logout(@Valid @RequestBody RefreshTokenDTO dto) {
        userAuthService.logout(dto.getRefreshToken());
        return Result.ok();
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/info")
    public Result<UserInfoVO> info() {
        Long userId = UserContext.requireUserId();
        return Result.ok(userAuthService.getCurrentUserInfo(userId));
    }

    @Operation(summary = "修改资料", description = "修改昵称或头像 URL（至少填一项）")
    @PutMapping("/info")
    public Result<UserInfoVO> updateInfo(@Valid @RequestBody UserProfileUpdateDTO dto) {
        Long userId = UserContext.requireUserId();
        return Result.ok(userAuthService.updateProfile(userId, dto));
    }

    @Operation(summary = "上传头像", description = "上传图片到阿里云 OSS 并更新 avatar_url；需配置 ul.oss")
    @PostMapping("/avatar")
    public Result<AvatarUploadVO> uploadAvatar(@RequestParam("file") MultipartFile file) {
        Long userId = UserContext.requireUserId();
        return Result.ok(userAuthService.uploadAvatar(userId, file));
    }
}
