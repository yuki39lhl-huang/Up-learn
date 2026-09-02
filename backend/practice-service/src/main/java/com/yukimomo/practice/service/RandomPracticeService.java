package com.yukimomo.practice.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.practice.constant.PracticeRedisConstants;
import com.yukimomo.practice.constant.PracticeSubjectMap;
import com.yukimomo.practice.constant.QuestionRecordStatus;
import com.yukimomo.practice.entity.Question;
import com.yukimomo.practice.entity.UserExamPreferenceRow;
import com.yukimomo.practice.entity.UserQuestionRecord;
import com.yukimomo.practice.mapper.QuestionMapper;
import com.yukimomo.practice.mapper.UserExamPreferenceRowMapper;
import com.yukimomo.practice.mapper.UserQuestionRecordMapper;
import com.yukimomo.practice.vo.RandomResetVO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ThreadLocalRandom;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 随机刷题核心逻辑：备考科目过滤、间隔复习选题池、今日已做记录。
 * <p>
 * 选题优先级：错题（WRONG）&gt; 到期复习（RIGHT 且 now &gt;= nextReviewTime）&gt; 新题（无记录）；
 * 同一天同一科目内不重复出题。详见 {@code markdown/随机刷题选题原理.md}。
 */
@Service
@RequiredArgsConstructor
public class RandomPracticeService {

    private static final String SOURCE_RANDOM = "random";
    /** 在用户全部备考映射题库科目中混合抽题。 */
    private static final String MODE_ALL = "all";
    /** 仅在一个题库科目内抽题。 */
    private static final String MODE_SINGLE = "single";
    /** 清空重刷：全部备考映射科目。 */
    public static final String RESET_SCOPE_ALL = "all";
    /** 清空重刷：单个题库科目。 */
    public static final String RESET_SCOPE_SINGLE = "single";
    private static final DateTimeFormatter DAY_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");
    /** 连续做对后的复习间隔：2→4→7→14→30 天。 */
    private static final int[] REVIEW_INTERVALS = {2, 4, 7, 14, 30};

    private final UserExamPreferenceRowMapper preferenceRowMapper;
    private final QuestionMapper questionMapper;
    private final UserQuestionRecordMapper userQuestionRecordMapper;
    private final StringRedisTemplate stringRedisTemplate;

    /**
     * 按用户备考与随机筛选，从选题池加权随机一题。
     */
    public Question pickQuestion(Long userId) {
        UserExamPreferenceRow preference = requirePreference(userId);
        List<String> bankSubjects = resolveTargetBankSubjects(preference);
        if (bankSubjects.isEmpty()) {
            throw new BadRequestException("当前备考科目暂无题库覆盖，请调整备考设置");
        }

        String day = LocalDate.now().format(DAY_FMT);
        Set<Long> todayDone = loadTodayDone(userId, day, bankSubjects);

        List<Question> candidates = questionMapper.selectList(
                new LambdaQueryWrapper<Question>()
                        .in(Question::getSubject, bankSubjects)
        );
        if (candidates.isEmpty()) {
            throw new BadRequestException("该科目范围暂无题目，请先导入种子数据");
        }

        Set<Long> questionIds = candidates.stream().map(Question::getId).collect(Collectors.toSet());
        Map<Long, UserQuestionRecord> recordMap = loadRecordMap(userId, questionIds);

        List<Long> wrongPool = new ArrayList<>();
        List<Long> reviewPool = new ArrayList<>();
        List<Long> newPool = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (Question q : candidates) {
            if (todayDone.contains(q.getId())) {
                continue;
            }
            UserQuestionRecord record = recordMap.get(q.getId());
            if (record == null) {
                newPool.add(q.getId());
                continue;
            }
            if (QuestionRecordStatus.WRONG.equals(record.getStatus())) {
                wrongPool.add(q.getId());
            } else if (QuestionRecordStatus.RIGHT.equals(record.getStatus())
                    && record.getNextReviewTime() != null
                    && !now.isBefore(record.getNextReviewTime())) {
                reviewPool.add(q.getId());
            } else if (QuestionRecordStatus.NEW.equals(record.getStatus())) {
                newPool.add(q.getId());
            }
        }

        Long pickedId = weightedPick(wrongPool, reviewPool, newPool);
        if (pickedId == null) {
            if (todayDone.size() > 0) {
                throw new BadRequestException("今日该科目范围题目已刷完，明天再来或切换科目");
            }
            throw new BadRequestException("暂无可用题目，请稍后再试或切换科目");
        }

        Question question = questionMapper.selectById(pickedId);
        if (question == null) {
            throw new BadRequestException("题目不存在");
        }
        return question;
    }

    /**
     * 随机刷题提交后：更新 {@code user_question_record}，并记入当日已做 Redis Set。
     */
    public void onAnswerSubmitted(Long userId, Question question, boolean correct) {
        LocalDateTime now = LocalDateTime.now();
        UserQuestionRecord record = userQuestionRecordMapper.selectOne(
                new LambdaQueryWrapper<UserQuestionRecord>()
                        .eq(UserQuestionRecord::getUserId, userId)
                        .eq(UserQuestionRecord::getQuestionId, question.getId())
        );

        if (record == null) {
            record = new UserQuestionRecord();
            record.setUserId(userId);
            record.setQuestionId(question.getId());
            record.setWrongCount(0);
            record.setRightCount(0);
            record.setReviewIntervalDays(0);
        }

        record.setLastAnswerTime(now);
        if (correct) {
            int rightCount = (record.getRightCount() == null ? 0 : record.getRightCount()) + 1;
            record.setRightCount(rightCount);
            record.setStatus(QuestionRecordStatus.RIGHT);
            int intervalDays = intervalForRightCount(rightCount);
            record.setReviewIntervalDays(intervalDays);
            record.setNextReviewTime(now.plusDays(intervalDays));
        } else {
            int wrongCount = (record.getWrongCount() == null ? 0 : record.getWrongCount()) + 1;
            record.setWrongCount(wrongCount);
            record.setStatus(QuestionRecordStatus.WRONG);
            record.setReviewIntervalDays(0);
            record.setNextReviewTime(null);
        }

        if (record.getId() == null) {
            userQuestionRecordMapper.insert(record);
        } else {
            userQuestionRecordMapper.updateById(record);
        }

        markTodayDone(userId, question.getSubject(), question.getId());
    }

    /** 当前筛选在 UI 上的展示文案。 */
    public String currentFilterLabel(Long userId) {
        UserExamPreferenceRow preference = preferenceRowMapper.selectOne(
                new LambdaQueryWrapper<UserExamPreferenceRow>()
                        .eq(UserExamPreferenceRow::getUserId, userId)
        );
        if (preference == null) {
            return MODE_ALL;
        }
        if (MODE_SINGLE.equalsIgnoreCase(StrUtil.blankToDefault(preference.getRandomSubjectMode(), MODE_ALL))
                && StrUtil.isNotBlank(preference.getRandomSubject())) {
            return preference.getRandomSubject().trim();
        }
        return "全随机";
    }

    /**
     * 根据备考设置与随机筛选，解析本次出题使用的题库科目列表。
     * <p>
     * 切换科目筛选只收窄出题范围，不删除 {@code user_question_record} 中的历史记录。
     */
    public List<String> resolveTargetBankSubjects(UserExamPreferenceRow preference) {
        List<String> bankSubjects = PracticeSubjectMap.bankSubjectsFromSelectionJson(
                preference.getSubjectSelectionJson());
        if (bankSubjects.isEmpty()) {
            return Collections.emptyList();
        }
        String mode = StrUtil.blankToDefault(preference.getRandomSubjectMode(), MODE_ALL);
        if (MODE_SINGLE.equalsIgnoreCase(mode) && StrUtil.isNotBlank(preference.getRandomSubject())) {
            String single = preference.getRandomSubject().trim();
            if (bankSubjects.contains(single)) {
                return List.of(single);
            }
            throw new BadRequestException("所选科目不在当前备考范围内，请重新选择刷题科目");
        }
        return bankSubjects;
    }

    /** 要求用户已保存备考设置，否则无法随机刷题。 */
    public UserExamPreferenceRow requirePreference(Long userId) {
        UserExamPreferenceRow preference = preferenceRowMapper.selectOne(
                new LambdaQueryWrapper<UserExamPreferenceRow>()
                        .eq(UserExamPreferenceRow::getUserId, userId)
        );
        if (preference == null
                || StrUtil.isBlank(preference.getSubjectSelectionJson())) {
            throw new BadRequestException("请先完成备考设置后再刷题");
        }
        return preference;
    }

    /** 判断提交来源是否为随机刷题。 */
    public static boolean isRandomSource(String source) {
        return SOURCE_RANDOM.equalsIgnoreCase(StrUtil.blankToDefault(source, ""));
    }

    /**
     * 当前随机筛选范围外，是否仍有其它备考科目存在「今日还可刷」的错题（WRONG 且未记入当日已做）。
     * <p>
     * 用于科目标签旁提示用户切换科目继续复习。
     */
    public List<String> listOtherSubjectsWithPendingWrong(Long userId) {
        UserExamPreferenceRow preference = preferenceRowMapper.selectOne(
                new LambdaQueryWrapper<UserExamPreferenceRow>()
                        .eq(UserExamPreferenceRow::getUserId, userId)
        );
        if (preference == null || StrUtil.isBlank(preference.getSubjectSelectionJson())) {
            return Collections.emptyList();
        }
        List<String> allBankSubjects = PracticeSubjectMap.bankSubjectsFromSelectionJson(
                preference.getSubjectSelectionJson());
        if (allBankSubjects.size() <= 1) {
            return Collections.emptyList();
        }

        List<String> currentSubjects = resolveTargetBankSubjects(preference);
        Set<String> currentSet = new HashSet<>(currentSubjects);
        List<String> otherSubjects = allBankSubjects.stream()
                .filter(s -> !currentSet.contains(s))
                .toList();
        if (otherSubjects.isEmpty()) {
            return Collections.emptyList();
        }

        String day = LocalDate.now().format(DAY_FMT);
        List<String> pending = new ArrayList<>();
        for (String bankSubject : otherSubjects) {
            if (hasPendingWrongInSubject(userId, bankSubject, day)) {
                pending.add(bankSubject);
            }
        }
        return pending;
    }

    private boolean hasPendingWrongInSubject(Long userId, String bankSubject, String day) {
        List<Long> questionIds = questionMapper.selectList(
                new LambdaQueryWrapper<Question>()
                        .eq(Question::getSubject, bankSubject)
                        .select(Question::getId)
        ).stream().map(Question::getId).toList();
        if (questionIds.isEmpty()) {
            return false;
        }

        Set<Long> todayDone = loadTodayDone(userId, day, List.of(bankSubject));
        List<UserQuestionRecord> wrongRecords = userQuestionRecordMapper.selectList(
                new LambdaQueryWrapper<UserQuestionRecord>()
                        .eq(UserQuestionRecord::getUserId, userId)
                        .in(UserQuestionRecord::getQuestionId, questionIds)
                        .eq(UserQuestionRecord::getStatus, QuestionRecordStatus.WRONG)
        );
        if (wrongRecords == null || wrongRecords.isEmpty()) {
            return false;
        }
        for (UserQuestionRecord record : wrongRecords) {
            if (!todayDone.contains(record.getQuestionId())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 清空重刷：清除指定科目范围内的 {@code user_question_record} 与当日 Redis 已做记录。
     * <p>
     * 不影响错题本、备忘录与答题历史。
     */
    /**
     * 备考重置：清除该用户全部随机刷题复习调度与 Redis 当日已做（不依赖备考偏好）。
     */
    public int resetAllProgress(Long userId) {
        int cleared = userQuestionRecordMapper.delete(
                new LambdaQueryWrapper<UserQuestionRecord>()
                        .eq(UserQuestionRecord::getUserId, userId)
        );
        Set<String> keys = stringRedisTemplate.keys(
                PracticeRedisConstants.RANDOM_DONE_PREFIX + userId + ":*");
        if (keys != null && !keys.isEmpty()) {
            stringRedisTemplate.delete(keys);
        }
        return cleared;
    }

    public RandomResetVO resetProgress(Long userId, String scope, String subject) {
        UserExamPreferenceRow preference = requirePreference(userId);
        List<String> allBankSubjects = PracticeSubjectMap.bankSubjectsFromSelectionJson(
                preference.getSubjectSelectionJson());
        if (allBankSubjects.isEmpty()) {
            throw new BadRequestException("当前备考科目暂无题库覆盖，请调整备考设置");
        }

        List<String> targetSubjects = resolveResetSubjects(scope, subject, allBankSubjects);
        List<Long> questionIds = questionMapper.selectList(
                new LambdaQueryWrapper<Question>()
                        .in(Question::getSubject, targetSubjects)
                        .select(Question::getId)
        ).stream().map(Question::getId).toList();

        int cleared = 0;
        if (!questionIds.isEmpty()) {
            cleared = userQuestionRecordMapper.delete(
                    new LambdaQueryWrapper<UserQuestionRecord>()
                            .eq(UserQuestionRecord::getUserId, userId)
                            .in(UserQuestionRecord::getQuestionId, questionIds)
            );
        }

        String day = LocalDate.now().format(DAY_FMT);
        for (String bankSubject : targetSubjects) {
            stringRedisTemplate.delete(randomDoneKey(userId, day, bankSubject));
        }

        RandomResetVO vo = new RandomResetVO();
        vo.setSubjects(targetSubjects);
        vo.setClearedRecordCount(cleared);
        return vo;
    }

    private List<String> resolveResetSubjects(String scope, String subject, List<String> allBankSubjects) {
        if (RESET_SCOPE_SINGLE.equalsIgnoreCase(StrUtil.blankToDefault(scope, ""))) {
            if (StrUtil.isBlank(subject)) {
                throw new BadRequestException("请指定要重刷的科目");
            }
            String single = subject.trim();
            if (!allBankSubjects.contains(single)) {
                throw new BadRequestException("科目不在备考范围内");
            }
            return List.of(single);
        }
        if (!RESET_SCOPE_ALL.equalsIgnoreCase(StrUtil.blankToDefault(scope, ""))) {
            throw new BadRequestException("scope 须为 all 或 single");
        }
        return allBankSubjects;
    }

    private Map<Long, UserQuestionRecord> loadRecordMap(Long userId, Set<Long> questionIds) {
        if (questionIds.isEmpty()) {
            return Collections.emptyMap();
        }
        List<UserQuestionRecord> records = userQuestionRecordMapper.selectList(
                new LambdaQueryWrapper<UserQuestionRecord>()
                        .eq(UserQuestionRecord::getUserId, userId)
                        .in(UserQuestionRecord::getQuestionId, questionIds)
        );
        if (records == null || records.isEmpty()) {
            return Collections.emptyMap();
        }
        return records.stream()
                .collect(Collectors.toMap(UserQuestionRecord::getQuestionId, Function.identity(), (a, b) -> a));
    }

    /** 错题池每题放入 3 份权重，提高被抽中概率。 */
    private Long weightedPick(List<Long> wrongPool, List<Long> reviewPool, List<Long> newPool) {
        List<Long> weighted = new ArrayList<>();
        for (Long id : wrongPool) {
            weighted.add(id);
            weighted.add(id);
            weighted.add(id);
        }
        weighted.addAll(reviewPool);
        weighted.addAll(newPool);
        if (weighted.isEmpty()) {
            return null;
        }
        return weighted.get(ThreadLocalRandom.current().nextInt(weighted.size()));
    }

    private int intervalForRightCount(int rightCount) {
        int index = Math.max(0, rightCount - 1);
        if (index >= REVIEW_INTERVALS.length) {
            return REVIEW_INTERVALS[REVIEW_INTERVALS.length - 1];
        }
        return REVIEW_INTERVALS[index];
    }

    /** 合并多科目当日已做题目 ID（按科 Redis Set）。 */
    private Set<Long> loadTodayDone(Long userId, String day, List<String> subjects) {
        Set<Long> done = new HashSet<>();
        for (String subject : subjects) {
            String key = randomDoneKey(userId, day, subject);
            Set<String> members = stringRedisTemplate.opsForSet().members(key);
            if (members == null) {
                continue;
            }
            for (String member : members) {
                if (StrUtil.isNotBlank(member)) {
                    done.add(Long.valueOf(member));
                }
            }
        }
        return done;
    }

    private void markTodayDone(Long userId, String subject, Long questionId) {
        String day = LocalDate.now().format(DAY_FMT);
        String key = randomDoneKey(userId, day, subject);
        stringRedisTemplate.opsForSet().add(key, String.valueOf(questionId));
        stringRedisTemplate.expire(key, Duration.ofSeconds(secondsUntilTomorrow()));
    }

    private static String randomDoneKey(Long userId, String day, String subject) {
        return PracticeRedisConstants.RANDOM_DONE_PREFIX + userId + ":" + day + ":" + subject;
    }

    private static long secondsUntilTomorrow() {
        LocalDateTime tomorrowStart = LocalDateTime.of(LocalDate.now().plusDays(1), LocalTime.MIDNIGHT);
        long seconds = Duration.between(LocalDateTime.now(), tomorrowStart).getSeconds();
        return Math.max(seconds, 1L);
    }
}
