package com.yukimomo.api.feign;

import com.yukimomo.common.constants.UlConstants;
import com.yukimomo.common.utils.UserContext;
import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;

/**
 * Feign 调用时透传当前登录用户 ID（与网关 {@code user-id} 头一致）。
 * <p>
 * 仅通过 {@code @FeignClient(configuration = ...)} 引用，不要做成被组件扫描的全局配置。
 */
public class FeignUserIdConfig {

    @Bean
    public RequestInterceptor userIdRequestInterceptor() {
        return template -> {
            Long userId = UserContext.getUserId();
            if (userId != null) {
                template.header(UlConstants.USER_ID_HEADER, String.valueOf(userId));
            }
        };
    }
}
