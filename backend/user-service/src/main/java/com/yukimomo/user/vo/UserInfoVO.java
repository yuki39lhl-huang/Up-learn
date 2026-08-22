package com.yukimomo.user.vo;

import lombok.Data;

@Data
public class UserInfoVO {

    private Long userId;
    private String email;
    private String nickname;
    private String avatarUrl;
}
