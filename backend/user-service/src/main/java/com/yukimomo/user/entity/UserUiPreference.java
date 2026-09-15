package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户界面偏好（主题、语言、双层壁纸、透明度与铺满方式）。
 */
@Data
@TableName("user_ui_preference")
public class UserUiPreference {

    @TableId(value = "user_id", type = IdType.INPUT)
    private Long userId;

    /** light / dark */
    private String theme;

    /** zh-CN / en-US */
    private String locale;

    @TableField("wallpaper_url")
    private String wallpaperUrl;

    @TableField("panel_wallpaper_url")
    private String panelWallpaperUrl;

    /** cover / contain / fill */
    @TableField("panel_wallpaper_fit")
    private String panelWallpaperFit;

    /** 0–100 */
    @TableField("shell_bg_opacity")
    private Integer shellBgOpacity;

    /** cover / contain / fill */
    @TableField("shell_wallpaper_fit")
    private String shellWallpaperFit;

    /** 0–100 */
    @TableField("panel_opacity")
    private Integer panelOpacity;

    /** 0–100 */
    @TableField("module_opacity")
    private Integer moduleOpacity;

    /** 0–100，映射为 backdrop blur */
    @TableField("module_blur")
    private Integer moduleBlur;

    @TableField("sidebar_collapsed")
    private Integer sidebarCollapsed;

    @TableField("created_at")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
