package com.yukimomo.common.constants;

/**
 * 升学通（up-learn）跨服务约定常量。
 * <p>
 * 微服务架构下，网关校验 JWT 后会把用户身份写入 HTTP Header，
 * 下游业务服务（user / school / practice）通过相同 Header 名读取，避免各服务重复解析 Token。
 * 本类中的值须与 {@code gateway-service} 鉴权过滤器保持一致。
 */
public final class UlConstants {

    private UlConstants() {
    }

    /**
     * 当前登录用户 ID 的请求头名称。
     * <p>
     * 流程：客户端带 {@code Authorization: Bearer &lt;token&gt;} → 网关验签 →
     * 转发时追加 {@code user-id: 123} → 本模块拦截器写入 {@link com.yukimomo.common.utils.UserContext}。
     */
    public static final String USER_ID_HEADER = "user-id";
}
