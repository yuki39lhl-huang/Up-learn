package com.yukimomo.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 密码登录请求体。
 * <p>
 * 对应 {@code POST /api/user/login/password}；用户须已设置登录密码（{@code user.password_set = 1}）。
 */
@Data
public class PasswordLoginDTO {

    /** 登录邮箱 */
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;

    /** 明文密码（传输层依赖 HTTPS；服务端仅做 BCrypt 比对，不落库） */
    @NotBlank(message = "密码不能为空")
    @Size(min = 8, max = 32, message = "密码长度为 8～32 位")
    private String password;
}
