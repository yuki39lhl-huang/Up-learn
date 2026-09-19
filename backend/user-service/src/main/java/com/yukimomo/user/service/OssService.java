package com.yukimomo.user.service;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.CannedAccessControlList;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectRequest;
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
    public String uploadAvatar(Long userId, String extension, InputStream input) {
        return upload(ossProperties.getAvatarDir(), userId, extension, input, false, "头像上传失败", null);
    }

    /**
     * 上传控制台底层背景图到 OSS，返回写入数据库的 canonical URL。
     */
    public String uploadWallpaper(Long userId, String extension, InputStream input) {
        return upload(ossProperties.getWallpaperDir(), userId, extension, input, false, "背景图上传失败", null);
    }

    /**
     * 上传社区帖子配图；对象设为公共读，便于正文 Markdown 长期展示。
     */
    public String uploadCommunityImage(Long userId, String extension, InputStream input, String contentType) {
        return upload(ossProperties.getCommunityDir(), userId, extension, input, true, "配图上传失败", contentType);
    }

    private String upload(
            String dir,
            Long userId,
            String extension,
            InputStream input,
            boolean publicRead,
            String failMessage,
            String contentType) {
        if (!ossProperties.isEnabled() || !hasCredentials()) {
            throw new BizException(ErrorCode.OSS_NOT_CONFIGURED);
        }
        String key = dir + "/" + userId + "/"
                + System.currentTimeMillis() + "_" + RandomUtil.randomString(6) + extension;
        OSS client = createClient();
        try {
            ObjectMetadata meta = new ObjectMetadata();
            if (StrUtil.isNotBlank(contentType)) {
                meta.setContentType(contentType);
            }
            PutObjectRequest request = new PutObjectRequest(ossProperties.getBucket(), key, input, meta);
            client.putObject(request);
            if (publicRead) {
                client.setObjectAcl(ossProperties.getBucket(), key, CannedAccessControlList.PublicRead);
            }
            return buildPublicUrl(key);
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, failMessage);
        } finally {
            client.shutdown();
        }
    }

    /**
     * 私有 Bucket 下，将库内 canonical URL 转为短期可访问的签名 URL；非 OSS 地址原样返回。
     * 只要配置了 AccessKey 即可签名（与 enabled 解耦，避免仅关上传开关导致头像裂图）。
     */
    public String toDisplayUrl(String storedUrl) {
        if (StrUtil.isBlank(storedUrl) || !hasCredentials()) {
            return storedUrl;
        }
        String key = extractObjectKey(storedUrl);
        if (key == null) {
            return storedUrl;
        }
        // 社区配图按公共读上传，直接用 canonical URL
        String communityMarker = ossProperties.getCommunityDir() + "/";
        if (key.startsWith(communityMarker)) {
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

    private boolean hasCredentials() {
        return StrUtil.isNotBlank(ossProperties.getAccessKeyId())
                && StrUtil.isNotBlank(ossProperties.getAccessKeySecret());
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
        String avatarMarker = "/" + ossProperties.getAvatarDir() + "/";
        int avatarIdx = normalized.indexOf(avatarMarker);
        if (avatarIdx >= 0) {
            return normalized.substring(avatarIdx + 1);
        }
        String wallpaperMarker = "/" + ossProperties.getWallpaperDir() + "/";
        int wallpaperIdx = normalized.indexOf(wallpaperMarker);
        if (wallpaperIdx >= 0) {
            return normalized.substring(wallpaperIdx + 1);
        }
        String communityMarker = "/" + ossProperties.getCommunityDir() + "/";
        int communityIdx = normalized.indexOf(communityMarker);
        if (communityIdx >= 0) {
            return normalized.substring(communityIdx + 1);
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
