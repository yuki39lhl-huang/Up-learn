package com.yukimomo.user.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.user.entity.UserExamPreference;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户备考设置 Mapper。
 */
@Mapper
public interface UserExamPreferenceMapper extends BaseMapper<UserExamPreference> {
}
