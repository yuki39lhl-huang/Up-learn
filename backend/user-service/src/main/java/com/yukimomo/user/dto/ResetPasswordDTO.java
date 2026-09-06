package com.yukimomo.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 忘记密码：校验验证码并设置新密码请求体。
 * <p>
 * 对应 {@code POST /api/user/forgot-password/reset}（公开接口）。
 * 成功后将 {@code password_hash} 更新为新哈希，并置 {@code password_set = 1}。
 */
@Data
public class ResetPasswordDTO {

    /** 登录邮箱 */
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;

    /** 6 位数字验证码（与忘记密码发送接口配套） */
    @NotBlank(message = "验证码不能为空")
    @Pattern(regexp = "^\\d{6}$", message = "验证码为 6 位数字")
    private String code;

    /** 新密码明文；强度同设密规则 */
    @NotBlank(message = "新密码不能为空")
    @Size(min = 8, max = 32, message = "密码长度为 8～32 位")
    private String newPassword;
}
