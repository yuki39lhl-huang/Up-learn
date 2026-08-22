package com.yukimomo.common.exception;

import lombok.Getter;

/**
 * 业务异常基类，携带数字错误码，供全局异常处理器统一封装为 {@link com.yukimomo.common.domain.Result}。
 * <p>
 * 不要直接 {@code throw new CommonException(...)}，应使用更具体的子类（如 {@link BizException}、
 * {@link UnauthorizedException}），便于区分异常语义。
 */
@Getter
public class CommonException extends RuntimeException {

    /** 与 {@link ErrorCode#getCode()} 或自定义业务码一致 */
    private final int code;

    /** 使用枚举默认文案 */
    public CommonException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.code = errorCode.getCode();
    }

    /** 使用枚举码 + 自定义文案（覆盖默认 message） */
    public CommonException(ErrorCode errorCode, String message) {
        super(message);
        this.code = errorCode.getCode();
    }

    /** 完全自定义码与文案 */
    public CommonException(int code, String message) {
        super(message);
        this.code = code;
    }
}
