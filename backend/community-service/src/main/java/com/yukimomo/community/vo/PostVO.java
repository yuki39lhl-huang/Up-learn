package com.yukimomo.community.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PostVO {
    private Long id;
    private Long userId;
    private String nickname;
    private String avatarUrl;
    private String title;
    private String content;
    private String coverUrl;
    private String tag;
    private Integer likeCount;
    private Integer commentCount;
    private Integer favoriteCount;
    private Boolean liked;
    private Boolean favorited;
    private LocalDateTime createdAt;
}
