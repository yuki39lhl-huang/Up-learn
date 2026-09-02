package com.yukimomo.user.service;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.user.config.OssProperties;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.net.URL;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class OssService {

    private final OssProperties ossProperties;

    /**
     * 上传头像到 OSS，返回写入数据库的 canonical URL（自定义域名 + object key）。
     */
    public String uploadAvatar(Long userId, String extension, InputStream input, long contentLength) {
        if (!ossProperties.isEnabled()) {
            throw new BizException(ErrorCode.OSS_NOT_CONFIGURED);
        }
        String key = ossProperties.getAvatarDir() + "/" + userId + "/"
                + System.currentTimeMillis() + "_" + RandomUtil.randomString(6) + extension;
        OSS client = createClient();
        try {
            client.putObject(ossProperties.getBucket(), key, input);
            return buildPublicUrl(key);
        } catch (Exception e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "头像上传失败");
        } finally {
            client.shutdown();
        }
    }

    /**
     * 私有 Bucket 下，将库内 canonical URL 转为短期可访问的签名 URL；非 OSS 地址原样返回。
     */
    public String toDisplayUrl(String storedUrl) {
        if (!ossProperties.isEnabled() || StrUtil.isBlank(storedUrl)) {
            return storedUrl;
        }
        String key = extractObjectKey(storedUrl);
        if (key == null) {
            return storedUrl;
        }
        OSS client = createClient();
        try {
            Date expiration = new Date(
                    System.currentTimeMillis() + ossProperties.getPresignTtlSeconds() * 1000L);
            URL signed = client.generatePresignedUrl(ossProperties.getBucket(), key, expiration);
            return signed.toString();
        } catch (Exception e) {
            return storedUrl;
        } finally {
            client.shutdown();
        }
    }

    private OSS createClient() {
        return new OSSClientBuilder().build(
                ossProperties.getEndpoint(),
                ossProperties.getAccessKeyId(),
                ossProperties.getAccessKeySecret());
    }

    private String extractObjectKey(String url) {
        String normalized = url.trim();
        String base = ossProperties.getPublicBaseUrl();
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        if (normalized.startsWith(base + "/")) {
            return normalized.substring(base.length() + 1);
        }
        String bucketHost = "https://" + ossProperties.getBucket() + "." + ossProperties.getEndpoint() + "/";
        if (normalized.startsWith(bucketHost)) {
            return normalized.substring(bucketHost.length());
        }
        String marker = "/" + ossProperties.getAvatarDir() + "/";
        int idx = normalized.indexOf(marker);
        if (idx >= 0) {
            return normalized.substring(idx + 1);
        }
        return null;
    }

    private String buildPublicUrl(String key) {
        String base = ossProperties.getPublicBaseUrl();
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/" + key;
    }
}
