package com.yukimomo.user.mq;

/**
 * 登录/重置密码验证码异步投递消息。
 */
public record LoginCodeMessage(String email, String code, String scene) {
}
