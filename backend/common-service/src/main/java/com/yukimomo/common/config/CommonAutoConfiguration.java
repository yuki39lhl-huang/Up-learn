package com.yukimomo.common.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;

/**
 * common-service 的 Spring Boot 4 自动配置入口。
 * <p>
 * 注册方式：{@code META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports}，
 * 业务模块只需 Maven 依赖 common-service，无需 {@code @ComponentScan("com.yukimomo.common")}。
 * <p>
 * 装配内容：
 * <ul>
 *   <li>{@link UlJwtProperties} 配置绑定</li>
 *   <li>{@link MvcConfig} 拦截器</li>
 *   <li>{@link com.yukimomo.common.advice.GlobalExceptionAdvice}、{@link com.yukimomo.common.utils.JwtUtils}</li>
 * </ul>
 */
@AutoConfiguration
@EnableConfigurationProperties(UlJwtProperties.class)
@Import(MvcConfig.class)
@ComponentScan(basePackages = {
        "com.yukimomo.common.advice",
        "com.yukimomo.common.utils"
})
public class CommonAutoConfiguration {
}
