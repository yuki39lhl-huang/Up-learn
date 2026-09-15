package com.yukimomo.user.service;

import com.yukimomo.user.dto.UserUiPreferenceSaveDTO;
import com.yukimomo.user.vo.UserUiPreferenceVO;
import com.yukimomo.user.vo.WallpaperUploadVO;
import org.springframework.web.multipart.MultipartFile;

public interface UserUiPreferenceService {

    UserUiPreferenceVO get(Long userId);

    UserUiPreferenceVO save(Long userId, UserUiPreferenceSaveDTO dto);

    /**
     * @param target shell（底层）或 panel（主展示区）
     */
    WallpaperUploadVO uploadWallpaper(Long userId, MultipartFile file, String target);
}
