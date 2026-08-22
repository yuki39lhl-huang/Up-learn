package com.yukimomo.common.exception;

/**
 * 可预期的业务异常（如「邮箱已注册」「密码错误」）。
 * <p>
 * Service 层在业务规则不满足时抛出，Controller 无需 try-catch，
 * 由 {@link com.yukimomo.common.advice.GlobalExceptionAdvice} 自动转为失败 {@link com.yukimomo.common.domain.Result}。
 */
public class BizException extends CommonException {

    public BizException(ErrorCode errorCode) {
        super(errorCode);
    }

    /** 需要覆盖枚举默认提示时使用，例如带上具体字段名 */
    public BizException(ErrorCode errorCode, String message) {
        super(errorCode, message);
    }
}
