package com.yukimomo.school.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.school.entity.MajorDict;
import org.apache.ibatis.annotations.Mapper;

/**
 * 专业词典表 {@code major_dict} Mapper。
 * <p>
 * 用于 Combobox 选项分页 / 模糊查询；继承 {@link BaseMapper}，无自定义 SQL。
 */
@Mapper
public interface MajorDictMapper extends BaseMapper<MajorDict> {
}
