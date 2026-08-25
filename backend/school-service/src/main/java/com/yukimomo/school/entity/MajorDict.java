package com.yukimomo.school.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 专业词典表 {@code major_dict}：全局专业名，供 Combobox / 院校筛选。
 */
@Data
@TableName("major_dict")
public class MajorDict {

    @TableId(type = IdType.AUTO)
    private Long id;
    /** 专业名称（唯一） */
    private String name;
    /** 专业类，如计算机类 */
    @TableField("major_category")
    private String majorCategory;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
