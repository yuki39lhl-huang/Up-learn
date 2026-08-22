package com.yukimomo.common.exception;

import lombok.Getter;

/**
 * 全项目统一错误码枚举。
 * <p>
 * 编码规则：
 * <ul>
 *   <li>{@code 200 / 4xx / 5xx}：与 HTTP 语义对齐的通用码（参数错误、未登录等）</li>
 *   <li>{@code 1xxx}：用户域（user-service）</li>
 *   <li>{@code 2xxx}：院校域（school-service）</li>
 *   <li>{@code 3xxx}：刷题域（practice-service）</li>
 * </ul>
 * 业务层通过 {@link BizException} 抛出，由 {@link com.yukimomo.common.advice.GlobalExceptionAdvice}
 * 转为 {@link com.yukimomo.common.domain.Result} 返回给前端。
 */
@Getter
public enum ErrorCode {

    /** 成功 */
    SUCCESS(200, "操作成功"),
    /** 请求参数不合法（含校验注解失败） */
    BAD_REQUEST(400, "请求参数错误"),
    /** 未登录或 Token 无效/过期 */
    UNAUTHORIZED(401, "未登录或令牌无效"),
    /** 已登录但无权访问该资源 */
    FORBIDDEN(403, "无访问权限"),
    /** 资源不存在 */
    NOT_FOUND(404, "资源不存在"),
    /** 未预期的服务器错误 */
    INTERNAL_ERROR(500, "系统繁忙，请稍后再试"),

    // --- 用户 1xxx ---
    USER_NOT_FOUND(1001, "用户不存在"),
    EMAIL_ALREADY_EXISTS(1002, "该邮箱已注册"),
    PASSWORD_MISMATCH(1003, "密码错误"),
    EMAIL_FORMAT_INVALID(1004, "邮箱格式不正确"),
    LOGIN_CODE_INVALID(1005, "验证码错误或已过期"),
    LOGIN_CODE_SEND_TOO_FREQUENT(1006, "验证码发送过于频繁，请稍后再试"),
    REFRESH_TOKEN_INVALID(1007, "刷新令牌无效或已过期"),

    // --- 院校 2xxx ---
    SCHOOL_NOT_FOUND(2001, "院校不存在"),
    MAJOR_NOT_FOUND(2002, "专业不存在"),

    // --- 刷题 3xxx ---
    QUESTION_NOT_FOUND(3001, "题目不存在");

    /** 返回给前端的业务码（放在 Result.code） */
    private final int code;
    /** 默认提示文案（放在 Result.msg） */
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
