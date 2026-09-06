package com.yukimomo.user.service;

import com.yukimomo.user.dto.ChangePasswordDTO;
import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.dto.PasswordLoginDTO;
import com.yukimomo.user.dto.ResetPasswordDTO;
import com.yukimomo.user.dto.UserProfileUpdateDTO;
import com.yukimomo.user.vo.AvatarUploadVO;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;
import org.springframework.web.multipart.MultipartFile;

/**
 * 用户认证与账号资料：验证码/密码登录、双 Token、资料与头像、设密与重置密码。
 */
public interface UserAuthService {

    /** 发送登录邮箱验证码（未注册邮箱也可发，登录时自动注册） */
    void sendLoginCode(String email);

    /** 邮箱验证码登录；未注册则自动注册 */
    LoginVO loginByCode(LoginDTO dto);

    /**
     * 邮箱 + 密码登录。
     * 要求 {@code password_set = 1}，否则提示先设密或改用验证码登录。
     */
    LoginVO loginByPassword(PasswordLoginDTO dto);

    /** 使用 Refresh Token 轮换签发新的 Access + Refresh */
    LoginVO refreshToken(String refreshToken);

    /** 吊销 Refresh Token */
    void logout(String refreshToken);

    /** 当前用户资料（头像为展示用签名 URL） */
    UserInfoVO getCurrentUserInfo(Long userId);

    /** 修改昵称和/或头像 URL */
    UserInfoVO updateProfile(Long userId, UserProfileUpdateDTO dto);

    /** 上传头像到 OSS 并更新库内 canonical URL */
    AvatarUploadVO uploadAvatar(Long userId, MultipartFile file);

    /**
     * 首次设置或修改登录密码（需已登录）。
     * 首次无需旧密码；已设密须校验旧密码。
     */
    void changePassword(Long userId, ChangePasswordDTO dto);

    /** 向已注册邮箱发送重置密码验证码 */
    void sendForgotPasswordCode(String email);

    /** 校验重置验证码并写入新密码 */
    void resetPassword(ResetPasswordDTO dto);
}
