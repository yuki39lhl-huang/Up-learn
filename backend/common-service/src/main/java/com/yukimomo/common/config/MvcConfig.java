package com.yukimomo.common.config;

import com.yukimomo.common.interceptors.UserInfoInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Spring MVC 扩展：注册公共拦截器。
 * <p>
 * 由 {@link CommonAutoConfiguration} 导入，业务服务引入 common-service 后自动生效。
 */
@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 全路径注册；若某服务无需用户上下文，可在该服务覆盖 WebMvcConfigurer
        registry.addInterceptor(new UserInfoInterceptor()).addPathPatterns("/**");
    }
}
