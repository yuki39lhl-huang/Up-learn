package com.yukimomo.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 设置或修改登录密码请求体。
 * <p>
 * 对应 {@code PUT /api/user/password}（需 Access Token）。
 * <ul>
 *   <li>首次设置（{@code password_set = 0}）：{@link #oldPassword} 可空</li>
 *   <li>已设密后修改：必须校验 {@link #oldPassword}</li>
 * </ul>
 * 强度规则：8～32 位，且同时包含字母与数字（服务端二次校验）。
 */
@Data
public class ChangePasswordDTO {

    /** 当前密码；已设置密码时必填，首次设置可空 */
    private String oldPassword;

    /** 新密码明文 */
    @NotBlank(message = "新密码不能为空")
    @Size(min = 8, max = 32, message = "密码长度为 8～32 位")
    private String newPassword;
}
