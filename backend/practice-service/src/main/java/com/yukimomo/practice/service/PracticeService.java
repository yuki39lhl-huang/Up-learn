package com.yukimomo.practice.service;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.vo.DailyStatusVO;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.QuestionVO;
import com.yukimomo.practice.vo.StudyStatsVO;
import com.yukimomo.practice.vo.SubmitResultVO;
import com.yukimomo.practice.vo.WrongQuestionVO;

/**
 * 刷题业务接口。
 * <p>
 * 实现类负责：Redis 每日题、随机抽题、判分写库、错题/历史分页、统计读取。
 * 用户身份一律通过 {@link com.yukimomo.common.utils.UserContext#requireUserId()} 获取。
 */
public interface PracticeService {

    /**
     * 每日一练：同一用户当天返回同一题（Redis 缓存 questionId）。
     *
     * @param subject 可选，精确科目；仅在「当天尚未缓存」时参与抽题
     */
    QuestionVO daily(String subject);

    /**
     * 每日一练当日状态：是否已完成、锁定科目、题目 id。
     */
    DailyStatusVO dailyStatus();

    /**
     * 随机刷题：每次重新抽题，不写 Redis。
     *
     * @param subject 可选精确科目
     */
    QuestionVO random(String subject);

    /**
     * 提交判分：写 answer_record；错则 upsert 错题；始终 upsert study_stats。
     *
     * @param dto questionId + userAnswer + 可选 source
     */
    SubmitResultVO submit(SubmitAnswerDTO dto);

    /**
     * 当前用户错题本分页（联表补题干）。
     */
    PageDTO<WrongQuestionVO> listWrong(PageQuery query);

    /**
     * 当前用户答题历史分页，按 created_at 倒序。
     */
    PageDTO<AnswerHistoryVO> listHistory(PageQuery query);

    /**
     * 当前用户学习统计；无库记录则返回全 0。
     */
    StudyStatsVO stats();
}
