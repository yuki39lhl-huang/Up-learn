package com.yukimomo.user.vo;

import lombok.Data;

/**
 * 验证码登录 / 刷新令牌成功响应。
 */
@Data
public class LoginVO {

    /** Access JWT，短效（默认 30 分钟），业务 API 放在 Authorization Bearer */
    private String accessToken;
    /** Refresh Token，长效存 Redis，仅用于刷新 Access */
    private String refreshToken;
    /** Access 剩余有效时间（秒） */
    private long accessExpiresIn;
    /** 本次是否为新注册用户（自动注册） */
    private boolean newUser;
    private Long userId;
    private String email;
    private String nickname;
    private String avatarUrl;
}
