package com.yukimomo.user.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户表 {@code user}。
 * 验证码登录且未设密时 {@code password_set=0}，{@code password_hash} 存随机占位哈希。
 */
@Data
@TableName("user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String email;
    @TableField("password_hash")
    private String passwordHash;
    /** 0 未设置登录密码；1 已设置，可用密码登录 */
    @TableField("password_set")
    private Integer passwordSet;
    private String nickname;
    @TableField("avatar_url")
    private String avatarUrl;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
