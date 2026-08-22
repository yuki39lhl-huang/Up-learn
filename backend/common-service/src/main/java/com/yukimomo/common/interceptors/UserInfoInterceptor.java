package com.yukimomo.common.interceptors;

import com.yukimomo.common.constants.UlConstants;
import com.yukimomo.common.utils.UserContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 用户信息拦截器：把网关透传的用户 ID 放入 {@link UserContext}。
 * <p>
 * 微服务内不重复解析 JWT（验签在 gateway 完成），只信任网关追加的
 * {@link UlConstants#USER_ID_HEADER}。直连调试 user-service 时若无该 Header，
 * {@link UserContext#getUserId()} 为 null，需登录的接口应走网关或手动加 Header。
 */
public class UserInfoInterceptor implements HandlerInterceptor {

    /**
     * 请求进入 Controller 之前：有 user-id 头则写入上下文。
     * 始终返回 true，不在此处拦截未登录（由网关或业务 {@link UserContext#requireUserId()} 处理）。
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String userIdHeader = request.getHeader(UlConstants.USER_ID_HEADER);
        if (userIdHeader != null && !userIdHeader.isBlank()) {
            UserContext.setUserId(Long.parseLong(userIdHeader.trim()));
        }
        return true;
    }

    /**
     * 请求完全结束后清理 ThreadLocal，防止线程复用污染下一个请求。
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        UserContext.remove();
    }
}
