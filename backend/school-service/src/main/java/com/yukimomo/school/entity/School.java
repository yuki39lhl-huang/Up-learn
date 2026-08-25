package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 院校表 {@code school} 实体。
 */
@Data
@TableName("school")
public class School {

    @TableId(type = IdType.AUTO)
    private Long id;
    /** 院校名称 */
    private String name;
    /** 省份，如广东 */
    private String province;
    /** 城市 */
    private String city;
    /** 办学类型：公办/民办等 */
    private String type;
    /** 展示标签，如 211、省属重点 */
    @TableField("type_tag")
    private String typeTag;
    /** 是否公办：1 是，0 否（便于 preferPublic 筛选） */
    @TableField("prefer_public")
    private Integer preferPublic;
    /** 专业数量（汇总展示） */
    @TableField("major_count")
    private Integer majorCount;
    /** 招生人数（汇总或最新） */
    private Integer enrollment;
    /** 学费（元/年，展示用） */
    private Integer tuition;
    /** 最低分（最新或默认年） */
    @TableField("min_score")
    private Integer minScore;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
