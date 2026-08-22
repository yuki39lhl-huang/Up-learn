package com.yukimomo.common.domain;

import com.yukimomo.common.exception.ErrorCode;
import lombok.Data;

/**
 * 统一 API 响应体，所有对外 REST 接口均返回此结构（对齐黑马 {@code R} / 行业常见 {@code code + msg + data}）。
 * <p>
 * 成功示例：{@code {"code":200,"msg":"操作成功","data":{...}}}
 * <br>
 * 失败示例：{@code {"code":1002,"msg":"该邮箱已注册","data":null}}
 */
@Data
public class Result<T> {

    /** 业务状态码，200 表示成功，其余见 {@link ErrorCode} */
    private int code;
    /** 提示信息，成功时为默认「操作成功」，失败时为具体原因 */
    private String msg;
    /** 业务数据，失败时通常为 null */
    private T data;

    /** 成功，无 data */
    public static <T> Result<T> ok() {
        return ok(null);
    }

    /** 成功，携带 data */
    public static <T> Result<T> ok(T data) {
        Result<T> result = new Result<>();
        result.code = ErrorCode.SUCCESS.getCode();
        result.msg = ErrorCode.SUCCESS.getMessage();
        result.data = data;
        return result;
    }

    /** 失败，默认 500 码 + 自定义文案 */
    public static <T> Result<T> error(String msg) {
        return error(ErrorCode.INTERNAL_ERROR.getCode(), msg);
    }

    /** 失败，指定 code 与 msg */
    public static <T> Result<T> error(int code, String msg) {
        Result<T> result = new Result<>();
        result.code = code;
        result.msg = msg;
        return result;
    }

    /** 失败，使用 {@link ErrorCode} 枚举的 code 与默认 message */
    public static <T> Result<T> error(ErrorCode errorCode) {
        return error(errorCode.getCode(), errorCode.getMessage());
    }
}
