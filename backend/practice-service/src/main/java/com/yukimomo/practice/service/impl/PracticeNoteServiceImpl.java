package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.dto.AddPracticeNoteDTO;
import com.yukimomo.practice.entity.PracticeNote;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.mapper.PracticeNoteMapper;
import com.yukimomo.practice.service.PracticeNoteService;
import com.yukimomo.practice.support.QuestionSupport;
import com.yukimomo.practice.vo.PracticeNoteVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 备忘录业务：答对后手动收藏，同一题不可重复添加。
 */
@Service
@RequiredArgsConstructor
public class PracticeNoteServiceImpl implements PracticeNoteService {

    private final PracticeNoteMapper practiceNoteMapper;
    private final QuestionSupport questionSupport;

    @Override
    @Transactional(readOnly = true)
    public PageDTO<PracticeNoteVO> list(PageQuery query, String date, String subject) {
        Long userId = UserContext.requireUserId();
        LambdaQueryWrapper<PracticeNote> wrapper = new LambdaQueryWrapper<PracticeNote>()
                .eq(PracticeNote::getUserId, userId);
        if (StrUtil.isNotBlank(date)) {
            LocalDate day = LocalDate.parse(date.trim());
            wrapper.ge(PracticeNote::getCreatedAt, day.atStartOfDay())
                    .lt(PracticeNote::getCreatedAt, day.plusDays(1).atStartOfDay());
        }
        if (!applySubjectFilter(wrapper, subject)) {
            return PageDTO.empty();
        }

        Page<PracticeNote> page = practiceNoteMapper.selectPage(
                query.toMpPage("created_at", false),
                wrapper
        );
        if (page.getRecords() == null || page.getRecords().isEmpty()) {
            return PageDTO.empty();
        }

        Map<Long, Question> questionMap = questionSupport.loadByIds(
                page.getRecords().stream().map(PracticeNote::getQuestionId).collect(Collectors.toSet())
        );

        List<PracticeNoteVO> list = page.getRecords().stream()
                .map(note -> toVo(note, questionMap.get(note.getQuestionId())))
                .toList();

        PageDTO<PracticeNoteVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PracticeNoteVO add(AddPracticeNoteDTO dto) {
        Long userId = UserContext.requireUserId();
        Question question = requireQuestion(dto.getQuestionId());
        if (exists(userId, question.getId())) {
            throw new BadRequestException("该题已在备忘录中");
        }

        PracticeNote note = new PracticeNote();
        note.setUserId(userId);
        note.setQuestionId(question.getId());
        note.setStem(question.getStem());
        note.setAnalysis(question.getAnalysis());
        note.setUserNote(StrUtil.trim(dto.getUserNote()));
        practiceNoteMapper.insert(note);
        return toVo(note, question);
    }

    @Override
    @Transactional(readOnly = true)
    public PracticeNoteVO get(Long id) {
        Long userId = UserContext.requireUserId();
        PracticeNote note = requireOwnedNote(userId, id);
        Question question = requireQuestion(note.getQuestionId());
        return toVo(note, question);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        Long userId = UserContext.requireUserId();
        PracticeNote note = requireOwnedNote(userId, id);
        practiceNoteMapper.deleteById(note.getId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteAll(String date, String subject) {
        Long userId = UserContext.requireUserId();
        LambdaQueryWrapper<PracticeNote> wrapper = new LambdaQueryWrapper<PracticeNote>()
                .eq(PracticeNote::getUserId, userId);
        if (StrUtil.isNotBlank(date)) {
            LocalDate day = LocalDate.parse(date.trim());
            wrapper.ge(PracticeNote::getCreatedAt, day.atStartOfDay())
                    .lt(PracticeNote::getCreatedAt, day.plusDays(1).atStartOfDay());
        }
        if (!applySubjectFilter(wrapper, subject)) {
            return 0;
        }
        return practiceNoteMapper.delete(wrapper);
    }

    private boolean applySubjectFilter(LambdaQueryWrapper<PracticeNote> wrapper, String subject) {
        if (StrUtil.isBlank(subject)) {
            return true;
        }
        List<Long> questionIds = questionSupport.questionIdsByBankSubject(subject);
        if (questionIds.isEmpty()) {
            return false;
        }
        wrapper.in(PracticeNote::getQuestionId, questionIds);
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean exists(Long userId, Long questionId) {
        return practiceNoteMapper.selectCount(
                new LambdaQueryWrapper<PracticeNote>()
                        .eq(PracticeNote::getUserId, userId)
                        .eq(PracticeNote::getQuestionId, questionId)
        ) > 0;
    }

    private PracticeNote requireOwnedNote(Long userId, Long id) {
        PracticeNote note = practiceNoteMapper.selectById(id);
        if (note == null || !Objects.equals(note.getUserId(), userId)) {
            throw new BadRequestException("备忘录不存在");
        }
        return note;
    }

    private Question requireQuestion(Long questionId) {
        Map<Long, Question> map = questionSupport.loadByIds(java.util.Set.of(questionId));
        Question question = map.get(questionId);
        if (question == null) {
            throw new BadRequestException("题目不存在");
        }
        return question;
    }

    private PracticeNoteVO toVo(PracticeNote note, Question q) {
        PracticeNoteVO vo = new PracticeNoteVO();
        vo.setId(note.getId());
        vo.setQuestionId(note.getQuestionId());
        vo.setStem(note.getStem());
        vo.setAnalysis(note.getAnalysis());
        vo.setUserNote(note.getUserNote());
        vo.setCreatedAt(note.getCreatedAt());
        if (q != null) {
            vo.setSubject(q.getSubject());
            vo.setOptions(questionSupport.parseOptions(q.getOptionsJson()));
            vo.setAnswer(q.getAnswer());
            if (StrUtil.isBlank(vo.getStem())) {
                vo.setStem(q.getStem());
            }
            if (StrUtil.isBlank(vo.getAnalysis())) {
                vo.setAnalysis(q.getAnalysis());
            }
        }
        return vo;
    }
}
