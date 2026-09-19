package com.yukimomo.community.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("community_follow")
public class CommunityFollow {
    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("follower_id")
    private Long followerId;
    @TableField("followee_id")
    private Long followeeId;
    @TableField("created_at")
    private LocalDateTime createdAt;
}
