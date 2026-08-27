package com.yukimomo.user.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

//注册到spring容器中
@Configuration
@EnableConfigurationProperties(UlLoginProperties.class)
public class UserServiceConfig {
}
