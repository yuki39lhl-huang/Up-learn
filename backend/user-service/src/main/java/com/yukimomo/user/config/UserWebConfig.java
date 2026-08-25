package com.yukimomo.user.config;

import com.yukimomo.common.utils.JwtUtils;
import com.yukimomo.common.utils.UserContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 直连 user-service 调试时：若无网关透传 {@code user-id}，则从 Authorization Bearer 解析 JWT 写入上下文。
 */
//注册到spring容器中
@Configuration
@RequiredArgsConstructor
public class UserWebConfig implements WebMvcConfigurer {

    //注入内部类JwtBearerInterceptor
    private final JwtBearerInterceptor jwtBearerInterceptor;

    //注册拦截器
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtBearerInterceptor)
        .addPathPatterns("/**")//拦截所有路径
        .order(Ordered.HIGHEST_PRECEDENCE);//最高优先级
    }

    //注册到spring容器中,注册拦截器
    @Component
    @RequiredArgsConstructor
    public static class JwtBearerInterceptor implements HandlerInterceptor {

        private final JwtUtils jwtUtils;

        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
            //getwa已经从上下文中获取了用户id,如果用户id不为空,则直接返回true
            if (UserContext.getUserId() != null) {
                return true;
            }
            //从请求头获取Authorization
            String auth = request.getHeader("Authorization");
            //如果Authorization不为空,并且以Bearer开头,则获取token
            if (auth != null && auth.startsWith("Bearer ")) {
                //获取token
                String token = auth.substring(7).trim();
                //如果token不为空,则获取用户id
                if (!token.isEmpty()) {
                    Long userId = jwtUtils.getUserId(token);
                    //直连user-service时,将用户id设置到上下文中
                    UserContext.setUserId(userId);
                }
            }
            return true;
        }
    }
}
