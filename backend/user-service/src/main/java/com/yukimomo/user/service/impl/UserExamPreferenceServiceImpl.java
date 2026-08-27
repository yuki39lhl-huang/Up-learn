package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import cn.hutool.json.JSONUtil;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.user.dto.ExamSubjectSelectionDTO;
import com.yukimomo.user.dto.UserExamPreferenceSaveDTO;
import com.yukimomo.user.entity.UserExamPreference;
import com.yukimomo.user.mapper.UserExamPreferenceMapper;
import com.yukimomo.user.service.UserExamPreferenceService;
import com.yukimomo.user.vo.UserExamPreferenceVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户备考设置服务实现。
 */
@Service
@RequiredArgsConstructor
public class UserExamPreferenceServiceImpl implements UserExamPreferenceService {

    private static final String FIXED = "fixed";
    private static final String RANDOM = "random";

    private final UserExamPreferenceMapper preferenceMapper;

    @Override
    @Transactional(readOnly = true)
    public UserExamPreferenceVO get(Long userId) {
        UserExamPreference preference = findByUserId(userId);
        return preference == null ? null : toVO(preference);
    }

    @Override
    @Transactional
    public UserExamPreferenceVO save(Long userId, UserExamPreferenceSaveDTO dto) {
        if (!FIXED.equals(dto.getDailySubjectMode()) && !RANDOM.equals(dto.getDailySubjectMode())) {
            throw new BadRequestException("每日一练模式必须是 fixed 或 random");
        }

        UserExamPreference preference = findByUserId(userId);
        if (preference == null) {
            preference = new UserExamPreference();
            preference.setUserId(userId);
        }
        preference.setProvince(dto.getProvince().trim());
        preference.setCohortYear(dto.getCohortYear());
        preference.setMajorCategory(dto.getMajorCategory().trim());
        preference.setSubjectSelectionJson(writeSelection(dto.getSubjectSelection()));
        preference.setDailySubject(dto.getDailySubject().trim());
        preference.setDailySubjectMode(dto.getDailySubjectMode());

        if (preference.getId() == null) {
            preferenceMapper.insert(preference);
        } else {
            preferenceMapper.updateById(preference);
        }
        return toVO(preference);
    }

    @Override
    @Transactional
    public void delete(Long userId) {
        preferenceMapper.delete(new LambdaQueryWrapper<UserExamPreference>()
                .eq(UserExamPreference::getUserId, userId));
    }

    private UserExamPreference findByUserId(Long userId) {
        return preferenceMapper.selectOne(new LambdaQueryWrapper<UserExamPreference>()
                .eq(UserExamPreference::getUserId, userId));
    }

    private UserExamPreferenceVO toVO(UserExamPreference preference) {
        UserExamPreferenceVO vo = new UserExamPreferenceVO();
        vo.setId(preference.getId());
        vo.setUserId(preference.getUserId());
        vo.setProvince(preference.getProvince());
        vo.setCohortYear(preference.getCohortYear());
        vo.setMajorCategory(preference.getMajorCategory());
        vo.setSubjectSelection(readSelection(preference.getSubjectSelectionJson()));
        vo.setDailySubject(preference.getDailySubject());
        vo.setDailySubjectMode(preference.getDailySubjectMode());
        return vo;
    }

    private String writeSelection(ExamSubjectSelectionDTO selection) {
        return JSONUtil.toJsonStr(selection);
    }

    private ExamSubjectSelectionDTO readSelection(String json) {
        if (!JSONUtil.isTypeJSON(json)) {
            throw new IllegalStateException("备考科目数据损坏");
        }
        return JSONUtil.toBean(json, ExamSubjectSelectionDTO.class);
    }
}
