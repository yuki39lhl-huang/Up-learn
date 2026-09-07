package com.yukimomo.school.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.school.convert.SyllabusConvert;
import com.yukimomo.school.entity.Syllabus;
import com.yukimomo.school.mapper.SyllabusMapper;
import com.yukimomo.school.service.SyllabusService;
import com.yukimomo.school.vo.SyllabusOptionsVO;
import com.yukimomo.school.vo.SyllabusVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 考纲查询实现。
 */
@Service
@RequiredArgsConstructor
public class SyllabusServiceImpl implements SyllabusService {

    /** 一期固定开放的省份（山东可暂无正文） */
    private static final List<String> SUPPORTED_PROVINCES = List.of("广东", "山东");

    private final SyllabusMapper syllabusMapper;

    @Override
    public SyllabusOptionsVO getOptions() {
        List<Syllabus> rows = syllabusMapper.selectList(
                new LambdaQueryWrapper<Syllabus>()
                        .select(Syllabus::getProvince, Syllabus::getYear, Syllabus::getSubject)
                        .orderByAsc(Syllabus::getProvince)
                        .orderByDesc(Syllabus::getYear)
                        .orderByAsc(Syllabus::getSubject));

        SyllabusOptionsVO vo = new SyllabusOptionsVO();
        vo.setProvinces(SUPPORTED_PROVINCES);
        vo.setItems(rows.stream().map(SyllabusConvert::toOptionItem).toList());
        return vo;
    }

    @Override
    public SyllabusVO getDetail(String province, Integer year, String subject) {
        if (!StringUtils.hasText(province)) {
            throw new BadRequestException("省份不能为空");
        }
        if (year == null) {
            throw new BadRequestException("年份不能为空");
        }
        if (!StringUtils.hasText(subject)) {
            throw new BadRequestException("科目不能为空");
        }

        Syllabus entity = syllabusMapper.selectOne(new LambdaQueryWrapper<Syllabus>()
                .eq(Syllabus::getProvince, province.trim())
                .eq(Syllabus::getYear, year)
                .eq(Syllabus::getSubject, subject.trim())
                .last("LIMIT 1"));
        if (entity == null) {
            return null;
        }
        return SyllabusConvert.toDetail(entity);
    }
}
