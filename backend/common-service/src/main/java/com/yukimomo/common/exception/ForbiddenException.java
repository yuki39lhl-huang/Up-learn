package com.yukimomo.common.exception;

/**
 * 已登录但无权操作（HTTP 403 语义），固定使用 {@link ErrorCode#FORBIDDEN}。
 * <p>
 * 与 {@link UnauthorizedException} 的区别：401 表示「不知道你是谁」，403 表示「知道你是谁但不让你做」。
 */
public class ForbiddenException extends CommonException {

    public ForbiddenException() {
        super(ErrorCode.FORBIDDEN);
    }

    public ForbiddenException(String message) {
        super(ErrorCode.FORBIDDEN, message);
    }
}
