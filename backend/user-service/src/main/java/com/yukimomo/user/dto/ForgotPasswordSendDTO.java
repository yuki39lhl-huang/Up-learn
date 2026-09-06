package com.yukimomo.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 忘记密码：发送邮箱验证码请求体。
 * <p>
 * 对应 {@code POST /api/user/forgot-password/send}（公开接口）。
 * 邮箱须已注册；验证码写入 Redis {@code ul:pwd:reset:code:{email}}。
 */
@Data
public class ForgotPasswordSendDTO {

    /** 已注册用户的登录邮箱 */
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;
}
