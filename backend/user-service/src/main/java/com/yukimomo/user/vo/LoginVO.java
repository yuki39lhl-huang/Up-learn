package com.yukimomo.user.vo;

import lombok.Data;

/**
 * 登录 / 刷新令牌成功响应（验证码登录、密码登录、Refresh 轮换共用）。
 */
@Data
public class LoginVO {

    /** Access JWT，短效（默认 30 分钟），业务 API 放在 Authorization Bearer */
    private String accessToken;
    /** Refresh Token，长效存 Redis，仅用于刷新 Access */
    private String refreshToken;
    /** Access 剩余有效时间（秒） */
    private long accessExpiresIn;
    /** 本次是否为新注册用户（仅验证码登录自动注册时为 true） */
    private boolean newUser;
    private Long userId;
    private String email;
    private String nickname;
    /** 头像展示 URL（OSS 私有对象为短期签名链接） */
    private String avatarUrl;
    /** 是否已设置登录密码（可用于密码登录） */
    private boolean hasPassword;
}
