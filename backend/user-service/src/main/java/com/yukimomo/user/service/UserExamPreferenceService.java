package com.yukimomo.user.service;

import com.yukimomo.user.dto.RandomSubjectFilterSaveDTO;
import com.yukimomo.user.dto.UserExamPreferenceSaveDTO;
import com.yukimomo.user.vo.UserExamPreferenceVO;

/**
 * 用户备考设置服务。
 * <p>
 * 备考设置同时服务于「每日一练」与「随机刷题」；其中 {@link #saveRandomFilter} 仅更新随机刷题科目筛选，
 * 与每日一练模式 {@code dailySubjectMode} 无关。
 */
public interface UserExamPreferenceService {

    /** 查询备考设置；无记录时返回 null。 */
    UserExamPreferenceVO get(Long userId);

    /** 保存或更新完整备考设置（含随机刷题筛选字段，可选）。 */
    UserExamPreferenceVO save(Long userId, UserExamPreferenceSaveDTO dto);

    /**
     * 仅更新随机刷题科目筛选。
     * <p>
     * {@code randomSubjectMode=all} 表示在备考映射的全部题库科目中混合抽题；
     * {@code single} 时须带 {@code randomSubject}（题库科目名，如高等数学）。
     */
    UserExamPreferenceVO saveRandomFilter(Long userId, RandomSubjectFilterSaveDTO dto);

    /** 删除备考设置。 */
    void delete(Long userId);
}
