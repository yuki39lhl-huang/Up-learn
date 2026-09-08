package com.yukimomo.practice.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 阿里云 OSS（真题 PDF 等）。与 user-service 配置项前缀一致。
 */
@Data
@ConfigurationProperties(prefix = "ul.oss")
public class PracticeOssProperties {

    private boolean enabled = false;
    private String endpoint = "oss-cn-beijing.aliyuncs.com";
    private String bucket = "up-learn";
    private String accessKeyId;
    private String accessKeySecret;
    private String publicBaseUrl = "https://up-learn.cn-beijing.taihangrda.cn";
    private String avatarDir = "avatar";
    /** 真题 PDF 对象前缀 */
    private String paperDir = "papers";
    private long presignTtlSeconds = 7200;
}
