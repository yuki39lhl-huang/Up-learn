package com.yukimomo.community.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class CommentVO {
    private Long id;
    private Long postId;
    private Long userId;
    private String nickname;
    private String avatarUrl;
    private Long parentId;
    private Long replyToUserId;
    private String replyToNickname;
    private String content;
    private Integer likeCount;
    private Boolean liked;
    private LocalDateTime createdAt;
    private List<CommentVO> replies = new ArrayList<>();
}
