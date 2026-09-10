package com.yukimomo.practice.service;

import com.yukimomo.practice.dto.PaperSaveAnswersDTO;
import com.yukimomo.practice.vo.PaperDetailVO;
import com.yukimomo.practice.vo.PaperListItemVO;
import com.yukimomo.practice.vo.PaperOptionsVO;
import com.yukimomo.practice.vo.PaperStartVO;
import com.yukimomo.practice.vo.PaperSubmitResultVO;

import java.util.List;

public interface PaperService {

    PaperOptionsVO options();

    List<PaperListItemVO> list(String province, String subject);

    PaperDetailVO detail(Long paperId);

    PaperStartVO start(Long paperId);

    void saveAnswers(Long attemptId, PaperSaveAnswersDTO dto);

    PaperSubmitResultVO submit(Long attemptId);
}
