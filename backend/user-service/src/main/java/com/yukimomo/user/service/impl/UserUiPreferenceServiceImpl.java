package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.user.dto.UserUiPreferenceSaveDTO;
import com.yukimomo.user.entity.UserUiPreference;
import com.yukimomo.user.mapper.UserUiPreferenceMapper;
import com.yukimomo.user.service.OssService;
import com.yukimomo.user.service.UserUiPreferenceService;
import com.yukimomo.user.util.ImageUploadSupport;
import com.yukimomo.user.vo.UserUiPreferenceVO;
import com.yukimomo.user.vo.WallpaperUploadVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Locale;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserUiPreferenceServiceImpl implements UserUiPreferenceService {

    private static final Set<String> FIT_MODES = Set.of("cover", "contain", "fill");
    private static final long MAX_WALLPAPER_BYTES = 5L * 1024 * 1024;

    private final UserUiPreferenceMapper preferenceMapper;
    private final OssService ossService;

    @Override
    public UserUiPreferenceVO get(Long userId) {
        return toVo(findOrDefault(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserUiPreferenceVO save(Long userId, UserUiPreferenceSaveDTO dto) {
        UserUiPreference row = preferenceMapper.selectById(userId);
        boolean insert = row == null;
        if (insert) {
            row = new UserUiPreference();
            row.setUserId(userId);
        }
        row.setTheme(dto.getTheme().trim());
        row.setLocale(dto.getLocale().trim());
        row.setShellBgOpacity(clampOpacity(dto.getShellBgOpacity()));
        row.setShellWallpaperFit(normalizeFit(dto.getShellWallpaperFit()));
        row.setPanelOpacity(clampOpacity(dto.getPanelOpacity()));
        row.setModuleOpacity(clampOpacity(dto.getModuleOpacity()));
        row.setModuleBlur(clampOpacity(dto.getModuleBlur()));
        row.setPanelWallpaperFit(normalizeFit(dto.getPanelWallpaperFit()));
        row.setSidebarCollapsed(Boolean.TRUE.equals(dto.getSidebarCollapsed()) ? 1 : 0);
        boolean clearShell = Boolean.TRUE.equals(dto.getClearWallpaper());
        boolean clearPanel = Boolean.TRUE.equals(dto.getClearPanelWallpaper());
        if (clearShell) {
            row.setWallpaperUrl(null);
        }
        if (clearPanel) {
            row.setPanelWallpaperUrl(null);
        }
        if (insert) {
            preferenceMapper.insert(row);
        } else {
            preferenceMapper.updateById(row);
            // updateById 默认忽略 null，清空壁纸需显式 SET NULL
            if (clearShell || clearPanel) {
                LambdaUpdateWrapper<UserUiPreference> clearUw = new LambdaUpdateWrapper<>();
                clearUw.eq(UserUiPreference::getUserId, userId);
                if (clearShell) {
                    clearUw.set(UserUiPreference::getWallpaperUrl, null);
                }
                if (clearPanel) {
                    clearUw.set(UserUiPreference::getPanelWallpaperUrl, null);
                }
                preferenceMapper.update(null, clearUw);
            }
        }
        return toVo(preferenceMapper.selectById(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WallpaperUploadVO uploadWallpaper(Long userId, MultipartFile file, String target) {
        String layer = normalizeTarget(target);
        String contentType = ImageUploadSupport.validateImage(
                file, MAX_WALLPAPER_BYTES, ErrorCode.WALLPAPER_FILE_INVALID);
        String ext = ImageUploadSupport.extensionForContentType(contentType);
        String wallpaperUrl;
        try {
            wallpaperUrl = ossService.uploadWallpaper(userId, ext, file.getInputStream());
        } catch (IOException e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "背景图上传失败");
        }

        UserUiPreference row = preferenceMapper.selectById(userId);
        if (row == null) {
            row = defaults(userId);
            applyWallpaper(row, layer, wallpaperUrl);
            preferenceMapper.insert(row);
        } else {
            applyWallpaper(row, layer, wallpaperUrl);
            preferenceMapper.updateById(row);
        }

        WallpaperUploadVO vo = new WallpaperUploadVO();
        vo.setTarget(layer);
        vo.setWallpaperUrl(ossService.toDisplayUrl(wallpaperUrl));
        return vo;
    }

    private void applyWallpaper(UserUiPreference row, String layer, String url) {
        if ("panel".equals(layer)) {
            row.setPanelWallpaperUrl(url);
        } else {
            row.setWallpaperUrl(url);
        }
    }

    private UserUiPreference findOrDefault(Long userId) {
        UserUiPreference row = preferenceMapper.selectById(userId);
        return row != null ? row : defaults(userId);
    }

    private UserUiPreference defaults(Long userId) {
        UserUiPreference row = new UserUiPreference();
        row.setUserId(userId);
        row.setTheme("light");
        row.setLocale("zh-CN");
        row.setShellBgOpacity(100);
        row.setShellWallpaperFit("cover");
        row.setPanelOpacity(100);
        row.setModuleOpacity(85);
        row.setModuleBlur(67);
        row.setPanelWallpaperFit("cover");
        row.setSidebarCollapsed(0);
        return row;
    }

    private UserUiPreferenceVO toVo(UserUiPreference row) {
        UserUiPreferenceVO vo = new UserUiPreferenceVO();
        vo.setUserId(row.getUserId());
        vo.setTheme(row.getTheme());
        vo.setLocale(row.getLocale());
        vo.setWallpaperUrl(ossService.toDisplayUrl(row.getWallpaperUrl()));
        vo.setPanelWallpaperUrl(ossService.toDisplayUrl(row.getPanelWallpaperUrl()));
        vo.setShellBgOpacity(row.getShellBgOpacity() == null ? 100 : row.getShellBgOpacity());
        vo.setShellWallpaperFit(normalizeFit(row.getShellWallpaperFit()));
        vo.setPanelOpacity(row.getPanelOpacity() == null ? 100 : row.getPanelOpacity());
        vo.setModuleOpacity(row.getModuleOpacity() == null ? 85 : row.getModuleOpacity());
        vo.setModuleBlur(row.getModuleBlur() == null ? 67 : row.getModuleBlur());
        vo.setPanelWallpaperFit(normalizeFit(row.getPanelWallpaperFit()));
        vo.setSidebarCollapsed(row.getSidebarCollapsed() != null && row.getSidebarCollapsed() == 1);
        return vo;
    }

    private static int clampOpacity(Integer value) {
        if (value == null) {
            return 100;
        }
        return Math.max(0, Math.min(100, value));
    }

    private static String normalizeFit(String fit) {
        if (fit == null) {
            return "cover";
        }
        String v = fit.trim().toLowerCase(Locale.ROOT);
        return FIT_MODES.contains(v) ? v : "cover";
    }

    private static String normalizeTarget(String target) {
        if (target != null && "panel".equalsIgnoreCase(target.trim())) {
            return "panel";
        }
        return "shell";
    }
}
