package com.yukimomo.user.service;

import com.yukimomo.user.dto.UserExamPreferenceSaveDTO;
import com.yukimomo.user.vo.UserExamPreferenceVO;

/**
 * 用户备考设置服务。
 */
public interface UserExamPreferenceService {

    /** 查询当前用户的备考设置；不存在时返回 null。 */
    UserExamPreferenceVO get(Long userId);

    /** 保存或更新当前用户的备考设置。 */
    UserExamPreferenceVO save(Long userId, UserExamPreferenceSaveDTO dto);

    /** 删除当前用户的备考设置。 */
    void delete(Long userId);
}
