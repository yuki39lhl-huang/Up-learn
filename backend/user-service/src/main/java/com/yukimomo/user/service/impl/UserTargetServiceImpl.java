package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.user.dto.AddUserTargetDTO;
import com.yukimomo.user.entity.MajorDictRow;
import com.yukimomo.user.entity.SchoolMajorRow;
import com.yukimomo.user.entity.SchoolRow;
import com.yukimomo.user.entity.UserTarget;
import com.yukimomo.user.mapper.MajorDictRowMapper;
import com.yukimomo.user.mapper.SchoolMajorRowMapper;
import com.yukimomo.user.mapper.SchoolRowMapper;
import com.yukimomo.user.mapper.UserTargetMapper;
import com.yukimomo.user.service.UserTargetService;
import com.yukimomo.user.vo.UserTargetVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserTargetServiceImpl implements UserTargetService {

    private final UserTargetMapper userTargetMapper;
    private final SchoolRowMapper schoolRowMapper;
    private final SchoolMajorRowMapper schoolMajorRowMapper;
    private final MajorDictRowMapper majorDictRowMapper;

    @Override
    @Transactional(readOnly = true)
    public List<UserTargetVO> list(Long userId) {
        List<UserTarget> rows = userTargetMapper.selectList(
                new LambdaQueryWrapper<UserTarget>()
                        .eq(UserTarget::getUserId, userId)
                        .orderByDesc(UserTarget::getCreatedAt)
        );
        if (rows.isEmpty()) {
            return List.of();
        }
        return toVoList(rows);
    }

    @Override
    @Transactional
    public UserTargetVO add(Long userId, AddUserTargetDTO dto) {
        SchoolRow school = schoolRowMapper.selectById(dto.getSchoolId());
        if (school == null) {
            throw new BadRequestException("院校不存在");
        }

        Long majorId = dto.getMajorId();
        if (majorId != null) {
            SchoolMajorRow major = schoolMajorRowMapper.selectById(majorId);
            if (major == null) {
                throw new BadRequestException("开设专业不存在");
            }
            if (!Objects.equals(major.getSchoolId(), dto.getSchoolId())) {
                throw new BadRequestException("专业不属于该院校");
            }
        }

        if (existsTarget(userId, dto.getSchoolId(), majorId)) {
            throw new BadRequestException("已在目标列表中");
        }

        UserTarget row = new UserTarget();
        row.setUserId(userId);
        row.setSchoolId(dto.getSchoolId());
        row.setMajorId(majorId);
        userTargetMapper.insert(row);
        return toVo(row, school, resolveMajor(majorId));
    }

    @Override
    @Transactional
    public void remove(Long userId, Long id) {
        UserTarget row = userTargetMapper.selectById(id);
        if (row == null || !Objects.equals(row.getUserId(), userId)) {
            throw new BadRequestException("目标不存在");
        }
        userTargetMapper.deleteById(id);
    }

    private boolean existsTarget(Long userId, Long schoolId, Long majorId) {
        LambdaQueryWrapper<UserTarget> wrapper = new LambdaQueryWrapper<UserTarget>()
                .eq(UserTarget::getUserId, userId)
                .eq(UserTarget::getSchoolId, schoolId);
        if (majorId == null) {
            wrapper.isNull(UserTarget::getMajorId);
        } else {
            wrapper.eq(UserTarget::getMajorId, majorId);
        }
        return userTargetMapper.selectCount(wrapper) > 0;
    }

    private List<UserTargetVO> toVoList(List<UserTarget> rows) {
        Set<Long> schoolIds = rows.stream().map(UserTarget::getSchoolId).collect(Collectors.toSet());
        Map<Long, SchoolRow> schoolMap = schoolIds.isEmpty()
                ? Collections.emptyMap()
                : schoolRowMapper.selectBatchIds(schoolIds).stream()
                .collect(Collectors.toMap(SchoolRow::getId, Function.identity(), (a, b) -> a));

        Set<Long> majorIds = rows.stream()
                .map(UserTarget::getMajorId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, SchoolMajorRow> majorMap = loadMajorMap(majorIds);
        Set<Long> dictIds = majorMap.values().stream()
                .map(SchoolMajorRow::getMajorDictId)
                .collect(Collectors.toSet());
        Map<Long, MajorDictRow> dictMap = loadDictMap(dictIds);

        return rows.stream()
                .map(row -> {
                    SchoolRow school = schoolMap.get(row.getSchoolId());
                    MajorContext majorCtx = buildMajorContext(row.getMajorId(), majorMap, dictMap);
                    return toVo(row, school, majorCtx);
                })
                .toList();
    }

    private UserTargetVO toVo(UserTarget row, SchoolRow school, MajorContext majorCtx) {
        UserTargetVO vo = new UserTargetVO();
        vo.setId(row.getId());
        vo.setUserId(row.getUserId());
        vo.setSchoolId(row.getSchoolId());
        vo.setMajorId(row.getMajorId());
        vo.setCreatedAt(row.getCreatedAt());
        if (school != null) {
            vo.setSchoolName(school.getName());
            vo.setSchoolProvince(school.getProvince());
            vo.setSchoolCity(school.getCity());
            vo.setSchoolType(school.getType());
        }
        if (majorCtx != null) {
            vo.setMajorName(majorCtx.name());
            vo.setMajorCategory(majorCtx.category());
        }
        return vo;
    }

    private MajorContext resolveMajor(Long majorId) {
        if (majorId == null) {
            return null;
        }
        SchoolMajorRow major = schoolMajorRowMapper.selectById(majorId);
        if (major == null) {
            return null;
        }
        MajorDictRow dict = majorDictRowMapper.selectById(major.getMajorDictId());
        if (dict == null) {
            return null;
        }
        return new MajorContext(dict.getName(), dict.getMajorCategory());
    }

    private Map<Long, SchoolMajorRow> loadMajorMap(Set<Long> majorIds) {
        if (majorIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return schoolMajorRowMapper.selectBatchIds(majorIds).stream()
                .collect(Collectors.toMap(SchoolMajorRow::getId, Function.identity(), (a, b) -> a));
    }

    private Map<Long, MajorDictRow> loadDictMap(Set<Long> dictIds) {
        if (dictIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return majorDictRowMapper.selectBatchIds(dictIds).stream()
                .collect(Collectors.toMap(MajorDictRow::getId, Function.identity(), (a, b) -> a));
    }

    private MajorContext buildMajorContext(
            Long majorId,
            Map<Long, SchoolMajorRow> majorMap,
            Map<Long, MajorDictRow> dictMap
    ) {
        if (majorId == null) {
            return null;
        }
        SchoolMajorRow major = majorMap.get(majorId);
        if (major == null) {
            return null;
        }
        MajorDictRow dict = dictMap.get(major.getMajorDictId());
        if (dict == null) {
            return null;
        }
        return new MajorContext(dict.getName(), dict.getMajorCategory());
    }

    private record MajorContext(String name, String category) {
    }
}
