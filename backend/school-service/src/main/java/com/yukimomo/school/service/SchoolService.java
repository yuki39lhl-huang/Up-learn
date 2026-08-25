package com.yukimomo.school.service;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.school.dto.MajorOptionQuery;
import com.yukimomo.school.dto.SchoolQuery;
import com.yukimomo.school.vo.MajorOptionVO;
import com.yukimomo.school.vo.MajorVO;
import com.yukimomo.school.vo.SchoolVO;

import java.util.List;

/**
 * 院校 / 专业查询业务接口（词典 major_dict + 开设 school_major）。
 */
public interface SchoolService {

    /**
     * 院校统一分页查询。
     * kw / 省份等均可选；专业用 {@code majorDictId} 精确过滤开设该词典专业的学校。
     */
    PageDTO<SchoolVO> listSchools(SchoolQuery query);

    /**
     * 院校详情。
     *
     * @param id school.id
     * @throws com.yukimomo.common.exception.BizException 院校不存在
     */
    SchoolVO getSchool(Long id);

    /**
     * 某校开设专业列表。
     *
     * @param schoolId school.id
     * @return 每项 id 为 school_major.id（目标院校用）
     */
    List<MajorVO> listMajorsBySchoolId(Long schoolId);

    /**
     * 开设详情。
     *
     * @param schoolMajorId school_major.id
     */
    MajorVO getSchoolMajor(Long schoolMajorId);

    /**
     * 专业词典选项（Combobox）。
     * 选中后把返回的 {@code id} 作为院校 list 的 {@code majorDictId}。
     */
    PageDTO<MajorOptionVO> listMajorOptions(MajorOptionQuery query);
}
