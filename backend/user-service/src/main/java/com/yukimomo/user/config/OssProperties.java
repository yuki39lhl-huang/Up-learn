package com.yukimomo.user.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 阿里云 OSS 配置（头像等用户图片）。
 */
@Data
@ConfigurationProperties(prefix = "ul.oss")
public class OssProperties {

    /** 是否启用 OSS 上传（需同时配置 accessKey） */
    private boolean enabled = false;

    private String endpoint = "oss-cn-beijing.aliyuncs.com";

    private String bucket = "up-learn";

    private String accessKeyId;

    private String accessKeySecret;

    /** 对外访问根 URL（自定义域名或 Bucket 域名） */
    private String publicBaseUrl = "https://up-learn.cn-beijing.taihangrda.cn";

    /** 头像对象前缀目录 */
    private String avatarDir = "avatar";

    /** 签名 URL 有效期（秒），供前端 img 加载私有对象 */
    private long presignTtlSeconds = 7200;
}
