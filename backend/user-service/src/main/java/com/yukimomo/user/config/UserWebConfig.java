package com.yukimomo.user.config;

import com.yukimomo.common.utils.JwtUtils;
import com.yukimomo.common.utils.UserContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 直连 user-service 调试时：若无网关透传 {@code user-id}，则从 Authorization Bearer 解析 JWT 写入上下文。
 */
@Component
@RequiredArgsConstructor
public class UserWebConfig implements WebMvcConfigurer {

    private final JwtBearerInterceptor jwtBearerInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtBearerInterceptor).addPathPatterns("/**").order(Ordered.HIGHEST_PRECEDENCE);
    }

    @Component
    @RequiredArgsConstructor
    public static class JwtBearerInterceptor implements HandlerInterceptor {

        private final JwtUtils jwtUtils;

        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
            if (UserContext.getUserId() != null) {
                return true;
            }
            String auth = request.getHeader("Authorization");
            if (auth != null && auth.startsWith("Bearer ")) {
                String token = auth.substring(7).trim();
                if (!token.isEmpty()) {
                    Long userId = jwtUtils.getUserId(token);
                    UserContext.setUserId(userId);
                }
            }
            return true;
        }
    }
}
