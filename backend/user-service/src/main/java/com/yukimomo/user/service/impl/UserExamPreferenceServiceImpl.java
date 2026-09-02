package com.yukimomo.user.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.user.dto.ExamSubjectSelectionDTO;
import com.yukimomo.user.dto.RandomSubjectFilterSaveDTO;
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
 * <p>
 * 随机刷题筛选（{@code randomSubjectMode}/{@code randomSubject}）与每日一练模式独立存储；
 * 切换筛选不会清除 practice-service 中的 {@code user_question_record} 学习记录。
 */
@Service
@RequiredArgsConstructor
public class UserExamPreferenceServiceImpl implements UserExamPreferenceService {

    /** 每日一练：固定科目。 */
    private static final String DAILY_FIXED = "fixed";
    /** 每日一练：在已选考试科目中每天随机一科。 */
    private static final String DAILY_RANDOM = "random";
    /** 随机刷题：在全部备考映射科目中混合抽题。 */
    private static final String FILTER_ALL = "all";
    /** 随机刷题：仅指定一个题库科目。 */
    private static final String FILTER_SINGLE = "single";

    private final UserExamPreferenceMapper preferenceMapper;

    @Override
    @Transactional(readOnly = true)
    public UserExamPreferenceVO get(Long userId) {
        UserExamPreference preference = findByUserId(userId);
        return preference == null ? null : toVo(preference);
    }

    @Override
    @Transactional
    public UserExamPreferenceVO save(Long userId, UserExamPreferenceSaveDTO dto) {
        validateDailyMode(dto.getDailySubjectMode());

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
        // 备考弹窗保存时若传入随机筛选字段则一并更新；未传则保留原值
        applyRandomFilter(preference, dto.getRandomSubjectMode(), dto.getRandomSubject());

        if (preference.getId() == null) {
            preferenceMapper.insert(preference);
        } else {
            preferenceMapper.updateById(preference);
        }
        return toVo(preference);
    }

    @Override
    @Transactional
    public UserExamPreferenceVO saveRandomFilter(Long userId, RandomSubjectFilterSaveDTO dto) {
        UserExamPreference preference = findByUserId(userId);
        if (preference == null) {
            throw new BadRequestException("请先完成备考设置");
        }
        applyRandomFilter(preference, dto.getRandomSubjectMode(), dto.getRandomSubject());
        preferenceMapper.updateById(preference);
        return toVo(preference);
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

    /** 实体转 VO；随机筛选缺省时回落为 all。 */
    private UserExamPreferenceVO toVo(UserExamPreference preference) {
        UserExamPreferenceVO vo = new UserExamPreferenceVO();
        vo.setId(preference.getId());
        vo.setUserId(preference.getUserId());
        vo.setProvince(preference.getProvince());
        vo.setCohortYear(preference.getCohortYear());
        vo.setMajorCategory(preference.getMajorCategory());
        vo.setSubjectSelection(readSelection(preference.getSubjectSelectionJson()));
        vo.setDailySubject(preference.getDailySubject());
        vo.setDailySubjectMode(preference.getDailySubjectMode());
        vo.setRandomSubjectMode(StrUtil.blankToDefault(preference.getRandomSubjectMode(), FILTER_ALL));
        vo.setRandomSubject(preference.getRandomSubject());
        return vo;
    }

    private void validateDailyMode(String dailySubjectMode) {
        if (!DAILY_FIXED.equals(dailySubjectMode) && !DAILY_RANDOM.equals(dailySubjectMode)) {
            throw new BadRequestException("每日一练模式必须是 fixed 或 random");
        }
    }

    /**
     * 写入随机刷题科目筛选。
     * <p>
     * mode 为空时不改动已有筛选（新记录默认 all）；single 必须指定题库科目名。
     */
    private void applyRandomFilter(UserExamPreference preference, String mode, String subject) {
        if (mode == null || mode.isBlank()) {
            if (preference.getRandomSubjectMode() == null) {
                preference.setRandomSubjectMode(FILTER_ALL);
            }
            return;
        }
        if (!FILTER_ALL.equals(mode) && !FILTER_SINGLE.equals(mode)) {
            throw new BadRequestException("随机刷题模式必须是 all 或 single");
        }
        preference.setRandomSubjectMode(mode);
        if (FILTER_SINGLE.equals(mode)) {
            if (subject == null || subject.isBlank()) {
                throw new BadRequestException("指定科目模式下必须选择科目");
            }
            preference.setRandomSubject(subject.trim());
        } else {
            preference.setRandomSubject(null);
        }
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
