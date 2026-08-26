package com.yukimomo.practice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.practice.entity.AnswerRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * 作答历史 Mapper：提交时 insert；历史列表按 user_id + created_at 分页查询。
 */
@Mapper
public interface AnswerRecordMapper extends BaseMapper<AnswerRecord> {
}
