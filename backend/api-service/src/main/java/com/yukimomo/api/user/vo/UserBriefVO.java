package com.yukimomo.api.user.vo;

import lombok.Data;

/** 社区等场景展示用的用户简要资料（不含邮箱）。 */
@Data
public class UserBriefVO {
    private Long userId;
    private String nickname;
    private String avatarUrl;
}
