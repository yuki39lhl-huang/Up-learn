package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.config.PapersLocalProperties;
import com.yukimomo.practice.constant.PaperConstants;
import com.yukimomo.practice.dto.PaperSaveAnswersDTO;
import com.yukimomo.practice.entity.Paper;
import com.yukimomo.practice.entity.PaperAttempt;
import com.yukimomo.practice.entity.PaperAttemptAnswer;
import com.yukimomo.practice.entity.PaperQuestion;
import com.yukimomo.practice.mapper.PaperAttemptAnswerMapper;
import com.yukimomo.practice.mapper.PaperAttemptMapper;
import com.yukimomo.practice.mapper.PaperMapper;
import com.yukimomo.practice.mapper.PaperQuestionMapper;
import com.yukimomo.practice.service.PaperService;
import com.yukimomo.practice.service.PracticeOssService;
import com.yukimomo.practice.vo.PaperDetailVO;
import com.yukimomo.practice.vo.PaperListItemVO;
import com.yukimomo.practice.vo.PaperOptionItemVO;
import com.yukimomo.practice.vo.PaperOptionsVO;
import com.yukimomo.practice.vo.PaperPdfVO;
import com.yukimomo.practice.vo.PaperQuestionVO;
import com.yukimomo.practice.vo.PaperStartVO;
import com.yukimomo.practice.vo.PaperSubmitResultVO;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PaperServiceImpl implements PaperService {

    private final PaperMapper paperMapper;
    private final PaperQuestionMapper paperQuestionMapper;
    private final PaperAttemptMapper paperAttemptMapper;
    private final PaperAttemptAnswerMapper paperAttemptAnswerMapper;
    private final PracticeOssService practiceOssService;
    private final PapersLocalProperties papersLocalProperties;

    @Override
    public PaperOptionsVO options() {
        List<Paper> papers = paperMapper.selectList(new LambdaQueryWrapper<Paper>()
                .eq(Paper::getPublished, 1)
                .orderByAsc(Paper::getProvince)
                .orderByAsc(Paper::getSubject));
        Set<String> provinces = new LinkedHashSet<>();
        Map<String, PaperOptionItemVO> uniq = new HashMap<>();
        for (Paper p : papers) {
            provinces.add(p.getProvince());
            String key = p.getProvince() + "|" + p.getSubject();
            uniq.computeIfAbsent(key, k -> {
                PaperOptionItemVO item = new PaperOptionItemVO();
                item.setProvince(p.getProvince());
                item.setSubject(p.getSubject());
                return item;
            });
        }
        PaperOptionsVO vo = new PaperOptionsVO();
        vo.setProvinces(new ArrayList<>(provinces));
        vo.setItems(new ArrayList<>(uniq.values()));
        return vo;
    }

    @Override
    public List<PaperListItemVO> list(String province, String subject) {
        if (StrUtil.isBlank(province) || StrUtil.isBlank(subject)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "province 与 subject 必填");
        }
        List<Paper> papers = paperMapper.selectList(new LambdaQueryWrapper<Paper>()
                .eq(Paper::getPublished, 1)
                .eq(Paper::getProvince, province.trim())
                .eq(Paper::getSubject, subject.trim())
                .orderByDesc(Paper::getYear));
        List<PaperListItemVO> result = new ArrayList<>();
        for (Paper p : papers) {
            PaperListItemVO item = new PaperListItemVO();
            item.setId(p.getId());
            item.setProvince(p.getProvince());
            item.setSubject(p.getSubject());
            item.setYear(p.getYear());
            item.setTitle(p.getTitle());
            item.setHasAnswer(Objects.equals(p.getHasAnswer(), 1));
            item.setPdfAvailable(StrUtil.isNotBlank(p.getPdfUrl()) && resolvePdfExists(p));
            Long count = paperQuestionMapper.selectCount(new LambdaQueryWrapper<PaperQuestion>()
                    .eq(PaperQuestion::getPaperId, p.getId()));
            item.setQuestionCount(count == null ? 0 : count.intValue());
            result.add(item);
        }
        return result;
    }

    @Override
    public PaperDetailVO detail(Long paperId) {
        Long userId = UserContext.requireUserId();
        Paper paper = requirePublishedPaper(paperId);
        List<PaperQuestion> questions = listQuestions(paperId);

        PaperAttempt attempt = paperAttemptMapper.selectOne(new LambdaQueryWrapper<PaperAttempt>()
                .eq(PaperAttempt::getUserId, userId)
                .eq(PaperAttempt::getPaperId, paperId)
                .eq(PaperAttempt::getStatus, PaperConstants.ATTEMPT_IN_PROGRESS)
                .orderByDesc(PaperAttempt::getId)
                .last("LIMIT 1"));
        if (attempt == null) {
            attempt = paperAttemptMapper.selectOne(new LambdaQueryWrapper<PaperAttempt>()
                    .eq(PaperAttempt::getUserId, userId)
                    .eq(PaperAttempt::getPaperId, paperId)
                    .eq(PaperAttempt::getStatus, PaperConstants.ATTEMPT_SUBMITTED)
                    .orderByDesc(PaperAttempt::getId)
                    .last("LIMIT 1"));
        }

        Map<Long, PaperAttemptAnswer> answerMap = Map.of();
        boolean reveal = attempt != null
                && PaperConstants.ATTEMPT_SUBMITTED.equals(attempt.getStatus());
        if (attempt != null) {
            List<PaperAttemptAnswer> answers = paperAttemptAnswerMapper.selectList(
                    new LambdaQueryWrapper<PaperAttemptAnswer>()
                            .eq(PaperAttemptAnswer::getAttemptId, attempt.getId()));
            answerMap = answers.stream()
                    .collect(Collectors.toMap(PaperAttemptAnswer::getPaperQuestionId, a -> a, (a, b) -> a));
        }

        PaperDetailVO vo = baseDetail(paper);
        if (attempt != null) {
            vo.setAttemptId(attempt.getId());
            vo.setAttemptStatus(attempt.getStatus());
        }
        List<PaperQuestionVO> qvos = new ArrayList<>();
        for (PaperQuestion q : questions) {
            qvos.add(toQuestionVo(q, answerMap.get(q.getId()), reveal));
        }
        vo.setQuestions(qvos);
        return vo;
    }

    @Override
    public PaperPdfVO pdfMeta(Long paperId) {
        Paper paper = requirePublishedPaper(paperId);
        if (StrUtil.isBlank(paper.getPdfUrl())) {
            throw new BizException(ErrorCode.NOT_FOUND, "该试卷暂无 PDF");
        }
        PaperPdfVO vo = new PaperPdfVO();
        vo.setFileName(buildFileName(paper));
        String stored = paper.getPdfUrl();
        if (stored.startsWith("http://") || stored.startsWith("https://")) {
            vo.setUrl(practiceOssService.toDisplayUrl(stored));
        } else {
            // 前端走同源流式下载接口
            vo.setUrl("/api/practice/papers/" + paperId + "/pdf/content");
        }
        return vo;
    }

    @Override
    public Resource pdfContent(Long paperId) {
        Paper paper = requirePublishedPaper(paperId);
        Path path = resolveLocalPdf(paper);
        if (path == null || !Files.isRegularFile(path)) {
            throw new BizException(ErrorCode.NOT_FOUND, "PDF 文件不存在");
        }
        return new FileSystemResource(path);
    }

    @Override
    public String pdfFileName(Long paperId) {
        return buildFileName(requirePublishedPaper(paperId));
    }

    @Override
    @Transactional
    public PaperStartVO start(Long paperId) {
        Long userId = UserContext.requireUserId();
        requirePublishedPaper(paperId);
        PaperAttempt existing = paperAttemptMapper.selectOne(new LambdaQueryWrapper<PaperAttempt>()
                .eq(PaperAttempt::getUserId, userId)
                .eq(PaperAttempt::getPaperId, paperId)
                .eq(PaperAttempt::getStatus, PaperConstants.ATTEMPT_IN_PROGRESS)
                .orderByDesc(PaperAttempt::getId)
                .last("LIMIT 1"));
        if (existing != null) {
            PaperStartVO vo = new PaperStartVO();
            vo.setAttemptId(existing.getId());
            vo.setPaperId(paperId);
            vo.setStatus(existing.getStatus());
            return vo;
        }
        PaperAttempt attempt = new PaperAttempt();
        attempt.setUserId(userId);
        attempt.setPaperId(paperId);
        attempt.setStatus(PaperConstants.ATTEMPT_IN_PROGRESS);
        paperAttemptMapper.insert(attempt);
        PaperStartVO vo = new PaperStartVO();
        vo.setAttemptId(attempt.getId());
        vo.setPaperId(paperId);
        vo.setStatus(attempt.getStatus());
        return vo;
    }

    @Override
    @Transactional
    public void saveAnswers(Long attemptId, PaperSaveAnswersDTO dto) {
        Long userId = UserContext.requireUserId();
        PaperAttempt attempt = requireOwnedAttempt(attemptId, userId);
        if (PaperConstants.ATTEMPT_SUBMITTED.equals(attempt.getStatus())) {
            throw new BizException(ErrorCode.PAPER_ALREADY_SUBMITTED);
        }
        Map<Long, PaperQuestion> qMap = listQuestions(attempt.getPaperId()).stream()
                .collect(Collectors.toMap(PaperQuestion::getId, q -> q, (a, b) -> a));
        for (PaperSaveAnswersDTO.Item item : dto.getAnswers()) {
            PaperQuestion q = qMap.get(item.getQuestionId());
            if (q == null) {
                throw new BizException(ErrorCode.BAD_REQUEST, "题目不属于本卷");
            }
            // 材料题无作答；其余题型（含 reveal_only 主观题）均可保存机打草稿
            if (PaperConstants.Q_MATERIAL.equals(q.getQType())) {
                continue;
            }
            PaperAttemptAnswer row = paperAttemptAnswerMapper.selectOne(
                    new LambdaQueryWrapper<PaperAttemptAnswer>()
                            .eq(PaperAttemptAnswer::getAttemptId, attemptId)
                            .eq(PaperAttemptAnswer::getPaperQuestionId, item.getQuestionId()));
            String ans = StrUtil.trim(item.getUserAnswer());
            if (row == null) {
                row = new PaperAttemptAnswer();
                row.setAttemptId(attemptId);
                row.setPaperQuestionId(item.getQuestionId());
                row.setUserAnswer(ans);
                paperAttemptAnswerMapper.insert(row);
            } else {
                row.setUserAnswer(ans);
                paperAttemptAnswerMapper.updateById(row);
            }
        }
    }

    @Override
    @Transactional
    public PaperSubmitResultVO submit(Long attemptId) {
        Long userId = UserContext.requireUserId();
        PaperAttempt attempt = requireOwnedAttempt(attemptId, userId);
        if (PaperConstants.ATTEMPT_SUBMITTED.equals(attempt.getStatus())) {
            return buildSubmitResult(attempt);
        }
        List<PaperQuestion> questions = listQuestions(attempt.getPaperId());
        Map<Long, PaperAttemptAnswer> answerMap = paperAttemptAnswerMapper.selectList(
                        new LambdaQueryWrapper<PaperAttemptAnswer>()
                                .eq(PaperAttemptAnswer::getAttemptId, attemptId))
                .stream()
                .collect(Collectors.toMap(PaperAttemptAnswer::getPaperQuestionId, a -> a, (a, b) -> a));

        int objectiveScore = 0;
        int objectiveTotal = 0;
        for (PaperQuestion q : questions) {
            // 仅选择题自动判分；填空/写作等机打内容交卷后揭晓参考答案供自批
            if (!PaperConstants.Q_CHOICE.equals(q.getQType())) {
                continue;
            }
            if (!PaperConstants.INPUT_ANSWERABLE.equals(q.getInputMode())) {
                continue;
            }
            int score = q.getScore() == null ? 0 : q.getScore();
            objectiveTotal += score;
            PaperAttemptAnswer row = answerMap.get(q.getId());
            boolean correct = row != null
                    && StrUtil.isNotBlank(row.getUserAnswer())
                    && StrUtil.isNotBlank(q.getAnswer())
                    && normalizeChoice(row.getUserAnswer()).equalsIgnoreCase(normalizeChoice(q.getAnswer()));
            if (row == null) {
                row = new PaperAttemptAnswer();
                row.setAttemptId(attemptId);
                row.setPaperQuestionId(q.getId());
                row.setCorrect(correct ? 1 : 0);
                paperAttemptAnswerMapper.insert(row);
            } else {
                row.setCorrect(correct ? 1 : 0);
                paperAttemptAnswerMapper.updateById(row);
            }
            if (correct) {
                objectiveScore += score;
            }
        }

        attempt.setStatus(PaperConstants.ATTEMPT_SUBMITTED);
        attempt.setObjectiveScore(objectiveScore);
        attempt.setObjectiveTotal(objectiveTotal);
        attempt.setSubmittedAt(LocalDateTime.now());
        paperAttemptMapper.updateById(attempt);
        return buildSubmitResult(attempt);
    }

    private PaperSubmitResultVO buildSubmitResult(PaperAttempt attempt) {
        Paper paper = requirePublishedPaper(attempt.getPaperId());
        List<PaperQuestion> questions = listQuestions(paper.getId());
        Map<Long, PaperAttemptAnswer> answerMap = paperAttemptAnswerMapper.selectList(
                        new LambdaQueryWrapper<PaperAttemptAnswer>()
                                .eq(PaperAttemptAnswer::getAttemptId, attempt.getId()))
                .stream()
                .collect(Collectors.toMap(PaperAttemptAnswer::getPaperQuestionId, a -> a, (a, b) -> a));
        PaperSubmitResultVO vo = new PaperSubmitResultVO();
        vo.setAttemptId(attempt.getId());
        vo.setPaperId(paper.getId());
        vo.setObjectiveScore(attempt.getObjectiveScore());
        vo.setObjectiveTotal(attempt.getObjectiveTotal());
        List<PaperQuestionVO> qvos = new ArrayList<>();
        for (PaperQuestion q : questions) {
            qvos.add(toQuestionVo(q, answerMap.get(q.getId()), true));
        }
        vo.setQuestions(qvos);
        return vo;
    }

    private PaperDetailVO baseDetail(Paper paper) {
        PaperDetailVO vo = new PaperDetailVO();
        vo.setId(paper.getId());
        vo.setProvince(paper.getProvince());
        vo.setSubject(paper.getSubject());
        vo.setYear(paper.getYear());
        vo.setTitle(paper.getTitle());
        vo.setHasAnswer(Objects.equals(paper.getHasAnswer(), 1));
        vo.setPdfAvailable(StrUtil.isNotBlank(paper.getPdfUrl()) && resolvePdfExists(paper));
        return vo;
    }

    private PaperQuestionVO toQuestionVo(PaperQuestion q, PaperAttemptAnswer ans, boolean reveal) {
        PaperQuestionVO vo = new PaperQuestionVO();
        vo.setId(q.getId());
        vo.setSeq(q.getSeq());
        vo.setQType(q.getQType());
        vo.setStem(q.getStem());
        vo.setScore(q.getScore());
        vo.setInputMode(q.getInputMode());
        if (StrUtil.isNotBlank(q.getOptionsJson())) {
            vo.setOptions(JSONUtil.toList(q.getOptionsJson(), String.class));
        }
        if (ans != null) {
            vo.setUserAnswer(ans.getUserAnswer());
            if (ans.getCorrect() != null) {
                vo.setCorrect(ans.getCorrect() == 1);
            }
        }
        if (reveal) {
            if (StrUtil.isNotBlank(q.getAnswer())) {
                vo.setAnswer(q.getAnswer());
            } else {
                vo.setAnswer(null);
            }
            vo.setAnalysis(q.getAnalysis());
        }
        return vo;
    }

    private Paper requirePublishedPaper(Long paperId) {
        Paper paper = paperMapper.selectById(paperId);
        if (paper == null || !Objects.equals(paper.getPublished(), 1)) {
            throw new BizException(ErrorCode.PAPER_NOT_FOUND);
        }
        return paper;
    }

    private PaperAttempt requireOwnedAttempt(Long attemptId, Long userId) {
        PaperAttempt attempt = paperAttemptMapper.selectById(attemptId);
        if (attempt == null || !Objects.equals(attempt.getUserId(), userId)) {
            throw new BizException(ErrorCode.PAPER_ATTEMPT_NOT_FOUND);
        }
        return attempt;
    }

    private List<PaperQuestion> listQuestions(Long paperId) {
        return paperQuestionMapper.selectList(new LambdaQueryWrapper<PaperQuestion>()
                .eq(PaperQuestion::getPaperId, paperId)
                .orderByAsc(PaperQuestion::getSeq));
    }

    private static String normalizeChoice(String raw) {
        String s = StrUtil.trim(raw);
        if (s.length() > 1 && (s.startsWith("A") || s.startsWith("B")
                || s.startsWith("C") || s.startsWith("D"))) {
            return s.substring(0, 1);
        }
        return s;
    }

    private String buildFileName(Paper paper) {
        return paper.getYear() + "年" + paper.getProvince() + "专升本" + paper.getSubject() + "真题.pdf";
    }

    private boolean resolvePdfExists(Paper paper) {
        if (StrUtil.isBlank(paper.getPdfUrl())) {
            return false;
        }
        if (paper.getPdfUrl().startsWith("http://") || paper.getPdfUrl().startsWith("https://")) {
            return true;
        }
        Path path = resolveLocalPdf(paper);
        return path != null && Files.isRegularFile(path);
    }

    private Path resolveLocalPdf(Paper paper) {
        if (StrUtil.isBlank(paper.getPdfUrl())) {
            return null;
        }
        if (paper.getPdfUrl().startsWith("http://") || paper.getPdfUrl().startsWith("https://")) {
            return null;
        }
        Path root = Paths.get(papersLocalProperties.getLocalDir()).toAbsolutePath().normalize();
        Path path = root.resolve(paper.getPdfUrl()).normalize();
        if (!path.startsWith(root)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "非法 PDF 路径");
        }
        return path;
    }
}
