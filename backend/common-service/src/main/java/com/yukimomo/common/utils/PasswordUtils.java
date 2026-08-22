package com.yukimomo.common.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 密码加解密工具（BCrypt 单向哈希，不可逆）。
 * <p>
 * 注册：{@link #encode(String)} 得到哈希存入 {@code user.password_hash}，禁止存明文。
 * 登录：{@link #matches(String, String)} 用明文与库中哈希比对。
 * <p>
 * 仅引入 {@code spring-security-crypto}，不启用完整 Spring Security 过滤器链。
 */
public final class PasswordUtils {

    private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder();

    private PasswordUtils() {
    }

    /** 对明文密码做 BCrypt 哈希，每次结果不同（内置随机盐） */
    public static String encode(String rawPassword) {
        return ENCODER.encode(rawPassword);
    }

    /** 校验明文是否与已存储的 BCrypt 哈希匹配 */
    public static boolean matches(String rawPassword, String encodedPassword) {
        return ENCODER.matches(rawPassword, encodedPassword);
    }
}
