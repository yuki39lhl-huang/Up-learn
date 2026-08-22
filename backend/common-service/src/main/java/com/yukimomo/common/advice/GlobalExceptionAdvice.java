package com.yukimomo.common.advice;

import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.CommonException;
import com.yukimomo.common.exception.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理：将各类异常统一转为 {@link Result} JSON，避免 Controller 里散落 try-catch。
 * <p>
 * 通过 {@code @RestControllerAdvice} 作用于引入 common-service 的业务模块；
 * 优先级：业务 {@link CommonException} → 参数校验 → JSON 解析错误 → 兜底 500。
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionAdvice {

    /** 业务异常（BizException / UnauthorizedException 等），原样返回 code + message */
    @ExceptionHandler(CommonException.class)
    public Result<Void> handleCommonException(CommonException ex) {
        return Result.error(ex.getCode(), ex.getMessage());
    }

    /** {@code @RequestBody @Valid} 校验失败（如 @NotBlank） */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleValidException(MethodArgumentNotValidException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(err -> err.getDefaultMessage())
                .orElse(ErrorCode.BAD_REQUEST.getMessage());
        return Result.error(ErrorCode.BAD_REQUEST.getCode(), msg);
    }

    /** 表单 / 查询参数绑定校验失败 */
    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(err -> err.getDefaultMessage())
                .orElse(ErrorCode.BAD_REQUEST.getMessage());
        return Result.error(ErrorCode.BAD_REQUEST.getCode(), msg);
    }

    /** JSON 体无法反序列化（字段类型错误、缺少引号等） */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public Result<Void> handleNotReadable(HttpMessageNotReadableException ex) {
        return Result.error(ErrorCode.BAD_REQUEST.getCode(), "请求体格式错误");
    }

    /** 未捕获异常：记日志，对外只返回通用 500 文案，避免泄露堆栈 */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception ex) {
        log.error("未处理异常", ex);
        return Result.error(ErrorCode.INTERNAL_ERROR);
    }
}
