package com.yukimomo.practice.service;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.practice.dto.AddPracticeNoteDTO;
import com.yukimomo.practice.vo.PracticeNoteVO;

/**
 * 随机刷题备忘录：答对后手动收藏，与错题本独立。
 */
public interface PracticeNoteService {

    PageDTO<PracticeNoteVO> list(PageQuery query, String date, String subject);

    PracticeNoteVO add(AddPracticeNoteDTO dto);

    PracticeNoteVO get(Long id);

    void delete(Long id);

    /** 按可选日期、科目批量删除；参数为空时不限该维度。 */
    int deleteAll(String date, String subject);

    boolean exists(Long userId, Long questionId);
}
