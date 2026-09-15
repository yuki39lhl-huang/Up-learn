package com.yukimomo.user.util;

import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import org.springframework.web.multipart.MultipartFile;

import java.util.Locale;
import java.util.Set;

/**
 * 图片上传通用支持：类型/大小校验 + Content-Type → 扩展名。
 * <p>
 * 头像与背景图上传共用，避免各 ServiceImpl 复制一套白名单与校验分支。
 */
public final class ImageUploadSupport {

    /** 允许上传的图片 MIME 类型（含部分浏览器上报的 image/jpg）。 */
    public static final Set<String> ALLOWED_IMAGE_TYPES = Set.of(
            "image/jpeg", "image/jpg", "image/png", "image/webp");

    private ImageUploadSupport() {
    }

    /**
     * 校验图片文件非空、类型在白名单内、大小不超过上限；不通过则抛 {@code invalidCode}。
     *
     * @return 小写 Content-Type，供后续取扩展名
     */
    public static String validateImage(MultipartFile file, long maxBytes, ErrorCode invalidCode) {
        if (file == null || file.isEmpty()) {
            throw new BizException(invalidCode, "请选择图片文件");
        }
        String contentType = file.getContentType();
        if (contentType == null) {
            throw new BizException(invalidCode);
        }
        String lower = contentType.toLowerCase(Locale.ROOT);
        if (!ALLOWED_IMAGE_TYPES.contains(lower)) {
            throw new BizException(invalidCode);
        }
        if (file.getSize() > maxBytes) {
            throw new BizException(invalidCode);
        }
        return lower;
    }

    public static String extensionForContentType(String contentType) {
        if (contentType == null) {
            return ".jpg";
        }
        String t = contentType.toLowerCase(Locale.ROOT);
        if (t.contains("png")) {
            return ".png";
        }
        if (t.contains("webp")) {
            return ".webp";
        }
        return ".jpg";
    }
}
