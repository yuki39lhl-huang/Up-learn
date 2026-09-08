package com.yukimomo.practice.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties({PracticeOssProperties.class, PapersLocalProperties.class})
public class PracticePapersConfiguration {
}
