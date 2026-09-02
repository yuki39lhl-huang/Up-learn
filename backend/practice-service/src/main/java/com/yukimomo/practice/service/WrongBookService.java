package com.yukimomo.practice.service;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.PageQuery;
import com.yukimomo.practice.dto.AddWrongBookDTO;
import com.yukimomo.practice.vo.WrongQuestionVO;

/**
 * 手动错题本：与间隔复习调度 {@code user_question_record} 解耦。
 */
public interface WrongBookService {

    PageDTO<WrongQuestionVO> list(PageQuery query, String date, String subject);

    WrongQuestionVO add(AddWrongBookDTO dto);

    WrongQuestionVO get(Long id);

    void delete(Long id);

    /** 按可选日期、科目批量删除；参数为空时不限该维度。 */
    int deleteAll(String date, String subject);

    boolean exists(Long userId, Long questionId);
}
