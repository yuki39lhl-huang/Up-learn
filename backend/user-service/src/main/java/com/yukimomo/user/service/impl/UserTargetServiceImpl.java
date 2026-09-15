package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.api.school.vo.SchoolMajorVO;
import com.yukimomo.api.school.vo.SchoolVO;
import com.yukimomo.api.user.vo.UserTargetVO;
import com.yukimomo.common.exception.BadRequestException;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.user.client.SchoolCatalogClient;
import com.yukimomo.user.dto.AddUserTargetDTO;
import com.yukimomo.user.entity.UserTarget;
import com.yukimomo.user.mapper.UserTargetMapper;
import com.yukimomo.user.service.UserTargetService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 目标院校服务：院校/专业信息经 Feign 取自 school-service，user 域不直读 school 域表。
 */
@Service
@RequiredArgsConstructor
public class UserTargetServiceImpl implements UserTargetService {

    private final UserTargetMapper userTargetMapper;
    private final SchoolCatalogClient schoolCatalogClient;

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
        SchoolVO school = schoolCatalogClient.findSchool(dto.getSchoolId());
        if (school == null) {
            throw new BizException(ErrorCode.SCHOOL_NOT_FOUND);
        }

        Long majorId = dto.getMajorId();
        SchoolMajorVO major = null;
        if (majorId != null) {
            major = schoolCatalogClient.listMajors(dto.getSchoolId()).stream()
                    .filter(m -> Objects.equals(m.getId(), majorId))
                    .findFirst()
                    .orElseThrow(() -> new BizException(ErrorCode.MAJOR_NOT_FOUND, "开设专业不存在或不属于该院校"));
        }

        if (existsTarget(userId, dto.getSchoolId(), majorId)) {
            throw new BadRequestException("已在目标列表中");
        }

        UserTarget row = new UserTarget();
        row.setUserId(userId);
        row.setSchoolId(dto.getSchoolId());
        row.setMajorId(majorId);
        userTargetMapper.insert(row);
        return toVo(row, school, major);
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

    /** 按院校聚合远程查询：每校一次详情，含专业目标的院校再取一次专业列表。 */
    private List<UserTargetVO> toVoList(List<UserTarget> rows) {
        Set<Long> schoolIds = rows.stream().map(UserTarget::getSchoolId).collect(Collectors.toSet());
        Set<Long> schoolsNeedingMajors = rows.stream()
                .filter(r -> r.getMajorId() != null)
                .map(UserTarget::getSchoolId)
                .collect(Collectors.toSet());

        Map<Long, SchoolVO> schoolMap = new HashMap<>();
        Map<Long, SchoolMajorVO> majorMap = new HashMap<>();
        for (Long schoolId : schoolIds) {
            SchoolVO school = schoolCatalogClient.findSchool(schoolId);
            if (school != null) {
                schoolMap.put(schoolId, school);
            }
            if (schoolsNeedingMajors.contains(schoolId)) {
                for (SchoolMajorVO m : schoolCatalogClient.listMajors(schoolId)) {
                    majorMap.putIfAbsent(m.getId(), m);
                }
            }
        }

        return rows.stream()
                .map(row -> toVo(row, schoolMap.get(row.getSchoolId()),
                        row.getMajorId() == null ? null : majorMap.get(row.getMajorId())))
                .toList();
    }

    private UserTargetVO toVo(UserTarget row, SchoolVO school, SchoolMajorVO major) {
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
        if (major != null) {
            vo.setMajorName(major.getName());
            vo.setMajorCategory(major.getMajorCategory());
        }
        return vo;
    }
}
