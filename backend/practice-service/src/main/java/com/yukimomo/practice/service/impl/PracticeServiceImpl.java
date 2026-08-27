package com.yukimomo.practice.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.practice.constant.PracticeRedisConstants;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.entity.AnswerRecord;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.entity.StudyStats;
import com.yukimomo.practice.entity.WrongQuestion;
import com.yukimomo.practice.mapper.AnswerRecordMapper;
import com.yukimomo.practice.mapper.QuestionMapper;
import com.yukimomo.practice.mapper.StudyStatsMapper;
import com.yukimomo.practice.mapper.WrongQuestionMapper;
import com.yukimomo.practice.service.PracticeService;
import com.yukimomo.practice.vo.DailyStatusVO;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.QuestionVO;
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
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
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
    private final WrongQuestionMapper wrongQuestionMapper;
    private final StudyStatsMapper studyStatsMapper;
    /** 存字符串：每日题只缓存 questionId */
    private final StringRedisTemplate stringRedisTemplate;

    /** 每日一练来源标识，与前端 submit source 一致 */
    private static final String SOURCE_DAILY = "daily";

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
                return toQuestionVo(done);
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
                    return toQuestionVo(cached);
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
        return toQuestionVo(question);
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
        } else {
            String cachedId = stringRedisTemplate.opsForValue().get(questionKey);
            if (StrUtil.isNotBlank(cachedId)) {
                vo.setQuestionId(Long.valueOf(cachedId));
            }
        }
        return vo;
    }

    /**
     * 随机刷题：只校验登录，每次重新 {@link #pickRandom}，不缓存。
     */
    @Override
    public QuestionVO random(String subject) {
        UserContext.requireUserId();
        return toQuestionVo(pickRandom(subject));
    }

    /**
     * 提交判分（事务）：写历史 → 错则 upsert 错题 → upsert 统计 → 组装含解析的结果。
     * rollbackFor=Exception：任意受检/运行时异常都回滚，避免半写入。
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

        // 一期：答对不从错题本移除，仅答错累加
        if (!correct) {
            upsertWrong(userId, question.getId());
        }
        upsertStats(userId, correct, SOURCE_DAILY.equalsIgnoreCase(source));

        // 提交结果才带答案与解析
        SubmitResultVO vo = new SubmitResultVO();
        vo.setQuestionId(question.getId());
        vo.setCorrect(correct);
        vo.setAnswer(question.getAnswer());
        vo.setAnalysis(question.getAnalysis());
        vo.setUserAnswer(userAnswer);
        return vo;
    }

    /**
     * 错题分页：先查 wrong_question，再一次性 load 题目 Map，组装 VO（防 N+1）。
     */
    @Override
    public PageDTO<WrongQuestionVO> listWrong(PageQuery query) {
        Long userId = UserContext.requireUserId();
        // toMpPage(列名, asc=false) → 按最近答错时间倒序
        Page<WrongQuestion> page = wrongQuestionMapper.selectPage(
                query.toMpPage("last_wrong_at", false),
                new LambdaQueryWrapper<WrongQuestion>().eq(WrongQuestion::getUserId, userId)
        );
        if (page.getRecords() == null || page.getRecords().isEmpty()) {
            return PageDTO.empty();
        }

        // stream 收集本页全部 questionId，批量查题
        Map<Long, Question> questionMap = loadQuestions(page.getRecords().stream()
                .map(WrongQuestion::getQuestionId)
                .collect(Collectors.toSet()));

        List<WrongQuestionVO> list = page.getRecords().stream().map(w -> {
            WrongQuestionVO vo = new WrongQuestionVO();
            vo.setId(w.getId());
            vo.setQuestionId(w.getQuestionId());
            vo.setWrongCount(w.getWrongCount());
            vo.setLastWrongAt(w.getLastWrongAt());
            Question q = questionMap.get(w.getQuestionId());
            // 题目被删时仍保留错题行，但题干字段为空
            if (q != null) {
                vo.setSubject(q.getSubject());
                vo.setStem(q.getStem());
                vo.setOptions(parseOptions(q.getOptionsJson()));
                vo.setDifficulty(q.getDifficulty());
            }
            return vo;
        }).toList();

        PageDTO<WrongQuestionVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
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

        Map<Long, Question> questionMap = loadQuestions(page.getRecords().stream()
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
    public StudyStatsVO stats() {
        Long userId = UserContext.requireUserId();
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
     * 错题 upsert：无则 insert count=1；有则 count+1 并刷新 last_wrong_at。
     */
    private void upsertWrong(Long userId, Long questionId) {
        WrongQuestion existing = wrongQuestionMapper.selectOne(
                new LambdaQueryWrapper<WrongQuestion>()
                        .eq(WrongQuestion::getUserId, userId)
                        .eq(WrongQuestion::getQuestionId, questionId)
        );
        LocalDateTime now = LocalDateTime.now();
        if (existing == null) {
            WrongQuestion row = new WrongQuestion();
            row.setUserId(userId);
            row.setQuestionId(questionId);
            row.setWrongCount(1);
            row.setLastWrongAt(now);
            wrongQuestionMapper.insert(row);
            return;
        }
        // 三元防 wrongCount 为 null
        existing.setWrongCount(existing.getWrongCount() == null ? 1 : existing.getWrongCount() + 1);
        existing.setLastWrongAt(now);
        wrongQuestionMapper.updateById(existing);
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

    /**
     * 按 id 集合批量查题，转成 Map&lt;id, Question&gt; 方便 O(1) 回填。
     * merge 函数 (a,b)-&gt;a：万一重复 id 保留第一条。
     */
    private Map<Long, Question> loadQuestions(Set<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyMap();
        }
        return questionMapper.selectList(new LambdaQueryWrapper<Question>().in(Question::getId, ids))
                .stream()
                .collect(Collectors.toMap(Question::getId, Function.identity(), (a, b) -> a));
    }

    /**
     * 距次日 0 点的秒数，作为每日题 Redis TTL；至少 1 秒，避免 Duration 非法。
     */
    private static long secondsUntilTomorrow() {
        LocalDateTime tomorrowStart = LocalDateTime.of(LocalDate.now().plusDays(1), LocalTime.MIDNIGHT);
        long seconds = Duration.between(LocalDateTime.now(), tomorrowStart).getSeconds();
        return Math.max(seconds, 1L);
    }

    /**
     * Entity → 出题 VO：不拷贝 answer/analysis。
     */
    private static QuestionVO toQuestionVo(Question q) {
        QuestionVO vo = new QuestionVO();
        vo.setId(q.getId());
        vo.setSubject(q.getSubject());
        vo.setStem(q.getStem());
        vo.setOptions(parseOptions(q.getOptionsJson()));
        vo.setDifficulty(q.getDifficulty());
        return vo;
    }

    /** 把 options_json 字符串解析成 List&lt;String&gt;；空串返回空列表 */
    private static List<String> parseOptions(String optionsJson) {
        if (StrUtil.isBlank(optionsJson)) {
            return Collections.emptyList();
        }
        return JSONUtil.toList(optionsJson, String.class);
    }
}
