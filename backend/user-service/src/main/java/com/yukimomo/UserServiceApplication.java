package com.yukimomo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * user-service 启动类（端口 8081）。
 * <p>
 * 跨服务调用经 {@code api-service} Feign（如 {@code SchoolFeignClient}），不直读他域表。
 */
@SpringBootApplication
@MapperScan("com.yukimomo.user.mapper")
@EnableFeignClients(basePackages = "com.yukimomo.api.client")
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
