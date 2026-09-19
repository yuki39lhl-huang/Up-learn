package com.yukimomo.community.vo;

import lombok.Data;

@Data
public class FollowUserVO {
    private Long userId;
    private String nickname;
    private String avatarUrl;
}
