package com.yukimomo.practice.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yukimomo.practice.entity.StudyStats;
import org.apache.ibatis.annotations.Mapper;

/**
 * 学习统计 Mapper：每用户一行，按 user_id 查/插/改。
 */
@Mapper
public interface StudyStatsMapper extends BaseMapper<StudyStats> {
}
