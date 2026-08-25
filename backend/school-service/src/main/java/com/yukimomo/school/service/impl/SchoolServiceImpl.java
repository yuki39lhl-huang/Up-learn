package com.yukimomo.school.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.school.convert.SchoolConvert;
import com.yukimomo.school.dto.MajorOptionQuery;
import com.yukimomo.school.dto.SchoolQuery;
import com.yukimomo.school.entity.MajorDict;
import com.yukimomo.school.entity.School;
import com.yukimomo.school.entity.SchoolMajor;
import com.yukimomo.school.mapper.MajorDictMapper;
import com.yukimomo.school.mapper.SchoolMajorMapper;
import com.yukimomo.school.mapper.SchoolMapper;
import com.yukimomo.school.service.SchoolService;
import com.yukimomo.school.vo.MajorOptionVO;
import com.yukimomo.school.vo.MajorVO;
import com.yukimomo.school.vo.SchoolVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * {@link SchoolService} 实现。
 */
@Service
@RequiredArgsConstructor
public class SchoolServiceImpl implements SchoolService {

    private final SchoolMapper schoolMapper;
    private final MajorDictMapper majorDictMapper;
    private final SchoolMajorMapper schoolMajorMapper;

    /**
     * 组装院校条件并分页；若有专业相关筛选，先经 {@link #resolveSchoolIdsByMajorFilter} 得到 schoolId 集合。
     */
    @Override
    public PageDTO<SchoolVO> listSchools(SchoolQuery query) {
        SchoolQuery q = query == null ? new SchoolQuery() : query;

        Set<Long> schoolIdsByMajorFilter = resolveSchoolIdsByMajorFilter(q);
        if (schoolIdsByMajorFilter != null && schoolIdsByMajorFilter.isEmpty()) {
            return PageDTO.empty();
        }

        LambdaQueryWrapper<School> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(q.getKw())) {
            wrapper.like(School::getName, q.getKw().trim());
        }
        if (StringUtils.hasText(q.getProvince())) {
            wrapper.eq(School::getProvince, q.getProvince().trim());
        }
        if (StringUtils.hasText(q.getType())) {
            wrapper.eq(School::getType, q.getType().trim());
        }
        if (Boolean.TRUE.equals(q.getPreferPublic())) {
            wrapper.eq(School::getPreferPublic, 1);
        }
        if (schoolIdsByMajorFilter != null) {
            wrapper.in(School::getId, schoolIdsByMajorFilter);
        }
        wrapper.orderByAsc(School::getId);

        Page<School> page = schoolMapper.selectPage(q.toMpPage(), wrapper);
        List<SchoolVO> list = page.getRecords().stream()
                .map(SchoolConvert::toSchoolVO)
                .toList();

        PageDTO<SchoolVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    /** 按 school.id 查院校；不存在抛 SCHOOL_NOT_FOUND。 */
    @Override
    public SchoolVO getSchool(Long id) {
        School school = schoolMapper.selectById(id);
        if (school == null) {
            throw new BizException(ErrorCode.SCHOOL_NOT_FOUND);
        }
        return SchoolConvert.toSchoolVO(school);
    }

    /** 校验院校存在后，查该校全部 school_major 并填充词典名称。 */
    @Override
    public List<MajorVO> listMajorsBySchoolId(Long schoolId) {
        School school = schoolMapper.selectById(schoolId);
        if (school == null) {
            throw new BizException(ErrorCode.SCHOOL_NOT_FOUND);
        }
        List<SchoolMajor> offerings = schoolMajorMapper.selectList(new LambdaQueryWrapper<SchoolMajor>()
                .eq(SchoolMajor::getSchoolId, schoolId)
                .orderByAsc(SchoolMajor::getId));
        return toMajorVoList(offerings);
    }

    /** 按 school_major.id 查开设详情，并关联 major_dict 取名称/类别。 */
    @Override
    public MajorVO getSchoolMajor(Long schoolMajorId) {
        SchoolMajor offering = schoolMajorMapper.selectById(schoolMajorId);
        if (offering == null) {
            throw new BizException(ErrorCode.MAJOR_NOT_FOUND);
        }
        MajorDict dict = majorDictMapper.selectById(offering.getMajorDictId());
        return SchoolConvert.toMajorVO(offering, dict);
    }

    /** 分页查 major_dict；kw 有值则名称模糊，供 Combobox。 */
    @Override
    public PageDTO<MajorOptionVO> listMajorOptions(MajorOptionQuery query) {
        MajorOptionQuery q = query == null ? new MajorOptionQuery() : query;
        LambdaQueryWrapper<MajorDict> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(q.getKw())) {
            wrapper.like(MajorDict::getName, q.getKw().trim());
        }
        wrapper.orderByAsc(MajorDict::getName).orderByAsc(MajorDict::getId);

        Page<MajorDict> page = majorDictMapper.selectPage(q.toMpPage(), wrapper);
        List<MajorOptionVO> list = page.getRecords().stream()
                .map(SchoolConvert::toMajorOptionVO)
                .toList();

        PageDTO<MajorOptionVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    /**
     * 根据 majorDictId / year / majorCategory 从 school_major 反查 school_id。
     *
     * @return null 表示无专业相关条件；空 Set 表示无匹配院校
     */
    private Set<Long> resolveSchoolIdsByMajorFilter(SchoolQuery q) {
        boolean filterDictId = q.getMajorDictId() != null;
        boolean filterYear = q.getYear() != null;
        boolean filterCategory = StringUtils.hasText(q.getMajorCategory());
        if (!filterDictId && !filterYear && !filterCategory) {
            return null;
        }

        // 仅有专业类、无 dictId：先把类别下所有词典 id 查出来
        Set<Long> dictIds = null;
        if (filterCategory && !filterDictId) {
            List<MajorDict> dicts = majorDictMapper.selectList(new LambdaQueryWrapper<MajorDict>()
                    .eq(MajorDict::getMajorCategory, q.getMajorCategory().trim())
                    .select(MajorDict::getId));
            if (dicts.isEmpty()) {
                return Collections.emptySet();
            }
            dictIds = dicts.stream().map(MajorDict::getId).collect(Collectors.toSet());
        }

        LambdaQueryWrapper<SchoolMajor> wrapper = new LambdaQueryWrapper<>();
        if (filterDictId) {
            wrapper.eq(SchoolMajor::getMajorDictId, q.getMajorDictId());
        } else if (dictIds != null) {
            wrapper.in(SchoolMajor::getMajorDictId, dictIds);
        }
        if (filterYear) {
            wrapper.eq(SchoolMajor::getYear, q.getYear());
        }
        List<SchoolMajor> offerings = schoolMajorMapper.selectList(wrapper.select(SchoolMajor::getSchoolId));
        if (offerings.isEmpty()) {
            return Collections.emptySet();
        }
        return offerings.stream()
                .map(SchoolMajor::getSchoolId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    /**
     * 批量加载词典，把开设列表转成带 name/category 的 MajorVO。
     */
    private List<MajorVO> toMajorVoList(List<SchoolMajor> offerings) {
        if (offerings.isEmpty()) {
            return List.of();
        }
        Set<Long> dictIds = offerings.stream()
                .map(SchoolMajor::getMajorDictId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, MajorDict> dictMap = dictIds.isEmpty()
                ? Collections.emptyMap()
                : majorDictMapper.selectByIds(dictIds).stream()
                .collect(Collectors.toMap(MajorDict::getId, Function.identity(), (a, b) -> a));
        return offerings.stream()
                .map(o -> SchoolConvert.toMajorVO(o, dictMap.get(o.getMajorDictId())))
                .toList();
    }
}
