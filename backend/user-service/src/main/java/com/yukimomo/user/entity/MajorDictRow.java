package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 专业词典只读投影（{@code major_dict} 表）。
 */
@Data
@TableName("major_dict")
public class MajorDictRow {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    /** 门类，如工学/管理学 */
    private String discipline;

    @TableField("major_category")
    private String majorCategory;

    private String code;

    @TableField("exam_track")
    private String examTrack;

    @TableLogic
    private Integer deleted;
}
