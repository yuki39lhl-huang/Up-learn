package com.yukimomo.community.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationVO {
    private Long id;
    private String type;
    /** 原始关联 id（历史评论类可能是 commentId） */
    private Long refId;
    /** 可打开的帖子 id（已解析）；关注类为空 */
    private Long postId;
    /** 帖子标题摘要（便于列表展示） */
    private String postTitle;
    /** 评论/回复类通知对应的评论 id（深链进回复态） */
    private Long commentId;
    private Long actorId;
    private String actorNickname;
    private String actorAvatarUrl;
    private String content;
    private Boolean read;
    private LocalDateTime createdAt;
}
