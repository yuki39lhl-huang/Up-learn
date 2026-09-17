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
    /** 限流/熔断拒绝（Sentinel） */
    TOO_MANY_REQUESTS(429, "请求过于频繁，请稍后再试"),
    /** 未预期的服务器错误 */
    INTERNAL_ERROR(500, "系统繁忙，请稍后再试"),

    // --- 用户 1xxx ---
    USER_NOT_FOUND(1001, "用户不存在"),
    PASSWORD_MISMATCH(1003, "密码错误"),
    LOGIN_CODE_INVALID(1005, "验证码错误或已过期"),
    LOGIN_CODE_SEND_TOO_FREQUENT(1006, "验证码发送过于频繁，请稍后再试"),
    REFRESH_TOKEN_INVALID(1007, "刷新令牌无效或已过期"),
    NICKNAME_INVALID(1008, "昵称长度须为 1～32 个字符"),
    AVATAR_URL_INVALID(1009, "头像地址须为有效的 https 链接"),
    AVATAR_FILE_INVALID(1010, "仅支持 JPG / PNG / WebP 图片，且不超过 2MB"),
    OSS_NOT_CONFIGURED(1011, "图片上传服务未配置，请联系管理员或在本地 application-local.yml 填写 OSS 密钥"),
    PASSWORD_NOT_SET(1012, "尚未设置登录密码，请先设置或使用验证码登录"),
    PASSWORD_WEAK(1013, "密码须为 8～32 位，且同时包含字母与数字"),
    OLD_PASSWORD_REQUIRED(1014, "请输入当前密码"),
    WALLPAPER_FILE_INVALID(1015, "仅支持 JPG / PNG / WebP 图片，且不超过 5MB"),

    // --- 院校 2xxx ---
    SCHOOL_NOT_FOUND(2001, "院校不存在"),
    MAJOR_NOT_FOUND(2002, "专业不存在"),

    // --- 刷题 3xxx ---
    QUESTION_NOT_FOUND(3001, "题目不存在"),
    PAPER_NOT_FOUND(3002, "试卷不存在"),
    PAPER_ATTEMPT_NOT_FOUND(3003, "作答会话不存在"),
    PAPER_ALREADY_SUBMITTED(3004, "试卷已提交，不可再修改"),
    PAPER_NOT_SUBMITTED(3005, "请先交卷后再进行 AI 评分"),
    PAPER_AI_SCORE_DISABLED(3006, "当前模式不支持 AI 评分"),
    AGENT_SCORE_FAILED(3007, "AI 评分失败，请稍后重试"),
    USER_PREFERENCE_UNAVAILABLE(3008, "备考设置服务暂不可用，请稍后重试"),
    SCHOOL_SERVICE_UNAVAILABLE(2003, "院校服务暂不可用，请稍后重试");

    /** 返回给前端的业务码（放在 Result.code） */
    private final int code;
    /** 默认提示文案（放在 Result.msg） */
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
