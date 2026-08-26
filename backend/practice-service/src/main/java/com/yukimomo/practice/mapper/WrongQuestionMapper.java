package com.yukimomo.practice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.practice.entity.WrongQuestion;
import org.apache.ibatis.annotations.Mapper;

/**
 * 错题本 Mapper：答错 upsert；列表按 user_id 分页，再批量补题干。
 */
@Mapper
public interface WrongQuestionMapper extends BaseMapper<WrongQuestion> {
}
