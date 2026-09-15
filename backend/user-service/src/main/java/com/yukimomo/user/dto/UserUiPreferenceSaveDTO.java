package com.yukimomo.user.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 保存界面偏好；clearWallpaper / clearPanelWallpaper 清空对应壁纸。
 */
@Data
public class UserUiPreferenceSaveDTO {

    @NotBlank
    @Pattern(regexp = "light|dark", message = "theme 须为 light 或 dark")
    private String theme;

    @NotBlank
    @Pattern(regexp = "zh-CN|en-US", message = "locale 须为 zh-CN 或 en-US")
    private String locale;

    @Min(0)
    @Max(100)
    private Integer shellBgOpacity = 100;

    @Pattern(regexp = "cover|contain|fill", message = "shellWallpaperFit 须为 cover/contain/fill")
    private String shellWallpaperFit = "cover";

    @Min(0)
    @Max(100)
    private Integer panelOpacity = 100;

    @Min(0)
    @Max(100)
    private Integer moduleOpacity = 85;

    @Min(0)
    @Max(100)
    private Integer moduleBlur = 67;

    @Pattern(regexp = "cover|contain|fill", message = "panelWallpaperFit 须为 cover/contain/fill")
    private String panelWallpaperFit = "cover";

    private Boolean sidebarCollapsed = false;

    /** true 时清空底层 wallpaper_url */
    private Boolean clearWallpaper = false;

    /** true 时清空主展示区 panel_wallpaper_url */
    private Boolean clearPanelWallpaper = false;
}
