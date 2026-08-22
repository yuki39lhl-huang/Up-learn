package com.yukimomo.common.exception;

/**
 * 未登录或身份无效（HTTP 401 语义），固定使用 {@link ErrorCode#UNAUTHORIZED}。
 * <p>
 * 典型场景：Token 过期、JWT 验签失败、{@link com.yukimomo.common.utils.UserContext#requireUserId()}
 * 时上下文中没有用户 ID。
 */
public class UnauthorizedException extends CommonException {

    public UnauthorizedException() {
        super(ErrorCode.UNAUTHORIZED);
    }

    /** 自定义提示，如「登录已过期，请重新登录」 */
    public UnauthorizedException(String message) {
        super(ErrorCode.UNAUTHORIZED, message);
    }
}
