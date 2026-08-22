package com.yukimomo.common.utils;

import com.yukimomo.common.exception.UnauthorizedException;

/**
 * 当前 HTTP 请求的用户上下文，基于 {@link ThreadLocal} 存储用户 ID。
 * <p>
 * 写入时机：{@link com.yukimomo.common.interceptors.UserInfoInterceptor#preHandle} 读取网关 Header。
 * 清除时机：同拦截器 {@code afterCompletion}，避免线程池复用导致用户串号。
 * <p>
 * Service 层推荐 {@link #requireUserId()} 获取当前用户；需要登录的接口在网关白名单外即可保证有值。
 */
public final class UserContext {

    private static final ThreadLocal<Long> USER_ID = new ThreadLocal<>();

    private UserContext() {
    }

    /** 由拦截器调用，业务代码不要直接 set */
    public static void setUserId(Long userId) {
        USER_ID.set(userId);
    }

    /** 获取当前用户 ID，未登录时返回 null */
    public static Long getUserId() {
        return USER_ID.get();
    }

    /**
     * 获取当前用户 ID，未登录时抛 {@link UnauthorizedException}。
     * 用于必须登录的业务方法（改资料、提交答案等）。
     */
    public static Long requireUserId() {
        Long userId = USER_ID.get();
        if (userId == null) {
            throw new UnauthorizedException();
        }
        return userId;
    }

    /** 请求结束时清理 ThreadLocal */
    public static void remove() {
        USER_ID.remove();
    }
}
