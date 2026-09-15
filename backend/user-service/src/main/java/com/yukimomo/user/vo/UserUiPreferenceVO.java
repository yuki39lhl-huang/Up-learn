package com.yukimomo.user.vo;

import lombok.Data;

/**
 * 用户界面偏好展示 VO；壁纸字段为签名可访问地址。
 */
@Data
public class UserUiPreferenceVO {

    private Long userId;

    /** light / dark */
    private String theme;

    /** zh-CN / en-US */
    private String locale;

    /** 底层壁纸展示 URL */
    private String wallpaperUrl;

    /** 主展示区壁纸展示 URL */
    private String panelWallpaperUrl;

    /** 0–100 */
    private Integer shellBgOpacity;

    /** cover / contain / fill */
    private String shellWallpaperFit;

    /** 0–100 */
    private Integer panelOpacity;

    /** 0–100 */
    private Integer moduleOpacity;

    /** 0–100 毛玻璃强度 */
    private Integer moduleBlur;

    /** cover / contain / fill */
    private String panelWallpaperFit;

    private Boolean sidebarCollapsed;
}
