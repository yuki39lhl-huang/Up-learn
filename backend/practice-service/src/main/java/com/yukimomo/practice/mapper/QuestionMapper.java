package com.yukimomo.practice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.practice.entity.Question;
import org.apache.ibatis.annotations.Mapper;

/**
 * 题库表 Mapper。
 * <p>
 * 继承 {@link BaseMapper} 即有 CRUD；随机抽题在 Service 里用
 * {@code last("ORDER BY RAND() LIMIT 1")}，不必写自定义 SQL。
 */
@Mapper
public interface QuestionMapper extends BaseMapper<Question> {
}
