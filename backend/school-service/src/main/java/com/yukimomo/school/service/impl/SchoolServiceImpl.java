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
import java.util.Comparator;
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
        //三元判断，如果query为null，则new一个SchoolQuery对象反之则赋值给q,防止npe异常
        SchoolQuery q = query == null ? new SchoolQuery() : query;
        Set<Long> schoolIdsByMajorFilter = resolveSchoolIdsByMajorFilter(q);
        //如果schoolIdsByMajorFilter不为null且为空，则返回空分页结果
        if (schoolIdsByMajorFilter != null && schoolIdsByMajorFilter.isEmpty()) {
            return PageDTO.empty();
        }
        //创建一个LambdaQueryWrapper对象，用于构建查询条件
        LambdaQueryWrapper<School> wrapper = new LambdaQueryWrapper<>();
        //如果q.getKw()不为空，则添加like查询条件，查询院校名称中包含q.getKw().trim()的记录
        if (StringUtils.hasText(q.getKw())) {
            wrapper.like(School::getName, q.getKw().trim());
        }
        if (StringUtils.hasText(q.getProvince())) {
            wrapper.eq(School::getProvince, q.getProvince().trim());
        }
        if (StringUtils.hasText(q.getType())) {
            wrapper.eq(School::getType, q.getType().trim());
        }
        if (schoolIdsByMajorFilter != null) {
            wrapper.in(School::getId, schoolIdsByMajorFilter);
        }
        // 优先公办：排序靠前，不排除民办
        if (Boolean.TRUE.equals(q.getPreferPublic())) {
            wrapper.orderByDesc(School::getPreferPublic);
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
    public List<MajorVO> listMajorsBySchoolId(Long schoolId, Long majorDictId, String majorCategory) {
        School school = schoolMapper.selectById(schoolId);
        if (school == null) {
            throw new BizException(ErrorCode.SCHOOL_NOT_FOUND);
        }
        List<SchoolMajor> offerings = schoolMajorMapper.selectList(new LambdaQueryWrapper<SchoolMajor>()
                .eq(SchoolMajor::getSchoolId, schoolId)
                .orderByAsc(SchoolMajor::getId));
        List<MajorVO> list = toMajorVoList(offerings);
        return sortMajorsByRelevance(list, majorDictId, majorCategory);
    }

    /** 相关度：精确专业 > 同专业类 > 其余；同档按名称 */
    private List<MajorVO> sortMajorsByRelevance(List<MajorVO> list, Long majorDictId, String majorCategory) {
        if (list.isEmpty()) {
            return list;
        }
        boolean hasDict = majorDictId != null;
        boolean hasCategory = StringUtils.hasText(majorCategory);
        if (!hasDict && !hasCategory) {
            return list.stream()
                    .sorted(Comparator.comparing(MajorVO::getName, Comparator.nullsLast(String::compareTo)))
                    .toList();
        }
        String category = hasCategory ? majorCategory.trim() : null;
        Long dictId = majorDictId;
        return list.stream()
                .sorted(Comparator
                        .comparingInt((MajorVO m) -> relevanceRank(m, dictId, category))
                        .thenComparing(MajorVO::getName, Comparator.nullsLast(String::compareTo)))
                .toList();
    }

    private static int relevanceRank(MajorVO major, Long majorDictId, String majorCategory) {
        if (majorDictId != null && majorDictId.equals(major.getMajorDictId())) {
            return 0;
        }
        if (majorCategory != null && majorCategory.equals(major.getMajorCategory())) {
            return 1;
        }
        return 2;
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
        //将query赋值给变量q，如果query为null，则new一个MajorOptionQuery对象反之则赋值给q
        MajorOptionQuery q = query == null ? new MajorOptionQuery() : query;
        //创建一个LambdaQueryWrapper对象，用于构建查询条件
        LambdaQueryWrapper<MajorDict> wrapper = new LambdaQueryWrapper<>();
        //如果q.getKw()不为空，则添加like查询条件，查询专业名称中包含q.getKw().trim()的记录
        if (StringUtils.hasText(q.getKw())) {
            wrapper.like(MajorDict::getName, q.getKw().trim());
        }
        if (StringUtils.hasText(q.getMajorCategory())) {
            wrapper.eq(MajorDict::getMajorCategory, q.getMajorCategory().trim());
        }
        wrapper.orderByAsc(MajorDict::getName).orderByAsc(MajorDict::getId);

        Page<MajorDict> page = majorDictMapper.selectPage(q.toMpPage(), wrapper);
        //将查询结果转换为MajorOptionVO列表
        List<MajorOptionVO> list = page.getRecords().stream()
                .map(SchoolConvert::toMajorOptionVO)
                .toList();

        PageDTO<MajorOptionVO> dto = new PageDTO<>();
        //设置总记录数
        dto.setTotal(page.getTotal());
        //设置总页数
        dto.setPages(page.getPages());
        //设置列表
        dto.setList(list);
        return dto;
    }

    @Override
    public List<String> listMajorCategories() {
        List<MajorDict> dicts = majorDictMapper.selectList(new LambdaQueryWrapper<MajorDict>()
                .select(MajorDict::getMajorCategory)
                .isNotNull(MajorDict::getMajorCategory)
                .orderByAsc(MajorDict::getMajorCategory));
        return dicts.stream()
                .map(MajorDict::getMajorCategory)
                .filter(StringUtils::hasText)
                .distinct()
                .toList();
    }

    /**
     * 根据 majorDictId / year / majorCategory 从 school_major 反查 school_id。
     *
     * @return null 表示无专业相关条件；空 Set 表示无匹配院校
     */
    private Set<Long> resolveSchoolIdsByMajorFilter(SchoolQuery q) {
        //如果专业字典id不为null，则设置filterDictId为true，否则为false
        boolean filterDictId = q.getMajorDictId() != null;
        //如果招生年份不为null，则设置filterYear为true，否则为false
        boolean filterYear = q.getYear() != null;
        //只要专业类别不为空，则设置filterCategory为true，否则为false
        boolean filterCategory = StringUtils.hasText(q.getMajorCategory());
        //如果filterDictId、filterYear、filterCategory都为false，则返回null
        if (!filterDictId && !filterYear && !filterCategory) {
            return null;
        }

        // 仅有专业类、无 dictId：先把类别下所有词典 id 查出来
        Set<Long> dictIds = null;
        //专业类存在且专业字典id不存在，则查询专业字典id
        if (filterCategory && !filterDictId) {
            //创建一个LambdaQueryWrapper对象，用于构建查询条件
            List<MajorDict> dicts = majorDictMapper.selectList(new LambdaQueryWrapper<MajorDict>()
                    //如果专业类别不为空，则添加eq查询条件，查询专业类别等于q.getMajorCategory().trim()的记录
                    .eq(MajorDict::getMajorCategory, q.getMajorCategory().trim())
                    .select(MajorDict::getId));
            //如果专业字典列表为空，则返回空集合
            if (dicts.isEmpty()) {
                return Collections.emptySet();
            }
            //将专业字典列表转换为专业字典id集合
            dictIds = dicts.stream().map(MajorDict::getId).collect(Collectors.toSet());
        }

        //创建一个LambdaQueryWrapper对象，用于构建查询条件
        LambdaQueryWrapper<SchoolMajor> wrapper = new LambdaQueryWrapper<>();
        //如果专业字典id不为null，则添加eq查询条件，查询专业字典id等于q.getMajorDictId()的记录
        if (filterDictId) {
            wrapper.eq(SchoolMajor::getMajorDictId, q.getMajorDictId());
        } else if (dictIds != null) {
            //如果专业字典id集合不为null，则添加in查询条件，查询专业字典id在dictIds集合中的记录
            wrapper.in(SchoolMajor::getMajorDictId, dictIds);
        }
        if (filterYear) {
            wrapper.eq(SchoolMajor::getYear, q.getYear());
        }
        //查询学校专业列表
        List<SchoolMajor> offerings = schoolMajorMapper.selectList(wrapper.select(SchoolMajor::getSchoolId));
        //如果学校专业列表为空，则返回空集合
        if (offerings.isEmpty()) {
            return Collections.emptySet();
        }
        //将学校专业列表转换为学校id集合
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
        //收集要查的字典id集合
        Set<Long> dictIds = offerings.stream()
                .map(SchoolMajor::getMajorDictId)//取出每一个学校专业对象的majorDictId
                .filter(Objects::nonNull)//过滤掉null值
                .collect(Collectors.toSet());//将集合转换为set集合
        //一次查出所有字典对象，并转换为map，key为字典id，value为字典对象
        Map<Long, MajorDict> dictMap = dictIds.isEmpty()
                ? Collections.emptyMap()//如果字典id集合为空，则返回空map
                : majorDictMapper.selectByIds(dictIds).stream()//查询字典对象列表
                //key是MajorDict::getId，value是Function.identity()，即MajorDict对象本身，如果key重复，则取第一个
                .collect(Collectors.toMap(MajorDict::getId, Function.identity(), (a, b) -> a));//将字典对象列表转换为map，key为字典id，value为字典对象
        //将学校专业列表转换为MajorVO列表
        return offerings.stream()
                .map(o -> SchoolConvert.toMajorVO(o, dictMap.get(o.getMajorDictId())))
                .toList();
    }
}
