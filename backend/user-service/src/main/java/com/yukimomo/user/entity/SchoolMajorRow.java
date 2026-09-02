package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 院校开设专业只读投影（{@code school_major} 表）。
 */
@Data
@TableName("school_major")
public class SchoolMajorRow {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("school_id")
    private Long schoolId;

    @TableField("major_dict_id")
    private Long majorDictId;

    @TableLogic
    private Integer deleted;
}
