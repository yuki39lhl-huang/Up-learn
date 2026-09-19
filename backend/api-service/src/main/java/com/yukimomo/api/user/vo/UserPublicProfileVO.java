package com.yukimomo.api.user.vo;

import lombok.Data;

/**
 * 社区等场景的公开用户资料（不含邮箱）。
 */
@Data
public class UserPublicProfileVO {
    private Long userId;
    private String nickname;
    private String avatarUrl;
    /** 个人简介，最多 200 字 */
    private String bio;
    /** 是否公开关注/粉丝列表 */
    private Boolean showFollowList;
    /** 备考设置省份（只读展示） */
    private String province;
    /** 备考设置专业类型（只读展示） */
    private String majorCategory;
    /** 目标院校展示文案（学校名，可选带专业） */
    private java.util.List<String> targetSchools;
}
