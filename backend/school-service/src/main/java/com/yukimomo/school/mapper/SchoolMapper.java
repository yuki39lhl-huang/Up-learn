package com.yukimomo.school.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.school.entity.School;
import org.apache.ibatis.annotations.Mapper;

/**
 * 院校表 {@code school} Mapper。
 * <p>
 * 继承 {@link BaseMapper}，提供 selectById / selectPage / selectList 等基础 CRUD，本模块无自定义 SQL。
 */
@Mapper
public interface SchoolMapper extends BaseMapper<School> {
}
