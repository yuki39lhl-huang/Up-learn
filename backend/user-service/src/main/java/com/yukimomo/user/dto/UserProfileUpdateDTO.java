package com.yukimomo.user.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 修改用户资料（昵称 / 头像 / 简介 / 关注列表可见性）。
 */
@Data
public class UserProfileUpdateDTO {

    @Size(max = 32, message = "昵称不能超过 32 个字符")
    private String nickname;

    @Size(max = 512, message = "头像地址过长")
    private String avatarUrl;

    @Size(max = 200, message = "简介不能超过 200 个字符")
    private String bio;

    /** 是否公开关注/粉丝列表；null 表示不修改 */
    private Boolean showFollowList;
}
