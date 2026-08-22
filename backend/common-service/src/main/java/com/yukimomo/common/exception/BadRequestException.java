package com.yukimomo.common.exception;

/**
 * 请求参数错误（HTTP 400 语义），固定使用 {@link ErrorCode#BAD_REQUEST}。
 * <p>
 * 适用于手动校验失败、格式不符合等业务可解释场景；
 * 若使用 {@code @Valid} 注解校验，一般由 {@link com.yukimomo.common.advice.GlobalExceptionAdvice}
 * 处理 {@code MethodArgumentNotValidException}，无需手动抛本异常。
 */
public class BadRequestException extends CommonException {

    public BadRequestException(String message) {
        super(ErrorCode.BAD_REQUEST, message);
    }
}
