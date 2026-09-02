package com.yukimomo.practice.service;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.practice.dto.AddPracticeNoteDTO;
import com.yukimomo.practice.dto.AddWrongBookDTO;
import com.yukimomo.practice.dto.RandomResetDTO;
import com.yukimomo.practice.dto.SubmitAnswerDTO;
import com.yukimomo.practice.vo.DailyStatusVO;
import com.yukimomo.practice.vo.AnswerHistoryVO;
import com.yukimomo.practice.vo.PracticeNoteVO;
import com.yukimomo.practice.vo.QuestionVO;
import com.yukimomo.practice.vo.RandomPendingHintVO;
import com.yukimomo.practice.vo.RandomResetVO;
import com.yukimomo.practice.vo.StudyStatsVO;
import com.yukimomo.practice.vo.SubmitResultVO;
import com.yukimomo.practice.vo.WrongQuestionVO;

/**
 * 刷题业务接口。
 */
public interface PracticeService {

    QuestionVO daily(String subject);

    DailyStatusVO dailyStatus();

    QuestionVO random();

    RandomPendingHintVO randomPendingHint();

    SubmitResultVO submit(SubmitAnswerDTO dto);

    WrongQuestionVO addWrongBook(AddWrongBookDTO dto);

    WrongQuestionVO getWrongBook(Long id);

    PageDTO<WrongQuestionVO> listWrong(PageQuery query, String date, String subject);

    PracticeNoteVO addNote(AddPracticeNoteDTO dto);

    PracticeNoteVO getNote(Long id);

    PageDTO<PracticeNoteVO> listNotes(PageQuery query, String date, String subject);

    void deleteWrongBook(Long id);

    int deleteAllWrongBook(String date, String subject);

    void deleteNote(Long id);

    int deleteAllNotes(String date, String subject);

    RandomResetVO resetRandom(RandomResetDTO dto);

    /** 重置每日一练签到：清除 daily 答题记录、study_stats 与当日 Redis 缓存 */
    void resetDailyCheckIn();

    /** 备考重置：清除全部随机刷题复习进度、当日已做与答题统计 */
    void resetRandomProgress();

    PageDTO<AnswerHistoryVO> listHistory(PageQuery query);

    StudyStatsVO stats(String source);
}
