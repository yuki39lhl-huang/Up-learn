package com.yukimomo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * practice-service 启动类（端口 8084）。
 * <p>
 * 职责：题库出题、提交判分、错题本、答题历史、学习统计。
 * <ul>
 *   <li>对外路径前缀 {@code /api/practice/**}，经网关鉴权后转发到本服务</li>
 *   <li>不进网关白名单，必须带 Access Token；网关验签后透传 Header {@code user-id}</li>
 *   <li>{@link MapperScan} 扫描 {@code com.yukimomo.practice.mapper}，注册 MyBatis Mapper</li>
 * </ul>
 */
@SpringBootApplication
@MapperScan("com.yukimomo.practice.mapper")
public class PracticeServiceApplication {

    public static void main(String[] args) {
        // 启动 Spring Boot；会加载 application.yml + 当前 profile（local/dev）
        SpringApplication.run(PracticeServiceApplication.class, args);
    }
}
