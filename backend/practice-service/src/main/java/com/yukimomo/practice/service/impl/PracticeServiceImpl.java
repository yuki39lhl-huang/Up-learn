package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.constant.PracticeRedisConstants;
import com.yukimomo.practice.dto.AddPracticeNoteDTO;
import com.yukimomo.practice.dto.AddWrongBookDTO;
import com.yukimomo.practice.dto.RandomResetDTO;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.entity.AnswerRecord;
import com.yukimomo.practice.entity.DailyEncouragement;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.entity.StudyStats;
import com.yukimomo.practice.mapper.AnswerRecordMapper;
import com.yukimomo.practice.mapper.DailyEncouragementMapper;
import com.yukimomo.practice.mapper.QuestionMapper;
import com.yukimomo.practice.mapper.StudyStatsMapper;
import com.yukimomo.practice.service.PracticeNoteService;
import com.yukimomo.practice.service.PracticeService;
import com.yukimomo.practice.service.RandomPracticeService;
import com.yukimomo.practice.service.WrongBookService;
import com.yukimomo.practice.support.QuestionSupport;
import com.yukimomo.practice.vo.DailyStatusVO;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.PracticeNoteVO;
import com.yukimomo.practice.vo.QuestionVO;
import com.yukimomo.practice.vo.RandomPendingHintVO;
import com.yukimomo.practice.vo.RandomResetVO;
import com.yukimomo.practice.vo.StudyStatsVO;
import com.yukimomo.practice.vo.SubmitResultVO;
import com.yukimomo.practice.vo.WrongQuestionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.stream.Collectors;

/**
 * {@link PracticeService} 实现：出题、判分、错题、历史、统计。
 * <p>
 * {@link RequiredArgsConstructor} 生成含 final 字段的构造器，由 Spring 注入 Mapper 与 Redis。
 */
@Service
@RequiredArgsConstructor
public class PracticeServiceImpl implements PracticeService {

    /** Redis 日维度 Key 用的日期格式，如 20260826 */
    private static final DateTimeFormatter DAY_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final QuestionMapper questionMapper;
    private final AnswerRecordMapper answerRecordMapper;
    private final DailyEncouragementMapper dailyEncouragementMapper;
    private final StudyStatsMapper studyStatsMapper;
    /** 存字符串：每日题只缓存 questionId */
    private final StringRedisTemplate stringRedisTemplate;
    private final RandomPracticeService randomPracticeService;
    private final WrongBookService wrongBookService;
    private final PracticeNoteService practiceNoteService;
    private final QuestionSupport questionSupport;

    /** 每日一练来源标识，与前端 submit source 一致 */
    private static final String SOURCE_DAILY = "daily";
    private static final String SOURCE_RANDOM = "random";

    /**
     * 每日一练流程：
     * 1) 若今日已完成（source=daily 提交）→ 返回当日已做题
     * 2) 拼 Key = 前缀 + userId + 当天 yyyyMMdd
     * 3) 未完成且传入新 subject → 可换题；命中缓存且题目仍存在 → 直接返回
     * 4) 否则随机抽题，写入 Redis，TTL 到次日 0 点
     */
    @Override
    public QuestionVO daily(String subject) {
        Long userId = UserContext.requireUserId();
        String day = LocalDate.now().format(DAY_FMT);
        String questionKey = PracticeRedisConstants.DAILY_QUESTION_PREFIX + userId + ":" + day;
        String subjectKey = PracticeRedisConstants.DAILY_SUBJECT_PREFIX + userId + ":" + day;

        AnswerRecord todayDaily = findTodayDailyRecord(userId);
        if (todayDaily != null) {
            Question done = questionMapper.selectById(todayDaily.getQuestionId());
            if (done != null) {
                return questionSupport.toQuestionVo(done);
            }
        }

        String lockedSubject = stringRedisTemplate.opsForValue().get(subjectKey);
        String normalizedSubject = StrUtil.trim(subject);
        boolean subjectChanged = StrUtil.isNotBlank(normalizedSubject)
                && StrUtil.isNotBlank(lockedSubject)
                && !StrUtil.equals(normalizedSubject, lockedSubject);

        if (!subjectChanged) {
            String cachedId = stringRedisTemplate.opsForValue().get(questionKey);
            if (StrUtil.isNotBlank(cachedId)) {
                Question cached = questionMapper.selectById(Long.valueOf(cachedId));
                if (cached != null) {
                    return questionSupport.toQuestionVo(cached);
                }
            }
        }

        String pickSubject = StrUtil.isNotBlank(normalizedSubject) ? normalizedSubject : lockedSubject;
        Question question = pickRandom(pickSubject);
        long ttlSeconds = secondsUntilTomorrow();
        stringRedisTemplate.opsForValue().set(questionKey, String.valueOf(question.getId()), Duration.ofSeconds(ttlSeconds));
        if (StrUtil.isNotBlank(pickSubject)) {
            stringRedisTemplate.opsForValue().set(subjectKey, pickSubject, Duration.ofSeconds(ttlSeconds));
        }
        return questionSupport.toQuestionVo(question);
    }

    @Override
    public DailyStatusVO dailyStatus() {
        Long userId = UserContext.requireUserId();
        String day = LocalDate.now().format(DAY_FMT);
        String questionKey = PracticeRedisConstants.DAILY_QUESTION_PREFIX + userId + ":" + day;
        String subjectKey = PracticeRedisConstants.DAILY_SUBJECT_PREFIX + userId + ":" + day;

        DailyStatusVO vo = new DailyStatusVO();
        AnswerRecord todayDaily = findTodayDailyRecord(userId);
        vo.setCompletedToday(todayDaily != null);

        String lockedSubject = stringRedisTemplate.opsForValue().get(subjectKey);
        vo.setSubject(lockedSubject);

        if (todayDaily != null) {
            vo.setQuestionId(todayDaily.getQuestionId());
            vo.setUserAnswer(todayDaily.getUserAnswer());
            vo.setCorrect(Objects.equals(todayDaily.getCorrect(), 1));
            vo.setEncouragement(pickDailyEncouragement(userId, day));
            Question answered = questionMapper.selectById(todayDaily.getQuestionId());
            if (answered != null) {
                vo.setAnswer(answered.getAnswer());
                vo.setAnalysis(answered.getAnalysis());
            }
        } else {
            String cachedId = stringRedisTemplate.opsForValue().get(questionKey);
            if (StrUtil.isNotBlank(cachedId)) {
                vo.setQuestionId(Long.valueOf(cachedId));
            }
        }
        return vo;
    }

    /**
     * 随机刷题：按备考科目与间隔复习选题池抽题。
     */
    @Override
    public QuestionVO random() {
        Long userId = UserContext.requireUserId();
        return questionSupport.toQuestionVo(randomPracticeService.pickQuestion(userId));
    }

    @Override
    public RandomPendingHintVO randomPendingHint() {
        Long userId = UserContext.requireUserId();
        List<String> otherSubjects = randomPracticeService.listOtherSubjectsWithPendingWrong(userId);
        RandomPendingHintVO vo = new RandomPendingHintVO();
        vo.setOtherSubjects(otherSubjects);
        vo.setShowHint(!otherSubjects.isEmpty());
        return vo;
    }

    /**
     * 提交判分（事务）：写 answer_record；随机刷题更新 user_question_record；其余场景 upsert study_stats。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public SubmitResultVO submit(SubmitAnswerDTO dto) {
        Long userId = UserContext.requireUserId();
        Question question = questionMapper.selectById(dto.getQuestionId());
        if (question == null) {
            throw new BadRequestException("题目不存在");
        }

        // trim + 大写，兼容前端传 "b" / " B "
        String userAnswer = dto.getUserAnswer().trim().toUpperCase();
        // 与标准答案忽略大小写比较
        boolean correct = StrUtil.equalsIgnoreCase(userAnswer, question.getAnswer());

        AnswerRecord record = new AnswerRecord();
        record.setUserId(userId);
        record.setQuestionId(question.getId());
        record.setUserAnswer(userAnswer);
        record.setCorrect(correct ? 1 : 0);
        String source = StrUtil.blankToDefault(dto.getSource(), "submit");
        if (SOURCE_DAILY.equalsIgnoreCase(source) && findTodayDailyRecord(userId) != null) {
            throw new BadRequestException("今日每日一练已完成，明天再来吧");
        }
        record.setSource(source);
        answerRecordMapper.insert(record);

        boolean isRandom = RandomPracticeService.isRandomSource(source);
        boolean isDaily = SOURCE_DAILY.equalsIgnoreCase(source);

        if (isRandom) {
            // 随机刷题：间隔复习调度 + 当日已做 Redis，不写入 study_stats
            randomPracticeService.onAnswerSubmitted(userId, question, correct);
        } else {
            upsertStats(userId, correct, isDaily);
        }

        // 提交结果才带答案与解析
        SubmitResultVO vo = new SubmitResultVO();
        vo.setQuestionId(question.getId());
        vo.setCorrect(correct);
        vo.setAnswer(question.getAnswer());
        vo.setAnalysis(question.getAnalysis());
        vo.setUserAnswer(userAnswer);
        return vo;
    }

    @Override
    public PageDTO<WrongQuestionVO> listWrong(PageQuery query, String date, String subject) {
        return wrongBookService.list(query, date, subject);
    }

    @Override
    public WrongQuestionVO addWrongBook(AddWrongBookDTO dto) {
        return wrongBookService.add(dto);
    }

    @Override
    public WrongQuestionVO getWrongBook(Long id) {
        return wrongBookService.get(id);
    }

    @Override
    public void deleteWrongBook(Long id) {
        wrongBookService.delete(id);
    }

    @Override
    public int deleteAllWrongBook(String date, String subject) {
        return wrongBookService.deleteAll(date, subject);
    }

    @Override
    public PracticeNoteVO addNote(AddPracticeNoteDTO dto) {
        return practiceNoteService.add(dto);
    }

    @Override
    public PracticeNoteVO getNote(Long id) {
        return practiceNoteService.get(id);
    }

    @Override
    public PageDTO<PracticeNoteVO> listNotes(PageQuery query, String date, String subject) {
        return practiceNoteService.list(query, date, subject);
    }

    @Override
    public void deleteNote(Long id) {
        practiceNoteService.delete(id);
    }

    @Override
    public int deleteAllNotes(String date, String subject) {
        return practiceNoteService.deleteAll(date, subject);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RandomResetVO resetRandom(RandomResetDTO dto) {
        Long userId = UserContext.requireUserId();
        RandomResetVO vo = randomPracticeService.resetProgress(userId, dto.getScope(), dto.getSubject());
        clearRandomAnswerRecords(userId, vo.getSubjects());
        return vo;
    }

    /** 清空重刷时同步清除随机刷题答题记录，统计归零。 */
    private void clearRandomAnswerRecords(Long userId, List<String> subjects) {
        if (subjects == null || subjects.isEmpty()) {
            return;
        }
        List<Long> questionIds = questionMapper.selectList(
                new LambdaQueryWrapper<Question>()
                        .in(Question::getSubject, subjects)
                        .select(Question::getId)
        ).stream().map(Question::getId).toList();
        if (questionIds.isEmpty()) {
            return;
        }
        answerRecordMapper.delete(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_RANDOM)
                        .in(AnswerRecord::getQuestionId, questionIds)
        );
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resetRandomProgress() {
        Long userId = UserContext.requireUserId();
        randomPracticeService.resetAllProgress(userId);
        answerRecordMapper.delete(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_RANDOM)
        );
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resetDailyCheckIn() {
        Long userId = UserContext.requireUserId();
        answerRecordMapper.delete(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_DAILY)
        );
        studyStatsMapper.delete(
                new LambdaQueryWrapper<StudyStats>().eq(StudyStats::getUserId, userId)
        );
        String day = LocalDate.now().format(DAY_FMT);
        stringRedisTemplate.delete(PracticeRedisConstants.DAILY_QUESTION_PREFIX + userId + ":" + day);
        stringRedisTemplate.delete(PracticeRedisConstants.DAILY_SUBJECT_PREFIX + userId + ":" + day);
    }

    /**
     * 历史分页：逻辑同错题列表，主表换成 answer_record，按 created_at 倒序。
     */
    @Override
    public PageDTO<AnswerHistoryVO> listHistory(PageQuery query) {
        Long userId = UserContext.requireUserId();
        Page<AnswerRecord> page = answerRecordMapper.selectPage(
                query.toMpPage("created_at", false),
                new LambdaQueryWrapper<AnswerRecord>().eq(AnswerRecord::getUserId, userId)
        );
        if (page.getRecords() == null || page.getRecords().isEmpty()) {
            return PageDTO.empty();
        }

        Map<Long, Question> questionMap = questionSupport.loadByIds(page.getRecords().stream()
                .map(AnswerRecord::getQuestionId)
                .collect(Collectors.toSet()));

        List<AnswerHistoryVO> list = page.getRecords().stream().map(r -> {
            AnswerHistoryVO vo = new AnswerHistoryVO();
            vo.setId(r.getId());
            vo.setQuestionId(r.getQuestionId());
            vo.setUserAnswer(r.getUserAnswer());
            // TINYINT 1 → Boolean true；用 Objects.equals 防 NPE
            vo.setCorrect(Objects.equals(r.getCorrect(), 1));
            vo.setSource(r.getSource());
            vo.setCreatedAt(r.getCreatedAt());
            Question q = questionMap.get(r.getQuestionId());
            if (q != null) {
                vo.setSubject(q.getSubject());
                vo.setStem(q.getStem());
            }
            return vo;
        }).toList();

        PageDTO<AnswerHistoryVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    /**
     * 读 study_stats；无行则返回全 0，前端无需再判 null。
     */
    @Override
    public StudyStatsVO stats(String source) {
        Long userId = UserContext.requireUserId();
        if (RandomPracticeService.isRandomSource(source)) {
            return computeSourceStats(userId, SOURCE_RANDOM);
        }

        StudyStats stats = studyStatsMapper.selectOne(
                new LambdaQueryWrapper<StudyStats>().eq(StudyStats::getUserId, userId)
        );
        StudyStatsVO vo = new StudyStatsVO();
        int totalCheckIn = countTotalCheckInDays(userId);
        int streak = computeDailyStreak(userId);
        if (stats == null) {
            vo.setTotalAnswered(0);
            vo.setCorrectCount(0);
            vo.setAccuracy(BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP));
            vo.setStreak(streak);
            vo.setTotalCheckInDays(totalCheckIn);
            return vo;
        }
        vo.setTotalAnswered(stats.getTotalAnswered());
        vo.setCorrectCount(stats.getCorrectCount());
        vo.setAccuracy(stats.getAccuracy() != null
                ? stats.getAccuracy()
                : BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP));
        vo.setStreak(streak);
        vo.setTotalCheckInDays(totalCheckIn);
        return vo;
    }

    /** 按 source 汇总答题记录；用于随机刷题统计（不含打卡 streak）。 */
    private StudyStatsVO computeSourceStats(Long userId, String source) {
        List<AnswerRecord> records = answerRecordMapper.selectList(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, source)
        );
        StudyStatsVO vo = new StudyStatsVO();
        vo.setStreak(0);
        vo.setTotalCheckInDays(0);
        if (records == null || records.isEmpty()) {
            vo.setTotalAnswered(0);
            vo.setCorrectCount(0);
            vo.setAccuracy(BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP));
            return vo;
        }
        int total = records.size();
        int correctCount = (int) records.stream().filter(r -> Objects.equals(r.getCorrect(), 1)).count();
        vo.setTotalAnswered(total);
        vo.setCorrectCount(correctCount);
        vo.setAccuracy(calcAccuracy(total, correctCount));
        return vo;
    }

    /**
     * 库内随机一题；有 subject 则精确过滤。
     * {@code last} 追加原生 SQL 片段，ORDER BY RAND() 适合一期小数据量。
     */
    private Question pickRandom(String subject) {
        LambdaQueryWrapper<Question> wrapper = new LambdaQueryWrapper<>();
        if (StrUtil.isNotBlank(subject)) {
            wrapper.eq(Question::getSubject, subject.trim());
        }
        // last：接在 WHERE 后，注意不要注入用户原文做列名；这里只拼固定字符串
        wrapper.last("ORDER BY RAND() LIMIT 1");
        Question question = questionMapper.selectOne(wrapper);
        if (question == null) {
            // 三元：有科目筛选时提示「该科无题」，否则提示导入种子
            throw new BadRequestException(StrUtil.isNotBlank(subject)
                    ? "该科目暂无题目"
                    : "题库为空，请先导入种子数据");
        }
        return question;
    }

    /**
     * 更新学习统计。
     * <p>
     * streak 规则（一期）：
     * <ul>
     *   <li>无记录 → streak=1</li>
     *   <li>上次提交日 == 今天 → 维持（当天多次提交不加）</li>
     *   <li>上次提交日 == 昨天 → streak+1</li>
     *   <li>其它（中断）→ 重置为 1</li>
     * </ul>
     * 注意：必须用 update 前的 {@code updatedAt} 判断「上次日期」，update 后会被刷新。
     */
    private void upsertStats(Long userId, boolean correct, boolean countStreak) {
        StudyStats stats = studyStatsMapper.selectOne(
                new LambdaQueryWrapper<StudyStats>().eq(StudyStats::getUserId, userId)
        );
        if (stats == null) {
            StudyStats row = new StudyStats();
            row.setUserId(userId);
            row.setTotalAnswered(1);
            row.setCorrectCount(correct ? 1 : 0);
            row.setAccuracy(calcAccuracy(1, correct ? 1 : 0));
            row.setStreak(countStreak ? computeDailyStreak(userId) : 0);
            studyStatsMapper.insert(row);
            return;
        }

        int streak = stats.getStreak() == null ? 0 : stats.getStreak();
        if (countStreak) {
            streak = computeDailyStreak(userId);
        }

        int total = (stats.getTotalAnswered() == null ? 0 : stats.getTotalAnswered()) + 1;
        int correctCount = (stats.getCorrectCount() == null ? 0 : stats.getCorrectCount()) + (correct ? 1 : 0);
        stats.setTotalAnswered(total);
        stats.setCorrectCount(correctCount);
        stats.setAccuracy(calcAccuracy(total, correctCount));
        stats.setStreak(streak);
        studyStatsMapper.updateById(stats);
    }

    /**
     * 从寄语库随机取一条（按用户+日期种子，同日稳定、跨日变化）。
     */
    private String pickDailyEncouragement(Long userId, String day) {
        List<DailyEncouragement> rows = dailyEncouragementMapper.selectList(
                new LambdaQueryWrapper<DailyEncouragement>()
                        .eq(DailyEncouragement::getEnabled, 1)
                        .orderByAsc(DailyEncouragement::getSortOrder)
                        .orderByAsc(DailyEncouragement::getId)
        );
        if (rows == null || rows.isEmpty()) {
            return null;
        }
        Random rng = new Random(userId ^ day.hashCode());
        return rows.get(rng.nextInt(rows.size())).getContent();
    }

    /** 今日是否已有 source=daily 的答题记录 */
    private AnswerRecord findTodayDailyRecord(Long userId) {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        return answerRecordMapper.selectOne(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_DAILY)
                        .ge(AnswerRecord::getCreatedAt, startOfDay)
                        .orderByDesc(AnswerRecord::getCreatedAt)
                        .last("LIMIT 1")
        );
    }

    /** 累计签到：完成 daily 的去重日期数 */
    private int countTotalCheckInDays(Long userId) {
        List<AnswerRecord> records = answerRecordMapper.selectList(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_DAILY)
                        .select(AnswerRecord::getCreatedAt)
        );
        if (records == null || records.isEmpty()) {
            return 0;
        }
        return (int) records.stream()
                .filter(r -> r.getCreatedAt() != null)
                .map(r -> r.getCreatedAt().toLocalDate())
                .distinct()
                .count();
    }

    /**
     * 连续签到：从今天（若已签）或昨天起向前数连续有 daily 记录的天数。
     * 今日未签但昨日已签时， streak 仍保留至当日 24 点前。
     */
    private int computeDailyStreak(Long userId) {
        LocalDate today = LocalDate.now();
        LocalDate cursor = findTodayDailyRecord(userId) != null ? today : today.minusDays(1);
        int streak = 0;
        while (hasDailyOn(userId, cursor)) {
            streak++;
            cursor = cursor.minusDays(1);
        }
        return streak;
    }

    private boolean hasDailyOn(Long userId, LocalDate day) {
        LocalDateTime start = day.atStartOfDay();
        LocalDateTime end = day.plusDays(1).atStartOfDay();
        Long count = answerRecordMapper.selectCount(
                new LambdaQueryWrapper<AnswerRecord>()
                        .eq(AnswerRecord::getUserId, userId)
                        .eq(AnswerRecord::getSource, SOURCE_DAILY)
                        .ge(AnswerRecord::getCreatedAt, start)
                        .lt(AnswerRecord::getCreatedAt, end)
        );
        return count != null && count > 0;
    }

    /** 正确率 = 正确数 / 总题数 * 100，保留两位，四舍五入 */
    private static BigDecimal calcAccuracy(int total, int correctCount) {
        if (total <= 0) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return BigDecimal.valueOf(correctCount * 100.0 / total).setScale(2, RoundingMode.HALF_UP);
    }

    private static long secondsUntilTomorrow() {
        LocalDateTime tomorrowStart = LocalDateTime.of(LocalDate.now().plusDays(1), LocalTime.MIDNIGHT);
        long seconds = Duration.between(LocalDateTime.now(), tomorrowStart).getSeconds();
        return Math.max(seconds, 1L);
    }
}
