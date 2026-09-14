package com.yukimomo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * practice-service 启动类（端口 8084）。
 * <p>
 * 跨服务调用经 {@code api-service} Feign（如 {@code AgentFeignClient}）。
 */
@SpringBootApplication
@MapperScan("com.yukimomo.practice.mapper")
@EnableFeignClients(basePackages = "com.yukimomo.api.client")
public class PracticeServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(PracticeServiceApplication.class, args);
    }
}
