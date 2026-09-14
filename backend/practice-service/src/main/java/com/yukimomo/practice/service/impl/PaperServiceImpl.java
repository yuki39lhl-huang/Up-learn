package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.client.AgentScoreClient;
import com.yukimomo.practice.config.PapersLocalProperties;
import com.yukimomo.practice.constant.PaperConstants;
import com.yukimomo.practice.dto.PaperAiScoreDTO;
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
import com.yukimomo.practice.vo.PaperAiScoreResultVO;
import com.yukimomo.practice.vo.PaperDetailVO;
import com.yukimomo.practice.vo.PaperListItemVO;
import com.yukimomo.practice.vo.PaperOptionItemVO;
import com.yukimomo.practice.vo.PaperOptionsVO;
import com.yukimomo.practice.vo.PaperQuestionVO;
import com.yukimomo.practice.vo.PaperStartVO;
import com.yukimomo.practice.vo.PaperSubmitResultVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
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
    private final PapersLocalProperties papersLocalProperties;
    private final AgentScoreClient agentScoreClient;

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
        fillGradableStats(vo, questions);
        if (attempt != null) {
            vo.setAttemptId(attempt.getId());
            vo.setAttemptStatus(attempt.getStatus());
            if (reveal) {
                vo.setObjectiveScore(attempt.getObjectiveScore());
                vo.setObjectiveTotal(attempt.getObjectiveTotal());
            }
        }
        List<PaperQuestionVO> qvos = new ArrayList<>();
        for (PaperQuestion q : questions) {
            qvos.add(toQuestionVo(q, answerMap.get(q.getId()), reveal));
        }
        vo.setQuestions(qvos);
        return vo;
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
            // 回忆版暂缺题不可作答
            if (PaperConstants.INPUT_MISSING.equals(q.getInputMode())) {
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
            // 无标准答案：可作答但不计入可判客观分母
            if (StrUtil.isBlank(q.getAnswer())) {
                PaperAttemptAnswer skipRow = answerMap.get(q.getId());
                if (skipRow != null && skipRow.getCorrect() != null) {
                    skipRow.setCorrect(null);
                    paperAttemptAnswerMapper.updateById(skipRow);
                }
                continue;
            }
            int score = q.getScore() == null ? 0 : q.getScore();
            objectiveTotal += score;
            PaperAttemptAnswer row = answerMap.get(q.getId());
            boolean correct = row != null
                    && StrUtil.isNotBlank(row.getUserAnswer())
                    && normalizeChoice(row.getUserAnswer()).equals(normalizeChoice(q.getAnswer()));
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

    @Override
    public PaperAiScoreResultVO aiScore(Long attemptId, PaperAiScoreDTO dto) {
        Long userId = UserContext.requireUserId();
        if (Boolean.TRUE.equals(dto.getMockExam()) || !papersLocalProperties.isAiScoreEnabled()) {
            throw new BizException(ErrorCode.PAPER_AI_SCORE_DISABLED);
        }
        PaperAttempt attempt = requireOwnedAttempt(attemptId, userId);
        if (!PaperConstants.ATTEMPT_SUBMITTED.equals(attempt.getStatus())) {
            throw new BizException(ErrorCode.PAPER_NOT_SUBMITTED);
        }
        Paper paper = requirePublishedPaper(attempt.getPaperId());
        if (isMathSubject(paper.getSubject())) {
            throw new BizException(ErrorCode.PAPER_AI_SCORE_DISABLED, "高等数学主观题不提供 AI 评分，请对照参考答案自批");
        }

        List<PaperQuestion> questions = listQuestions(paper.getId());
        Map<Long, PaperAttemptAnswer> answerMap = paperAttemptAnswerMapper.selectList(
                        new LambdaQueryWrapper<PaperAttemptAnswer>()
                                .eq(PaperAttemptAnswer::getAttemptId, attemptId))
                .stream()
                .collect(Collectors.toMap(PaperAttemptAnswer::getPaperQuestionId, a -> a, (a, b) -> a));

        Set<Long> filterIds = null;
        if (dto.getQuestionIds() != null && !dto.getQuestionIds().isEmpty()) {
            filterIds = new HashSet<>(dto.getQuestionIds());
        }
        boolean force = Boolean.TRUE.equals(dto.getForce());
        int scored = 0;
        int skipped = 0;

        for (PaperQuestion q : questions) {
            if (filterIds != null && !filterIds.contains(q.getId())) {
                continue;
            }
            if (!isAiScoreEligible(q)) {
                continue;
            }
            PaperAttemptAnswer row = answerMap.get(q.getId());
            if (row == null || StrUtil.isBlank(row.getUserAnswer())) {
                skipped++;
                continue;
            }
            if (!force && row.getAiScore() != null) {
                skipped++;
                continue;
            }
            int maxScore = q.getScore() == null || q.getScore() <= 0 ? 10 : q.getScore();
            ScoreResultVO remote = agentScoreClient.score(
                    paper.getSubject(),
                    q.getQType(),
                    q.getStem(),
                    row.getUserAnswer(),
                    q.getAnswer(),
                    q.getAnalysis(),
                    maxScore);
            BigDecimal score = remote.getScore();
            if (score == null) {
                skipped++;
                continue;
            }
            row.setAiScore(score);
            row.setAiFeedback(StrUtil.blankToDefault(remote.getFeedback(), "（无评语）"));
            paperAttemptAnswerMapper.updateById(row);
            scored++;
        }

        // 刷新答案映射
        answerMap = paperAttemptAnswerMapper.selectList(
                        new LambdaQueryWrapper<PaperAttemptAnswer>()
                                .eq(PaperAttemptAnswer::getAttemptId, attemptId))
                .stream()
                .collect(Collectors.toMap(PaperAttemptAnswer::getPaperQuestionId, a -> a, (a, b) -> a));

        PaperAiScoreResultVO vo = new PaperAiScoreResultVO();
        vo.setAttemptId(attemptId);
        vo.setPaperId(paper.getId());
        vo.setScoredCount(scored);
        vo.setSkippedCount(skipped);
        List<PaperQuestionVO> qvos = new ArrayList<>();
        for (PaperQuestion q : questions) {
            qvos.add(toQuestionVo(q, answerMap.get(q.getId()), true));
        }
        vo.setQuestions(qvos);
        return vo;
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
        vo.setPaperNo(q.getPaperNo());
        vo.setQType(q.getQType());
        vo.setSectionTitle(q.getSectionTitle());
        vo.setStem(q.getStem());
        vo.setScore(q.getScore());
        vo.setInputMode(q.getInputMode());
        vo.setHasStandardAnswer(StrUtil.isNotBlank(q.getAnswer()));
        if (StrUtil.isNotBlank(q.getOptionsJson())) {
            vo.setOptions(JSONUtil.toList(q.getOptionsJson(), String.class));
        }
        if (ans != null) {
            vo.setUserAnswer(ans.getUserAnswer());
            if (ans.getCorrect() != null) {
                vo.setCorrect(ans.getCorrect() == 1);
            }
            if (reveal) {
                vo.setAiScore(ans.getAiScore());
                vo.setAiFeedback(ans.getAiFeedback());
            }
        }
        if (reveal) {
            if (StrUtil.isNotBlank(q.getAnswer())) {
                vo.setAnswer(PaperConstants.Q_CHOICE.equals(q.getQType())
                        ? normalizeChoice(q.getAnswer())
                        : q.getAnswer());
            } else {
                vo.setAnswer(null);
            }
            vo.setAnalysis(q.getAnalysis());
        }
        return vo;
    }

    private void fillGradableStats(PaperDetailVO vo, List<PaperQuestion> questions) {
        int choiceCount = 0;
        int gradable = 0;
        for (PaperQuestion q : questions) {
            if (!PaperConstants.Q_CHOICE.equals(q.getQType())) {
                continue;
            }
            if (!PaperConstants.INPUT_ANSWERABLE.equals(q.getInputMode())) {
                continue;
            }
            choiceCount++;
            if (StrUtil.isNotBlank(q.getAnswer())) {
                gradable++;
            }
        }
        vo.setChoiceCount(choiceCount);
        vo.setGradableChoiceCount(gradable);
    }

    /** 高等数学不走 AI 评分（公式符号难判，揭晓自批）。 */
    private static boolean isMathSubject(String subject) {
        if (subject == null) {
            return false;
        }
        String s = subject.trim();
        return "高等数学".equals(s) || s.contains("高等数学");
    }

    /**
     * 可 AI 评的主观题：填空/简答论述/计算，且非 missing。
     * 广东中文卷主观题入库多为 reveal_only，但仍允许机打作答，交卷后应可 AI 评。
     */
    private static boolean isAiScoreEligible(PaperQuestion q) {
        if (PaperConstants.INPUT_MISSING.equals(q.getInputMode())) {
            return false;
        }
        String t = q.getQType();
        return PaperConstants.Q_FILL.equals(t)
                || PaperConstants.Q_ESSAY.equals(t)
                || PaperConstants.Q_CALC.equals(t);
    }

    /**
     * 规范选择题答案：提取 A–E 字母并按字母序去重拼接（多选如 {@code ABD} / {@code DBA} → {@code ABD}）。
     */
    private static String normalizeChoice(String raw) {
        if (raw == null) {
            return "";
        }
        String upper = StrUtil.trim(raw).toUpperCase();
        StringBuilder sb = new StringBuilder();
        for (char c : new char[]{'A', 'B', 'C', 'D', 'E'}) {
            if (upper.indexOf(c) >= 0) {
                sb.append(c);
            }
        }
        return !sb.isEmpty() ? sb.toString() : upper;
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
