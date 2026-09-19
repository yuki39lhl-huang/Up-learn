package com.yukimomo.community.vo;

import lombok.Data;

@Data
public class ProfileVO {
    private Long userId;
    private String nickname;
    private String avatarUrl;
    private String bio;
    private String province;
    private String majorCategory;
    /** 目标院校展示文案 */
    private java.util.List<String> targetSchools;
    /** 对方是否公开关注/粉丝；自己看自己恒为 true（可在设置里改） */
    private Boolean showFollowList;
    /** 当前访客是否可查看关注/粉丝列表 */
    private Boolean canViewFollowList;
    private Long followingCount;
    private Long followerCount;
    private Long postCount;
    private Boolean followedByMe;
}
