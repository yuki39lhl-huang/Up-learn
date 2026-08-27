package com.yukimomo.school.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.school.entity.ExamSubject;
import com.yukimomo.school.entity.ExamSubjectRule;
import com.yukimomo.school.mapper.ExamSubjectMapper;
import com.yukimomo.school.mapper.ExamSubjectRuleMapper;
import com.yukimomo.school.service.ExamSubjectService;
import com.yukimomo.school.vo.ExamSubjectGroupVO;
import com.yukimomo.school.vo.ExamSubjectOptionsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 备考考试科目规则查询服务实现。
 */
@Service
@RequiredArgsConstructor
public class ExamSubjectServiceImpl implements ExamSubjectService {

    private static final String PUBLIC = "PUBLIC";
    private static final String FOUNDATION = "FOUNDATION";
    private static final String COMPREHENSIVE = "COMPREHENSIVE";

    private final ExamSubjectMapper examSubjectMapper;
    private final ExamSubjectRuleMapper examSubjectRuleMapper;

    @Override
    public ExamSubjectOptionsVO getOptions(String province, String majorCategory) {
        if (!StringUtils.hasText(province)) {
            throw new BadRequestException("省份不能为空");
        }

        String normalizedProvince = province.trim();
        String normalizedCategory = StringUtils.hasText(majorCategory) ? majorCategory.trim() : null;
        LambdaQueryWrapper<ExamSubjectRule> wrapper = new LambdaQueryWrapper<ExamSubjectRule>()
                .eq(ExamSubjectRule::getProvince, normalizedProvince)
                .eq(ExamSubjectRule::getEnabled, 1)
                .isNull(ExamSubjectRule::getYear);
        if (normalizedCategory == null) {
            wrapper.isNull(ExamSubjectRule::getMajorCategory);
        } else {
            wrapper.and(query -> query.isNull(ExamSubjectRule::getMajorCategory)
                    .or()
                    .eq(ExamSubjectRule::getMajorCategory, normalizedCategory));
        }

        List<ExamSubjectRule> rules = examSubjectRuleMapper.selectList(wrapper);
        Set<Long> subjectIds = rules.stream()
                .map(ExamSubjectRule::getSubjectId)
                .collect(Collectors.toSet());
        Map<Long, ExamSubject> subjects = subjectIds.isEmpty()
                ? Map.of()
                : examSubjectMapper.selectByIds(subjectIds).stream()
                .filter(subject -> Integer.valueOf(1).equals(subject.getEnabled()))
                .collect(Collectors.toMap(ExamSubject::getId, Function.identity()));

        List<RuleSubject> items = rules.stream()
                .map(rule -> new RuleSubject(rule, subjects.get(rule.getSubjectId())))
                .filter(item -> item.subject() != null)
                .sorted(Comparator
                        .comparing((RuleSubject item) -> isSpecific(item.rule(), normalizedCategory))
                        .reversed()
                        .thenComparing(item -> item.rule().getSortOrder(), Comparator.nullsLast(Integer::compareTo))
                        .thenComparing(item -> item.subject().getName()))
                .toList();

        ExamSubjectOptionsVO result = new ExamSubjectOptionsVO();
        result.setProvince(normalizedProvince);
        result.setMajorCategory(normalizedCategory);
        result.setPublicSubjects(buildGroup(items, PUBLIC, normalizedCategory));
        result.setFoundation(buildGroup(items, FOUNDATION, normalizedCategory));
        result.setComprehensive(buildGroup(items, COMPREHENSIVE, normalizedCategory));
        return result;
    }

    private ExamSubjectGroupVO buildGroup(
            List<RuleSubject> items,
            String subjectType,
            String majorCategory
    ) {
        List<RuleSubject> group = items.stream()
                .filter(item -> subjectType.equals(item.subject().getSubjectType()))
                .toList();

        LinkedHashSet<String> options = group.stream()
                .map(item -> item.subject().getName())
                .collect(Collectors.toCollection(LinkedHashSet::new));

        List<RuleSubject> specificDefaults = group.stream()
                .filter(item -> isSpecific(item.rule(), majorCategory))
                .filter(item -> Integer.valueOf(1).equals(item.rule().getDefaultFlag()))
                .toList();
        List<RuleSubject> defaults = specificDefaults.isEmpty()
                ? group.stream()
                .filter(item -> item.rule().getMajorCategory() == null)
                .filter(item -> Integer.valueOf(1).equals(item.rule().getDefaultFlag()))
                .toList()
                : specificDefaults;

        ExamSubjectGroupVO result = new ExamSubjectGroupVO();
        result.setOptions(new ArrayList<>(options));
        result.setDefaults(defaults.stream()
                .map(item -> item.subject().getName())
                .distinct()
                .toList());
        return result;
    }

    private boolean isSpecific(ExamSubjectRule rule, String majorCategory) {
        return majorCategory != null && majorCategory.equals(rule.getMajorCategory());
    }

    private record RuleSubject(ExamSubjectRule rule, ExamSubject subject) {
    }
}
