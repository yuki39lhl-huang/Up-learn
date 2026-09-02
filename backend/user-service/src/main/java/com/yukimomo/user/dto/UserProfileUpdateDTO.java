package com.yukimomo.user.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 修改用户资料（昵称 / 头像 URL）。
 */
@Data
public class UserProfileUpdateDTO {

    @Size(max = 32, message = "昵称不能超过 32 个字符")
    private String nickname;

    @Size(max = 512, message = "头像地址过长")
    private String avatarUrl;
}
