package com.yukimomo.user.constant;

/**
 * Redis Key 前缀（user-service · 登录验证码）。
 */
public final class UserRedisConstants {

    private UserRedisConstants() {
    }

    /** 登录验证码：{@code ul:login:code:{email}} */
    public static final String LOGIN_CODE_PREFIX = "ul:login:code:";
    /** 发送频率限制：{@code ul:login:send:{email}} */
    public static final String LOGIN_SEND_PREFIX = "ul:login:send:";
    /** Refresh Token：{@code ul:refresh:{token}} */
    public static final String REFRESH_TOKEN_PREFIX = "ul:refresh:";
}
