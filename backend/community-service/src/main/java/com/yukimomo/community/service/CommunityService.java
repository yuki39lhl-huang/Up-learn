package com.yukimomo.community.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yukimomo.api.client.UserFeignClient;
import com.yukimomo.api.user.vo.UserBriefVO;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.UserContext;
import com.yukimomo.community.dto.CreateCommentDTO;
import com.yukimomo.community.dto.CreatePostDTO;
import com.yukimomo.community.entity.CommunityComment;
import com.yukimomo.community.entity.CommunityFavorite;
import com.yukimomo.community.entity.CommunityFollow;
import com.yukimomo.community.entity.CommunityLike;
import com.yukimomo.community.entity.CommunityNotification;
import com.yukimomo.community.entity.CommunityPost;
import com.yukimomo.community.es.CommunityPostSearchService;
import com.yukimomo.community.mapper.CommunityCommentMapper;
import com.yukimomo.community.mapper.CommunityFavoriteMapper;
import com.yukimomo.community.mapper.CommunityFollowMapper;
import com.yukimomo.community.mapper.CommunityLikeMapper;
import com.yukimomo.community.mapper.CommunityNotificationMapper;
import com.yukimomo.community.mapper.CommunityPostMapper;
import com.yukimomo.community.mq.CommunityEventMessage;
import com.yukimomo.community.mq.CommunityEventPublisher;
import com.yukimomo.community.vo.CommentVO;
import com.yukimomo.community.vo.NotificationVO;
import com.yukimomo.community.vo.PostVO;
import com.yukimomo.community.vo.ProfileVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommunityService {

    private final CommunityPostMapper postMapper;
    private final CommunityCommentMapper commentMapper;
    private final CommunityLikeMapper likeMapper;
    private final CommunityFavoriteMapper favoriteMapper;
    private final CommunityFollowMapper followMapper;
    private final CommunityNotificationMapper notificationMapper;
    private final CommunityEventPublisher eventPublisher;
    private final ObjectProvider<CommunityPostSearchService> searchService;
    private final UserFeignClient userFeignClient;

    @Transactional(rollbackFor = Exception.class)
    public PostVO createPost(CreatePostDTO dto) {
        Long userId = UserContext.requireUserId();
        CommunityPost post = new CommunityPost();
        post.setUserId(userId);
        post.setTitle(dto.getTitle().trim());
        post.setContent(dto.getContent().trim());
        post.setCoverUrl(StringUtils.hasText(dto.getCoverUrl()) ? dto.getCoverUrl().trim() : null);
        post.setTag(StringUtils.hasText(dto.getTag()) ? dto.getTag().trim() : null);
        post.setLikeCount(0);
        post.setCommentCount(0);
        post.setFavoriteCount(0);
        post.setStatus(1);
        post.setCreatedAt(LocalDateTime.now());
        post.setUpdatedAt(LocalDateTime.now());
        postMapper.insert(post);
        CommunityPostSearchService es = searchService.getIfAvailable();
        if (es != null) {
            es.index(post);
        }
        return toPostVO(post, userId, briefs(List.of(userId)), false);
    }

    public PageDTO<PostVO> feed(String tab, String kw, long pageNo, long pageSize) {
        Long me = UserContext.getUserId();
        LambdaQueryWrapper<CommunityPost> wrapper = new LambdaQueryWrapper<CommunityPost>()
                .eq(CommunityPost::getStatus, 1);

        if ("following".equalsIgnoreCase(tab) && me != null) {
            List<CommunityFollow> follows = followMapper.selectList(new LambdaQueryWrapper<CommunityFollow>()
                    .eq(CommunityFollow::getFollowerId, me));
            List<Long> followeeIds = follows.stream().map(CommunityFollow::getFolloweeId).toList();
            if (followeeIds.isEmpty()) {
                return PageDTO.empty();
            }
            wrapper.in(CommunityPost::getUserId, followeeIds);
        }

        List<Long> esIds = null;
        if (StringUtils.hasText(kw)) {
            CommunityPostSearchService es = searchService.getIfAvailable();
            if (es != null && es.isAvailable()) {
                esIds = es.searchIds(kw, 200);
            }
            if (esIds != null) {
                if (esIds.isEmpty()) {
                    return PageDTO.empty();
                }
                wrapper.in(CommunityPost::getId, esIds);
            } else {
                wrapper.and(w -> w.like(CommunityPost::getTitle, kw.trim())
                        .or().like(CommunityPost::getContent, kw.trim())
                        .or().like(CommunityPost::getTag, kw.trim()));
            }
        }

        if ("hot".equalsIgnoreCase(tab)) {
            wrapper.orderByDesc(CommunityPost::getLikeCount).orderByDesc(CommunityPost::getId);
        } else {
            wrapper.orderByDesc(CommunityPost::getCreatedAt).orderByDesc(CommunityPost::getId);
        }

        Page<CommunityPost> page = postMapper.selectPage(new Page<>(pageNo, pageSize), wrapper);
        return toPostPage(page, me);
    }

    public PostVO getPost(Long id) {
        CommunityPost post = requirePost(id);
        Long me = UserContext.getUserId();
        return toPostVO(post, me, briefs(List.of(post.getUserId())), true);
    }

    @Transactional(rollbackFor = Exception.class)
    public CommentVO addComment(Long postId, CreateCommentDTO dto) {
        Long userId = UserContext.requireUserId();
        CommunityPost post = requirePost(postId);
        Long parentId = dto.getParentId();
        Long replyToUserId = null;
        if (parentId != null) {
            CommunityComment target = commentMapper.selectById(parentId);
            if (target == null || !Objects.equals(target.getPostId(), postId)
                    || target.getStatus() == null || target.getStatus() != 1) {
                throw new BizException(ErrorCode.BAD_REQUEST, "回复的评论不存在");
            }
            if (target.getParentId() != null) {
                // 点的是二级回复：仍挂在同一一级下，@该二级作者（不做三级嵌套）
                replyToUserId = target.getUserId();
                parentId = target.getParentId();
                CommunityComment root = commentMapper.selectById(parentId);
                if (root == null || root.getParentId() != null
                        || !Objects.equals(root.getPostId(), postId)) {
                    throw new BizException(ErrorCode.BAD_REQUEST, "回复的评论不存在");
                }
            } else {
                replyToUserId = target.getUserId();
            }
        }
        CommunityComment comment = new CommunityComment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setParentId(parentId);
        comment.setReplyToUserId(replyToUserId);
        comment.setContent(dto.getContent().trim());
        comment.setLikeCount(0);
        comment.setStatus(1);
        comment.setCreatedAt(LocalDateTime.now());
        comment.setUpdatedAt(LocalDateTime.now());
        commentMapper.insert(comment);

        post.setCommentCount((post.getCommentCount() == null ? 0 : post.getCommentCount()) + 1);
        postMapper.updateById(post);

        Long notifyUser = parentId == null ? post.getUserId() : replyToUserId;
        String snippet = comment.getContent();
        if (snippet.length() > 120) {
            snippet = snippet.substring(0, 120) + "…";
        }
        // refId=commentId：列表可解析 postId，前端可深链 ?replyTo=
        eventPublisher.publish(new CommunityEventMessage(
                "COMMENT_CREATED", userId, notifyUser, comment.getId(), snippet));

        List<Long> briefIds = new ArrayList<>();
        briefIds.add(userId);
        if (replyToUserId != null) {
            briefIds.add(replyToUserId);
        }
        Map<Long, UserBriefVO> briefMap = briefs(briefIds);
        return toCommentVO(comment, briefMap, false);
    }

    /**
     * 删除评论/回复：本人可删自己的；帖主可删该帖下任何人的评论。
     * 删一级评论时会连带软删其下所有二级回复，并同步扣减帖子评论数。
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteComment(Long commentId) {
        Long userId = UserContext.requireUserId();
        CommunityComment comment = commentMapper.selectById(commentId);
        if (comment == null || comment.getStatus() == null || comment.getStatus() != 1) {
            throw new BizException(ErrorCode.BAD_REQUEST, "评论不存在");
        }
        CommunityPost post = requirePost(comment.getPostId());
        boolean isAuthor = Objects.equals(comment.getUserId(), userId);
        boolean isPostOwner = Objects.equals(post.getUserId(), userId);
        if (!isAuthor && !isPostOwner) {
            throw new BizException(ErrorCode.BAD_REQUEST, "无权删除该评论");
        }
        int removed = 1;
        commentMapper.deleteById(commentId);

        if (comment.getParentId() == null) {
            List<CommunityComment> replies = commentMapper.selectList(new LambdaQueryWrapper<CommunityComment>()
                    .eq(CommunityComment::getParentId, commentId)
                    .eq(CommunityComment::getStatus, 1));
            for (CommunityComment reply : replies) {
                commentMapper.deleteById(reply.getId());
                removed++;
            }
        }

        int next = Math.max(0, (post.getCommentCount() == null ? 0 : post.getCommentCount()) - removed);
        post.setCommentCount(next);
        post.setUpdatedAt(LocalDateTime.now());
        postMapper.updateById(post);
    }

    /** 删除自己的帖子（逻辑删除 + 移除 ES） */
    @Transactional(rollbackFor = Exception.class)
    public void deletePost(Long postId) {
        Long userId = UserContext.requireUserId();
        CommunityPost post = requirePost(postId);
        if (!Objects.equals(post.getUserId(), userId)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "只能删除自己的帖子");
        }
        postMapper.deleteById(postId);
        CommunityPostSearchService es = searchService.getIfAvailable();
        if (es != null) {
            es.delete(postId);
        }
    }

    public List<CommentVO> listComments(Long postId) {
        requirePost(postId);
        Long me = UserContext.getUserId();
        List<CommunityComment> all = commentMapper.selectList(new LambdaQueryWrapper<CommunityComment>()
                .eq(CommunityComment::getPostId, postId)
                .eq(CommunityComment::getStatus, 1)
                .orderByAsc(CommunityComment::getCreatedAt));
        Set<Long> userIds = new HashSet<>();
        List<Long> commentIds = new ArrayList<>();
        for (CommunityComment c : all) {
            commentIds.add(c.getId());
            userIds.add(c.getUserId());
            if (c.getReplyToUserId() != null) {
                userIds.add(c.getReplyToUserId());
            }
        }
        Map<Long, UserBriefVO> briefMap = briefs(new ArrayList<>(userIds));
        Set<Long> likedIds = Set.of();
        if (me != null && !commentIds.isEmpty()) {
            likedIds = likeMapper.selectList(new LambdaQueryWrapper<CommunityLike>()
                            .eq(CommunityLike::getUserId, me)
                            .eq(CommunityLike::getTargetType, "COMMENT")
                            .in(CommunityLike::getTargetId, commentIds))
                    .stream()
                    .map(CommunityLike::getTargetId)
                    .collect(Collectors.toSet());
        }
        Map<Long, CommentVO> roots = new LinkedHashMap<>();
        List<CommentVO> result = new ArrayList<>();
        for (CommunityComment c : all) {
            if (c.getParentId() == null) {
                CommentVO vo = toCommentVO(c, briefMap, likedIds.contains(c.getId()));
                roots.put(c.getId(), vo);
                result.add(vo);
            }
        }
        for (CommunityComment c : all) {
            if (c.getParentId() != null) {
                CommentVO parent = roots.get(c.getParentId());
                if (parent != null) {
                    parent.getReplies().add(toCommentVO(c, briefMap, likedIds.contains(c.getId())));
                }
            }
        }
        return result;
    }

    @Transactional(rollbackFor = Exception.class)
    public boolean togglePostLike(Long postId) {
        Long userId = UserContext.requireUserId();
        CommunityPost post = requirePost(postId);
        CommunityLike existing = likeMapper.selectOne(new LambdaQueryWrapper<CommunityLike>()
                .eq(CommunityLike::getUserId, userId)
                .eq(CommunityLike::getTargetType, "POST")
                .eq(CommunityLike::getTargetId, postId));
        if (existing != null) {
            likeMapper.deleteById(existing.getId());
            post.setLikeCount(Math.max(0, (post.getLikeCount() == null ? 0 : post.getLikeCount()) - 1));
            postMapper.updateById(post);
            return false;
        }
        CommunityLike like = new CommunityLike();
        like.setUserId(userId);
        like.setTargetType("POST");
        like.setTargetId(postId);
        like.setCreatedAt(LocalDateTime.now());
        likeMapper.insert(like);
        post.setLikeCount((post.getLikeCount() == null ? 0 : post.getLikeCount()) + 1);
        postMapper.updateById(post);
        eventPublisher.publish(new CommunityEventMessage(
                "POST_LIKED", userId, post.getUserId(), postId, "赞了你的帖子"));
        return true;
    }

    @Transactional(rollbackFor = Exception.class)
    public boolean toggleCommentLike(Long commentId) {
        Long userId = UserContext.requireUserId();
        CommunityComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new BizException(ErrorCode.BAD_REQUEST, "评论不存在");
        }
        CommunityLike existing = likeMapper.selectOne(new LambdaQueryWrapper<CommunityLike>()
                .eq(CommunityLike::getUserId, userId)
                .eq(CommunityLike::getTargetType, "COMMENT")
                .eq(CommunityLike::getTargetId, commentId));
        if (existing != null) {
            likeMapper.deleteById(existing.getId());
            comment.setLikeCount(Math.max(0, (comment.getLikeCount() == null ? 0 : comment.getLikeCount()) - 1));
            commentMapper.updateById(comment);
            return false;
        }
        CommunityLike like = new CommunityLike();
        like.setUserId(userId);
        like.setTargetType("COMMENT");
        like.setTargetId(commentId);
        like.setCreatedAt(LocalDateTime.now());
        likeMapper.insert(like);
        comment.setLikeCount((comment.getLikeCount() == null ? 0 : comment.getLikeCount()) + 1);
        commentMapper.updateById(comment);
        eventPublisher.publish(new CommunityEventMessage(
                "COMMENT_LIKED", userId, comment.getUserId(), comment.getPostId(), "赞了你的评论"));
        return true;
    }

    @Transactional(rollbackFor = Exception.class)
    public boolean toggleFavorite(Long postId) {
        Long userId = UserContext.requireUserId();
        CommunityPost post = requirePost(postId);
        CommunityFavorite existing = favoriteMapper.selectOne(new LambdaQueryWrapper<CommunityFavorite>()
                .eq(CommunityFavorite::getUserId, userId)
                .eq(CommunityFavorite::getPostId, postId));
        if (existing != null) {
            favoriteMapper.deleteById(existing.getId());
            post.setFavoriteCount(Math.max(0, (post.getFavoriteCount() == null ? 0 : post.getFavoriteCount()) - 1));
            postMapper.updateById(post);
            return false;
        }
        CommunityFavorite fav = new CommunityFavorite();
        fav.setUserId(userId);
        fav.setPostId(postId);
        fav.setCreatedAt(LocalDateTime.now());
        favoriteMapper.insert(fav);
        post.setFavoriteCount((post.getFavoriteCount() == null ? 0 : post.getFavoriteCount()) + 1);
        postMapper.updateById(post);
        eventPublisher.publish(new CommunityEventMessage(
                "POST_FAVORITED", userId, post.getUserId(), postId, "收藏了你的帖子"));
        return true;
    }

    @Transactional(rollbackFor = Exception.class)
    public boolean toggleFollow(Long followeeId) {
        Long followerId = UserContext.requireUserId();
        if (Objects.equals(followerId, followeeId)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "不能关注自己");
        }
        CommunityFollow existing = followMapper.selectOne(new LambdaQueryWrapper<CommunityFollow>()
                .eq(CommunityFollow::getFollowerId, followerId)
                .eq(CommunityFollow::getFolloweeId, followeeId));
        if (existing != null) {
            followMapper.deleteById(existing.getId());
            return false;
        }
        CommunityFollow follow = new CommunityFollow();
        follow.setFollowerId(followerId);
        follow.setFolloweeId(followeeId);
        follow.setCreatedAt(LocalDateTime.now());
        followMapper.insert(follow);
        eventPublisher.publish(new CommunityEventMessage(
                "USER_FOLLOWED", followerId, followeeId, followeeId, "关注了你"));
        return true;
    }

    public ProfileVO profile(Long userId) {
        Long me = UserContext.getUserId();
        com.yukimomo.api.user.vo.UserPublicProfileVO pub = null;
        try {
            Result<com.yukimomo.api.user.vo.UserPublicProfileVO> result = userFeignClient.getPublicProfile(userId);
            if (result != null) {
                pub = result.getData();
            }
        } catch (Exception ignored) {
            // fall through
        }
        if (pub == null) {
            Map<Long, UserBriefVO> briefMap = briefs(List.of(userId));
            UserBriefVO brief = briefMap.get(userId);
            if (brief == null) {
                throw new BizException(ErrorCode.USER_NOT_FOUND);
            }
            pub = new com.yukimomo.api.user.vo.UserPublicProfileVO();
            pub.setUserId(userId);
            pub.setNickname(brief.getNickname());
            pub.setAvatarUrl(brief.getAvatarUrl());
            pub.setShowFollowList(true);
        }
        ProfileVO vo = new ProfileVO();
        vo.setUserId(userId);
        vo.setNickname(pub.getNickname());
        vo.setAvatarUrl(pub.getAvatarUrl());
        vo.setBio(pub.getBio());
        vo.setProvince(pub.getProvince());
        vo.setMajorCategory(pub.getMajorCategory());
        vo.setTargetSchools(pub.getTargetSchools());
        boolean showFollow = pub.getShowFollowList() == null || Boolean.TRUE.equals(pub.getShowFollowList());
        vo.setShowFollowList(showFollow);
        boolean isSelf = me != null && Objects.equals(me, userId);
        vo.setCanViewFollowList(isSelf || showFollow);
        vo.setFollowingCount(followMapper.selectCount(new LambdaQueryWrapper<CommunityFollow>()
                .eq(CommunityFollow::getFollowerId, userId)));
        vo.setFollowerCount(followMapper.selectCount(new LambdaQueryWrapper<CommunityFollow>()
                .eq(CommunityFollow::getFolloweeId, userId)));
        vo.setPostCount(postMapper.selectCount(new LambdaQueryWrapper<CommunityPost>()
                .eq(CommunityPost::getUserId, userId)
                .eq(CommunityPost::getStatus, 1)));
        if (me != null && !isSelf) {
            Long cnt = followMapper.selectCount(new LambdaQueryWrapper<CommunityFollow>()
                    .eq(CommunityFollow::getFollowerId, me)
                    .eq(CommunityFollow::getFolloweeId, userId));
            vo.setFollowedByMe(cnt != null && cnt > 0);
        } else {
            vo.setFollowedByMe(false);
        }
        return vo;
    }

    public List<com.yukimomo.community.vo.FollowUserVO> listFollowing(Long userId) {
        assertCanViewFollowList(userId);
        List<CommunityFollow> rows = followMapper.selectList(new LambdaQueryWrapper<CommunityFollow>()
                .eq(CommunityFollow::getFollowerId, userId)
                .orderByDesc(CommunityFollow::getId)
                .last("LIMIT 200"));
        return toFollowUsers(rows.stream().map(CommunityFollow::getFolloweeId).toList());
    }

    public List<com.yukimomo.community.vo.FollowUserVO> listFollowers(Long userId) {
        assertCanViewFollowList(userId);
        List<CommunityFollow> rows = followMapper.selectList(new LambdaQueryWrapper<CommunityFollow>()
                .eq(CommunityFollow::getFolloweeId, userId)
                .orderByDesc(CommunityFollow::getId)
                .last("LIMIT 200"));
        return toFollowUsers(rows.stream().map(CommunityFollow::getFollowerId).toList());
    }

    private void assertCanViewFollowList(Long userId) {
        ProfileVO profile = profile(userId);
        if (!Boolean.TRUE.equals(profile.getCanViewFollowList())) {
            throw new BizException(ErrorCode.BAD_REQUEST, "该用户已关闭关注/粉丝列表公开");
        }
    }

    private List<com.yukimomo.community.vo.FollowUserVO> toFollowUsers(List<Long> userIds) {
        if (userIds == null || userIds.isEmpty()) {
            return List.of();
        }
        Map<Long, UserBriefVO> briefMap = briefs(userIds);
        List<com.yukimomo.community.vo.FollowUserVO> list = new ArrayList<>();
        for (Long id : userIds) {
            UserBriefVO brief = briefMap.get(id);
            com.yukimomo.community.vo.FollowUserVO vo = new com.yukimomo.community.vo.FollowUserVO();
            vo.setUserId(id);
            vo.setNickname(brief == null ? null : brief.getNickname());
            vo.setAvatarUrl(brief == null ? null : brief.getAvatarUrl());
            list.add(vo);
        }
        return list;
    }

    public PageDTO<PostVO> userPosts(Long userId, long pageNo, long pageSize) {
        Page<CommunityPost> page = postMapper.selectPage(new Page<>(pageNo, pageSize),
                new LambdaQueryWrapper<CommunityPost>()
                        .eq(CommunityPost::getUserId, userId)
                        .eq(CommunityPost::getStatus, 1)
                        .orderByDesc(CommunityPost::getCreatedAt));
        return toPostPage(page, UserContext.getUserId());
    }

    /** 当前登录用户收藏的帖子（按收藏时间倒序） */
    public PageDTO<PostVO> myFavorites(long pageNo, long pageSize) {
        Long userId = UserContext.requireUserId();
        Page<CommunityFavorite> favPage = favoriteMapper.selectPage(
                new Page<>(pageNo, pageSize),
                new LambdaQueryWrapper<CommunityFavorite>()
                        .eq(CommunityFavorite::getUserId, userId)
                        .orderByDesc(CommunityFavorite::getCreatedAt)
                        .orderByDesc(CommunityFavorite::getId));
        List<CommunityFavorite> favs = favPage.getRecords();
        if (favs == null || favs.isEmpty()) {
            return PageDTO.empty();
        }
        List<Long> postIds = favs.stream().map(CommunityFavorite::getPostId).toList();
        List<CommunityPost> posts = postMapper.selectList(new LambdaQueryWrapper<CommunityPost>()
                .in(CommunityPost::getId, postIds)
                .eq(CommunityPost::getStatus, 1));
        Map<Long, CommunityPost> postMap = posts.stream()
                .collect(Collectors.toMap(CommunityPost::getId, p -> p, (a, b) -> a));
        List<CommunityPost> ordered = new ArrayList<>();
        for (Long postId : postIds) {
            CommunityPost post = postMap.get(postId);
            if (post != null) {
                ordered.add(post);
            }
        }
        if (ordered.isEmpty()) {
            PageDTO<PostVO> empty = PageDTO.empty();
            empty.setTotal(favPage.getTotal());
            empty.setPages(favPage.getPages());
            return empty;
        }
        List<Long> authorIds = ordered.stream().map(CommunityPost::getUserId).distinct().toList();
        Map<Long, UserBriefVO> briefMap = briefs(authorIds);
        List<PostVO> list = ordered.stream().map(p -> toPostVO(p, userId, briefMap, false)).toList();
        for (PostVO vo : list) {
            vo.setFavorited(true);
        }
        PageDTO<PostVO> dto = new PageDTO<>();
        dto.setTotal(favPage.getTotal());
        dto.setPages(favPage.getPages());
        dto.setList(list);
        return dto;
    }

    public List<NotificationVO> myNotifications() {
        Long userId = UserContext.requireUserId();
        List<CommunityNotification> rows = notificationMapper.selectList(new LambdaQueryWrapper<CommunityNotification>()
                .eq(CommunityNotification::getUserId, userId)
                .orderByDesc(CommunityNotification::getCreatedAt)
                .last("LIMIT 100"));
        Set<Long> actors = rows.stream().map(CommunityNotification::getActorId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, UserBriefVO> briefMap = briefs(new ArrayList<>(actors));

        // 兼容旧数据：评论类 refId 曾写 commentId，解析成 postId
        Set<Long> maybeCommentIds = new HashSet<>();
        for (CommunityNotification row : rows) {
            if (row.getRefId() == null) {
                continue;
            }
            String type = row.getType();
            if ("USER_FOLLOWED".equals(type)) {
                continue;
            }
            if ("COMMENT_CREATED".equals(type) || "COMMENT_LIKED".equals(type)) {
                maybeCommentIds.add(row.getRefId());
            }
        }
        Map<Long, Long> commentToPost = new HashMap<>();
        Map<Long, String> commentContentMap = new HashMap<>();
        if (!maybeCommentIds.isEmpty()) {
            List<CommunityComment> comments = commentMapper.selectList(new LambdaQueryWrapper<CommunityComment>()
                    .in(CommunityComment::getId, maybeCommentIds)
                    .select(CommunityComment::getId, CommunityComment::getPostId, CommunityComment::getContent));
            // 含已逻辑删除评论时 select 可能查不到（TableLogic 过滤）。
            // 旧数据 refId 曾是 postId：查不到 comment 则按帖子处理。
            for (CommunityComment c : comments) {
                if (c.getId() != null && c.getPostId() != null) {
                    commentToPost.put(c.getId(), c.getPostId());
                    if (c.getContent() != null && !c.getContent().isBlank()) {
                        commentContentMap.put(c.getId(), c.getContent());
                    }
                }
            }
        }
        Set<Long> postIds = new HashSet<>();
        for (CommunityNotification row : rows) {
            Long resolved = resolvePostId(row, commentToPost);
            if (resolved != null) {
                postIds.add(resolved);
            }
        }
        Map<Long, CommunityPost> postMap = new HashMap<>();
        if (!postIds.isEmpty()) {
            List<CommunityPost> posts = postMapper.selectList(new LambdaQueryWrapper<CommunityPost>()
                    .in(CommunityPost::getId, postIds)
                    .select(CommunityPost::getId, CommunityPost::getTitle, CommunityPost::getStatus));
            for (CommunityPost p : posts) {
                postMap.put(p.getId(), p);
            }
        }

        List<NotificationVO> list = new ArrayList<>();
        for (CommunityNotification row : rows) {
            NotificationVO vo = new NotificationVO();
            vo.setId(row.getId());
            vo.setType(row.getType());
            vo.setRefId(row.getRefId());
            Long postId = resolvePostId(row, commentToPost);
            vo.setPostId(postId);
            if (postId != null) {
                CommunityPost post = postMap.get(postId);
                if (post != null) {
                    vo.setPostTitle(post.getTitle());
                }
            }
            if (("COMMENT_CREATED".equals(row.getType()) || "COMMENT_LIKED".equals(row.getType()))
                    && row.getRefId() != null && commentToPost.containsKey(row.getRefId())) {
                vo.setCommentId(row.getRefId());
            }
            vo.setActorId(row.getActorId());
            UserBriefVO actor = briefMap.get(row.getActorId());
            if (actor != null) {
                vo.setActorNickname(actor.getNickname());
                vo.setActorAvatarUrl(actor.getAvatarUrl());
            }
            String content = row.getContent();
            if ("COMMENT_CREATED".equals(row.getType())
                    && isGenericCommentNotifyContent(content)
                    && vo.getCommentId() != null) {
                String fromComment = commentContentMap.get(vo.getCommentId());
                if (fromComment != null && !fromComment.isBlank()) {
                    content = fromComment.length() > 120
                            ? fromComment.substring(0, 120) + "…"
                            : fromComment;
                }
            }
            vo.setContent(content);
            vo.setRead(row.getReadFlag() != null && row.getReadFlag() == 1);
            vo.setCreatedAt(row.getCreatedAt());
            list.add(vo);
        }
        return list;
    }

    private static boolean isGenericCommentNotifyContent(String content) {
        if (content == null || content.isBlank()) {
            return true;
        }
        return "评论了你的内容".equals(content.trim());
    }

    /** 评论类优先按 comment→post 解析；否则把 refId 当作 postId */
    private Long resolvePostId(CommunityNotification row, Map<Long, Long> commentToPost) {
        if (row.getRefId() == null || "USER_FOLLOWED".equals(row.getType())) {
            return null;
        }
        Long mapped = commentToPost.get(row.getRefId());
        return mapped != null ? mapped : row.getRefId();
    }

    /** 将当前用户未读通知全部标为已读 */
    @Transactional(rollbackFor = Exception.class)
    public int markAllNotificationsRead() {
        Long userId = UserContext.requireUserId();
        CommunityNotification patch = new CommunityNotification();
        patch.setReadFlag(1);
        return notificationMapper.update(
                patch,
                new LambdaQueryWrapper<CommunityNotification>()
                        .eq(CommunityNotification::getUserId, userId)
                        .eq(CommunityNotification::getReadFlag, 0));
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteNotification(Long id) {
        Long userId = UserContext.requireUserId();
        CommunityNotification row = notificationMapper.selectById(id);
        if (row == null || !Objects.equals(row.getUserId(), userId)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "通知不存在");
        }
        notificationMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteNotifications(List<Long> ids) {
        Long userId = UserContext.requireUserId();
        if (ids == null || ids.isEmpty()) {
            return 0;
        }
        List<Long> clean = ids.stream().filter(Objects::nonNull).distinct().toList();
        if (clean.isEmpty()) {
            return 0;
        }
        return notificationMapper.delete(new LambdaQueryWrapper<CommunityNotification>()
                .eq(CommunityNotification::getUserId, userId)
                .in(CommunityNotification::getId, clean));
    }

    private CommunityPost requirePost(Long id) {
        CommunityPost post = postMapper.selectById(id);
        if (post == null || post.getStatus() == null || post.getStatus() != 1) {
            throw new BizException(ErrorCode.BAD_REQUEST, "帖子不存在");
        }
        return post;
    }

    private PageDTO<PostVO> toPostPage(Page<CommunityPost> page, Long me) {
        List<CommunityPost> records = page.getRecords();
        if (records == null || records.isEmpty()) {
            return PageDTO.empty();
        }
        List<Long> userIds = records.stream().map(CommunityPost::getUserId).distinct().toList();
        Map<Long, UserBriefVO> briefMap = briefs(userIds);
        // 列表不查 liked/favorited，避免 N+1；详情 getPost 再查
        List<PostVO> list = records.stream().map(p -> toPostVO(p, me, briefMap, false)).toList();
        PageDTO<PostVO> dto = new PageDTO<>();
        dto.setTotal(page.getTotal());
        dto.setPages(page.getPages());
        dto.setList(list);
        return dto;
    }

    private PostVO toPostVO(
            CommunityPost post, Long me, Map<Long, UserBriefVO> briefMap, boolean withInteraction) {
        PostVO vo = new PostVO();
        vo.setId(post.getId());
        vo.setUserId(post.getUserId());
        UserBriefVO brief = briefMap.get(post.getUserId());
        if (brief != null) {
            vo.setNickname(brief.getNickname());
            vo.setAvatarUrl(brief.getAvatarUrl());
        }
        vo.setTitle(post.getTitle());
        vo.setContent(post.getContent());
        vo.setCoverUrl(post.getCoverUrl());
        vo.setTag(post.getTag());
        vo.setLikeCount(post.getLikeCount());
        vo.setCommentCount(post.getCommentCount());
        vo.setFavoriteCount(post.getFavoriteCount());
        vo.setCreatedAt(post.getCreatedAt());
        if (withInteraction && me != null) {
            vo.setLiked(likeMapper.selectCount(new LambdaQueryWrapper<CommunityLike>()
                    .eq(CommunityLike::getUserId, me)
                    .eq(CommunityLike::getTargetType, "POST")
                    .eq(CommunityLike::getTargetId, post.getId())) > 0);
            vo.setFavorited(favoriteMapper.selectCount(new LambdaQueryWrapper<CommunityFavorite>()
                    .eq(CommunityFavorite::getUserId, me)
                    .eq(CommunityFavorite::getPostId, post.getId())) > 0);
        } else {
            vo.setLiked(false);
            vo.setFavorited(false);
        }
        return vo;
    }

    private CommentVO toCommentVO(CommunityComment c, Map<Long, UserBriefVO> briefMap, boolean liked) {
        CommentVO vo = new CommentVO();
        vo.setId(c.getId());
        vo.setPostId(c.getPostId());
        vo.setUserId(c.getUserId());
        UserBriefVO brief = briefMap.get(c.getUserId());
        if (brief != null) {
            vo.setNickname(brief.getNickname());
            vo.setAvatarUrl(brief.getAvatarUrl());
        }
        vo.setParentId(c.getParentId());
        vo.setReplyToUserId(c.getReplyToUserId());
        if (c.getReplyToUserId() != null) {
            UserBriefVO reply = briefMap.get(c.getReplyToUserId());
            vo.setReplyToNickname(reply == null ? null : reply.getNickname());
        }
        vo.setContent(c.getContent());
        vo.setLikeCount(c.getLikeCount());
        vo.setCreatedAt(c.getCreatedAt());
        vo.setLiked(liked);
        return vo;
    }

    private Map<Long, UserBriefVO> briefs(List<Long> ids) {
        Map<Long, UserBriefVO> map = new HashMap<>();
        List<Long> clean = ids == null ? List.of() : ids.stream().filter(Objects::nonNull).distinct().toList();
        if (clean.isEmpty()) {
            return map;
        }
        try {
            Result<List<UserBriefVO>> result = userFeignClient.listBriefs(clean);
            if (result != null && result.getData() != null) {
                for (UserBriefVO b : result.getData()) {
                    map.put(b.getUserId(), b);
                }
            }
        } catch (Exception ignored) {
            // Feign 失败时仍返回帖子正文
        }
        return map;
    }
}
