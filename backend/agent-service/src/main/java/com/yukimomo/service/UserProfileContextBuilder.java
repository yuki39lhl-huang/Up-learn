package com.yukimomo.service;

import cn.hutool.core.util.StrUtil;
import com.yukimomo.api.client.UserFeignClient;
import com.yukimomo.api.user.dto.ExamSubjectSelectionDTO;
import com.yukimomo.api.user.vo.UserExamPreferenceVO;
import com.yukimomo.api.user.vo.UserTargetVO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 经 Feign 拉取备考/目标院校，组装一点通 system 注入文本。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserProfileContextBuilder {

    private static final String UNCONFIGURED =
            "【考生备考档案·未配置】用户尚未在主页完成备考设置。"
                    + "请引导其到「主页 → 备考设置」填写省份、届别、专业类型与考试科目；"
                    + "在此之前不要猜测或编造其报考省份、届别、科目或目标院校。";

    private final UserFeignClient userFeignClient;

    public String build(Long userId) {
        UserExamPreferenceVO pref = fetchPreference();
        if (pref == null || !isConfigured(pref)) {
            return UNCONFIGURED;
        }
        List<UserTargetVO> targets = fetchTargets();
        StringBuilder sb = new StringBuilder();
        sb.append("【考生备考档案·已配置】\n");
        sb.append("省份：").append(trim(pref.getProvince())).append('\n');
        sb.append("届别：").append(pref.getCohortYear()).append('\n');
        sb.append("专业类型：").append(trim(pref.getMajorCategory())).append('\n');
        sb.append("考试科目：").append(joinSubjects(pref.getSubjectSelection())).append('\n');
        sb.append("目标院校：").append(joinTargets(targets)).append('\n');
        sb.append("回答时默认按此档案，勿再追问省份/届别/已选科目；档案未覆盖的信息再询问。");
        return sb.toString();
    }

    private UserExamPreferenceVO fetchPreference() {
        try {
            Result<UserExamPreferenceVO> result = userFeignClient.getExamPreference();
            if (result == null || result.getCode() != ErrorCode.SUCCESS.getCode()) {
                return null;
            }
            return result.getData();
        } catch (Exception e) {
            log.warn("Feign getExamPreference failed: {}", e.getMessage());
            return null;
        }
    }

    private List<UserTargetVO> fetchTargets() {
        try {
            Result<List<UserTargetVO>> result = userFeignClient.listTargets();
            if (result == null || result.getCode() != ErrorCode.SUCCESS.getCode() || result.getData() == null) {
                return Collections.emptyList();
            }
            return result.getData();
        } catch (Exception e) {
            log.warn("Feign listTargets failed: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    private static boolean isConfigured(UserExamPreferenceVO pref) {
        if (StrUtil.isBlank(pref.getProvince()) || pref.getCohortYear() == null
                || StrUtil.isBlank(pref.getMajorCategory())) {
            return false;
        }
        return !joinSubjects(pref.getSubjectSelection()).equals("（未选）");
    }

    private static String joinSubjects(ExamSubjectSelectionDTO sel) {
        if (sel == null) {
            return "（未选）";
        }
        List<String> all = new ArrayList<>();
        addAll(all, sel.getPublicSubjects());
        addAll(all, sel.getFoundation());
        addAll(all, sel.getComprehensive());
        if (all.isEmpty()) {
            return "（未选）";
        }
        return String.join("、", all);
    }

    private static void addAll(List<String> dest, List<String> src) {
        if (src == null) {
            return;
        }
        for (String s : src) {
            if (StrUtil.isNotBlank(s)) {
                dest.add(s.trim());
            }
        }
    }

    private static String joinTargets(List<UserTargetVO> targets) {
        if (targets == null || targets.isEmpty()) {
            return "（未设置）";
        }
        return targets.stream()
                .limit(3)
                .map(t -> {
                    String school = trim(t.getSchoolName());
                    if (StrUtil.isBlank(school)) {
                        return null;
                    }
                    if (StrUtil.isNotBlank(t.getMajorName())) {
                        return school + "·" + t.getMajorName().trim();
                    }
                    return school;
                })
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.collectingAndThen(
                        Collectors.joining("；"),
                        s -> StrUtil.isBlank(s) ? "（未设置）" : s));
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
