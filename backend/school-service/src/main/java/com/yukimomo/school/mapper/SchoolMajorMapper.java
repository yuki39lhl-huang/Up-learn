package com.yukimomo.school.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.school.entity.SchoolMajor;
import org.apache.ibatis.annotations.Mapper;

/**
 * 院校开设专业表 {@code school_major} Mapper。
 * <p>
 * 用于某校专业列表、开设详情、以及按 majorDictId 反查 schoolId；继承 {@link BaseMapper}。
 */
@Mapper
public interface SchoolMajorMapper extends BaseMapper<SchoolMajor> {
}
