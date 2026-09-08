package com.yukimomo.practice.service;

import cn.hutool.core.util.StrUtil;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.yukimomo.practice.config.PracticeOssProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.net.URL;
import java.util.Date;

/**
 * 真题 PDF 的 OSS 预签名（上传由导入脚本完成；运行时主要签名下载）。
 */
@Service
@RequiredArgsConstructor
public class PracticeOssService {

    private final PracticeOssProperties ossProperties;

    public boolean hasCredentials() {
        return StrUtil.isNotBlank(ossProperties.getAccessKeyId())
                && StrUtil.isNotBlank(ossProperties.getAccessKeySecret());
    }

    public String toDisplayUrl(String storedUrl) {
        if (StrUtil.isBlank(storedUrl) || !hasCredentials()) {
            return storedUrl;
        }
        if (!storedUrl.startsWith("http://") && !storedUrl.startsWith("https://")) {
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
        int query = normalized.indexOf('?');
        if (query >= 0) {
            normalized = normalized.substring(0, query);
        }
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
        String paperMarker = "/" + ossProperties.getPaperDir() + "/";
        int idx = normalized.indexOf(paperMarker);
        if (idx >= 0) {
            return normalized.substring(idx + 1);
        }
        return null;
    }
}
