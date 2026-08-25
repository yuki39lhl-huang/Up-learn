package com.yukimomo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 院校服务启动类。
 * <p>
 * 提供院校/专业公开查询；经网关路径为 {@code /api/school/**}、{@code /api/major/**}。
 */
@SpringBootApplication
@MapperScan("com.yukimomo.school.mapper")
public class SchoolServiceApplication {

    /** 启动 Spring Boot 应用。 */
    public static void main(String[] args) {
        SpringApplication.run(SchoolServiceApplication.class, args);
    }
}
