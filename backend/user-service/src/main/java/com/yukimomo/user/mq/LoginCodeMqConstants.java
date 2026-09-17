package com.yukimomo.user.mq;

/**
 * 验证码投递队列常量。
 */
public final class LoginCodeMqConstants {

    public static final String EXCHANGE = "ul.login.code.exchange";
    public static final String QUEUE = "ul.login.code.dispatch";
    public static final String ROUTING_KEY = "ul.login.code.dispatch";

    private LoginCodeMqConstants() {
    }
}
