package com.yukimomo.practice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.practice.entity.UserExamPreferenceRow;
import org.apache.ibatis.annotations.Mapper;

/** 只读访问 {@code user_exam_preference}，供随机刷题读备考与筛选。 */
@Mapper
public interface UserExamPreferenceRowMapper extends BaseMapper<UserExamPreferenceRow> {
}
