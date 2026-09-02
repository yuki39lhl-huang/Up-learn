package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 院校只读投影（与 school-service 同库 {@code school} 表）。
 */
@Data
@TableName("school")
public class SchoolRow {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String province;

    private String city;

    private String type;

    @TableLogic
    private Integer deleted;
}
