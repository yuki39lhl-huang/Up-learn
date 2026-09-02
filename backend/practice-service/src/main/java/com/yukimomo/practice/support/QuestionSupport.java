package com.yukimomo.practice.support;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.mapper.QuestionMapper;
import com.yukimomo.practice.vo.QuestionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 题目查询与 VO 转换的共用能力，供错题本、备忘录、刷题等模块复用，避免 Service 间循环依赖。
 */
@Component
@RequiredArgsConstructor
public class QuestionSupport {

    private final QuestionMapper questionMapper;

    /** 按 ID 批量查题，返回 id → Question 映射。 */
    public Map<Long, Question> loadByIds(Set<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyMap();
        }
        return questionMapper.selectList(new LambdaQueryWrapper<Question>().in(Question::getId, ids))
                .stream()
                .collect(Collectors.toMap(Question::getId, Function.identity(), (a, b) -> a));
    }

    /** 按题库科目列表查题目 ID。 */
    public List<Long> questionIdsBySubjects(List<String> subjects) {
        if (subjects == null || subjects.isEmpty()) {
            return Collections.emptyList();
        }
        return questionMapper.selectList(
                new LambdaQueryWrapper<Question>()
                        .in(Question::getSubject, subjects)
                        .select(Question::getId)
        ).stream().map(Question::getId).toList();
    }

    /** 单个题库科目 → 题目 ID；科目为空表示不限。 */
    public List<Long> questionIdsByBankSubject(String subject) {
        if (StrUtil.isBlank(subject)) {
            return Collections.emptyList();
        }
        return questionIdsBySubjects(List.of(subject.trim()));
    }

    /** 出题 VO：不含答案与解析。 */
    public QuestionVO toQuestionVo(Question q) {
        QuestionVO vo = new QuestionVO();
        vo.setId(q.getId());
        vo.setSubject(q.getSubject());
        vo.setStem(q.getStem());
        vo.setOptions(parseOptions(q.getOptionsJson()));
        vo.setDifficulty(q.getDifficulty());
        return vo;
    }

    public List<String> parseOptions(String optionsJson) {
        if (StrUtil.isBlank(optionsJson)) {
            return Collections.emptyList();
        }
        return JSONUtil.toList(optionsJson, String.class);
    }
}
