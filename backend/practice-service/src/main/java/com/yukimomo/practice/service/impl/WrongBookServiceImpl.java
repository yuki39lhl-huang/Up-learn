package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.dto.AddWrongBookDTO;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.entity.WrongQuestion;
import com.yukimomo.practice.mapper.WrongQuestionMapper;
import com.yukimomo.practice.service.WrongBookService;
import com.yukimomo.practice.support.QuestionSupport;
import com.yukimomo.practice.vo.WrongQuestionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 错题本业务：仅响应用户手动「加入错题本」，同一题不可重复加入。
 */
@Service
@RequiredArgsConstructor
public class WrongBookServiceImpl implements WrongBookService {

    private final WrongQuestionMapper wrongQuestionMapper;
    private final QuestionSupport questionSupport;

    @Override
    @Transactional(readOnly = true)
    public PageDTO<WrongQuestionVO> list(PageQuery query, String date, String subject) {
        Long userId = UserContext.requireUserId();
        LambdaQueryWrapper<WrongQuestion> wrapper = new LambdaQueryWrapper<WrongQuestion>()
                .eq(WrongQuestion::getUserId, userId);
        if (StrUtil.isNotBlank(date)) {
            LocalDate day = LocalDate.parse(date.trim());
            wrapper.ge(WrongQuestion::getLastWrongAt, day.atStartOfDay())
                    .lt(WrongQuestion::getLastWrongAt, day.plusDays(1).atStartOfDay());
        }
        if (!applySubjectFilter(wrapper, subject)) {
            return PageDTO.empty();
        }

        Page<WrongQuestion> page = wrongQuestionMapper.selectPage(
                query.toMpPage("last_wrong_at", false),
                wrapper
        );
        if (page.getRecords() == null || page.getRecords().isEmpty()) {
            return PageDTO.empty();
        }

        Map<Long, Question> questionMap = questionSupport.loadByIds(
                page.getRecords().stream().map(WrongQuestion::getQuestionId).collect(Collectors.toSet())
        );

        List<WrongQuestionVO> list = page.getRecords().stream()
                .map(w -> toVo(w, questionMap.get(w.getQuestionId())))
                .toList();

        PageDTO<WrongQuestionVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WrongQuestionVO add(AddWrongBookDTO dto) {
        Long userId = UserContext.requireUserId();
        Question question = requireQuestion(dto.getQuestionId());
        if (exists(userId, question.getId())) {
            throw new BadRequestException("该题已在错题本中");
        }

        String userAnswer = dto.getUserAnswer().trim().toUpperCase();
        LocalDateTime now = LocalDateTime.now();

        WrongQuestion row = new WrongQuestion();
        row.setUserId(userId);
        row.setQuestionId(question.getId());
        row.setUserAnswer(userAnswer);
        row.setAnalysisSnapshot(question.getAnalysis());
        row.setWrongCount(1);
        row.setLastWrongAt(now);
        wrongQuestionMapper.insert(row);
        return toVo(row, question);
    }

    @Override
    @Transactional(readOnly = true)
    public WrongQuestionVO get(Long id) {
        Long userId = UserContext.requireUserId();
        WrongQuestion row = requireOwnedRow(userId, id);
        Question question = requireQuestion(row.getQuestionId());
        return toVo(row, question);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        Long userId = UserContext.requireUserId();
        WrongQuestion row = requireOwnedRow(userId, id);
        wrongQuestionMapper.deleteById(row.getId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteAll(String date, String subject) {
        Long userId = UserContext.requireUserId();
        LambdaQueryWrapper<WrongQuestion> wrapper = new LambdaQueryWrapper<WrongQuestion>()
                .eq(WrongQuestion::getUserId, userId);
        if (StrUtil.isNotBlank(date)) {
            LocalDate day = LocalDate.parse(date.trim());
            wrapper.ge(WrongQuestion::getLastWrongAt, day.atStartOfDay())
                    .lt(WrongQuestion::getLastWrongAt, day.plusDays(1).atStartOfDay());
        }
        if (!applySubjectFilter(wrapper, subject)) {
            return 0;
        }
        return wrongQuestionMapper.delete(wrapper);
    }

    private boolean applySubjectFilter(LambdaQueryWrapper<WrongQuestion> wrapper, String subject) {
        if (StrUtil.isBlank(subject)) {
            return true;
        }
        List<Long> questionIds = questionSupport.questionIdsByBankSubject(subject);
        if (questionIds.isEmpty()) {
            return false;
        }
        wrapper.in(WrongQuestion::getQuestionId, questionIds);
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean exists(Long userId, Long questionId) {
        return wrongQuestionMapper.selectCount(
                new LambdaQueryWrapper<WrongQuestion>()
                        .eq(WrongQuestion::getUserId, userId)
                        .eq(WrongQuestion::getQuestionId, questionId)
        ) > 0;
    }

    private WrongQuestion requireOwnedRow(Long userId, Long id) {
        WrongQuestion row = wrongQuestionMapper.selectById(id);
        if (row == null || !Objects.equals(row.getUserId(), userId)) {
            throw new BadRequestException("错题记录不存在");
        }
        return row;
    }

    private Question requireQuestion(Long questionId) {
        Map<Long, Question> map = questionSupport.loadByIds(java.util.Set.of(questionId));
        Question question = map.get(questionId);
        if (question == null) {
            throw new BadRequestException("题目不存在");
        }
        return question;
    }

    private WrongQuestionVO toVo(WrongQuestion w, Question q) {
        WrongQuestionVO vo = new WrongQuestionVO();
        vo.setId(w.getId());
        vo.setQuestionId(w.getQuestionId());
        vo.setWrongCount(w.getWrongCount());
        vo.setLastWrongAt(w.getLastWrongAt());
        vo.setCreatedAt(w.getCreatedAt());
        vo.setUserAnswer(w.getUserAnswer());
        vo.setAnalysis(w.getAnalysisSnapshot());
        if (q != null) {
            vo.setSubject(q.getSubject());
            vo.setStem(q.getStem());
            vo.setOptions(questionSupport.parseOptions(q.getOptionsJson()));
            vo.setDifficulty(q.getDifficulty());
            vo.setAnswer(q.getAnswer());
            if (StrUtil.isBlank(vo.getAnalysis())) {
                vo.setAnalysis(q.getAnalysis());
            }
        }
        return vo;
    }
}
