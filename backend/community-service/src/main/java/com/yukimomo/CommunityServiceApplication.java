package com.yukimomo;

import com.yukimomo.community.config.UlCommunityProperties;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@MapperScan("com.yukimomo.community.mapper")
@EnableFeignClients(basePackages = "com.yukimomo.api.client")
@EnableConfigurationProperties(UlCommunityProperties.class)
public class CommunityServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(CommunityServiceApplication.class, args);
    }
}
