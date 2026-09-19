package com.yukimomo.community.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("community_notification")
public class CommunityNotification {
    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("user_id")
    private Long userId;
    private String type;
    @TableField("ref_id")
    private Long refId;
    @TableField("actor_id")
    private Long actorId;
    private String content;
    @TableField("read_flag")
    private Integer readFlag;
    @TableField("created_at")
    private LocalDateTime createdAt;
}
