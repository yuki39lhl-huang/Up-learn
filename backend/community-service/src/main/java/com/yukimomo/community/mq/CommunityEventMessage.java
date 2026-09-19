package com.yukimomo.community.mq;

/**
 * @param type POST_LIKED / COMMENT_LIKED / COMMENT_CREATED / USER_FOLLOWED / POST_FAVORITED
 * @param refId 帖子 id（点赞/评论/收藏）或被关注用户 id（关注）
 */
public record CommunityEventMessage(
        String type,
        Long actorId,
        Long targetUserId,
        Long refId,
        String content
) {
}
