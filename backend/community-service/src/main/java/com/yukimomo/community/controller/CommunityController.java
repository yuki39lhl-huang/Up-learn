package com.yukimomo.community.controller;

import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.community.dto.CreateCommentDTO;
import com.yukimomo.community.dto.CreatePostDTO;
import com.yukimomo.community.service.CommunityService;
import com.yukimomo.community.vo.CommentVO;
import com.yukimomo.community.vo.NotificationVO;
import com.yukimomo.community.vo.PostVO;
import com.yukimomo.community.vo.ProfileVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Tag(name = "社区")
@RestController
@RequestMapping("/api/community")
@RequiredArgsConstructor
public class CommunityController {

    private final CommunityService communityService;

    @Operation(summary = "发帖")
    @PostMapping("/posts")
    public Result<PostVO> create(@Valid @RequestBody CreatePostDTO dto) {
        return Result.ok(communityService.createPost(dto));
    }

    @Operation(summary = "信息流", description = "tab=recommend|hot|following；kw 搜索")
    @GetMapping("/posts")
    public Result<PageDTO<PostVO>> feed(
            @RequestParam(defaultValue = "recommend") String tab,
            @RequestParam(required = false) String kw,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        return Result.ok(communityService.feed(tab, kw, page, size));
    }

    @Operation(summary = "帖子详情")
    @GetMapping("/posts/{id}")
    public Result<PostVO> detail(@PathVariable Long id) {
        return Result.ok(communityService.getPost(id));
    }

    @Operation(summary = "删除自己的帖子")
    @DeleteMapping("/posts/{id}")
    public Result<Void> deletePost(@PathVariable Long id) {
        communityService.deletePost(id);
        return Result.ok();
    }

    @Operation(summary = "评论列表（一级+二级 replies）")
    @GetMapping("/posts/{id}/comments")
    public Result<List<CommentVO>> comments(@PathVariable Long id) {
        return Result.ok(communityService.listComments(id));
    }

    @Operation(summary = "发表评论/回复")
    @PostMapping("/posts/{id}/comments")
    public Result<CommentVO> addComment(@PathVariable Long id, @Valid @RequestBody CreateCommentDTO dto) {
        return Result.ok(communityService.addComment(id, dto));
    }

    @Operation(summary = "删除评论/回复（本人或帖主）")
    @DeleteMapping("/comments/{id}")
    public Result<Void> deleteComment(@PathVariable Long id) {
        communityService.deleteComment(id);
        return Result.ok();
    }

    @Operation(summary = "点赞/取消点赞帖子")
    @PostMapping("/posts/{id}/like")
    public Result<Map<String, Boolean>> likePost(@PathVariable Long id) {
        return Result.ok(Map.of("liked", communityService.togglePostLike(id)));
    }

    @Operation(summary = "收藏/取消收藏")
    @PostMapping("/posts/{id}/favorite")
    public Result<Map<String, Boolean>> favorite(@PathVariable Long id) {
        return Result.ok(Map.of("favorited", communityService.toggleFavorite(id)));
    }

    @Operation(summary = "点赞/取消点赞评论")
    @PostMapping("/comments/{id}/like")
    public Result<Map<String, Boolean>> likeComment(@PathVariable Long id) {
        return Result.ok(Map.of("liked", communityService.toggleCommentLike(id)));
    }

    @Operation(summary = "关注/取消关注")
    @PostMapping("/users/{userId}/follow")
    public Result<Map<String, Boolean>> follow(@PathVariable Long userId) {
        return Result.ok(Map.of("followed", communityService.toggleFollow(userId)));
    }

    @Operation(summary = "用户主页摘要")
    @GetMapping("/users/{userId}")
    public Result<ProfileVO> profile(@PathVariable Long userId) {
        return Result.ok(communityService.profile(userId));
    }

    @Operation(summary = "关注列表")
    @GetMapping("/users/{userId}/following")
    public Result<List<com.yukimomo.community.vo.FollowUserVO>> following(@PathVariable Long userId) {
        return Result.ok(communityService.listFollowing(userId));
    }

    @Operation(summary = "粉丝列表")
    @GetMapping("/users/{userId}/followers")
    public Result<List<com.yukimomo.community.vo.FollowUserVO>> followers(@PathVariable Long userId) {
        return Result.ok(communityService.listFollowers(userId));
    }

    @Operation(summary = "用户帖子列表")
    @GetMapping("/users/{userId}/posts")
    public Result<PageDTO<PostVO>> userPosts(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        return Result.ok(communityService.userPosts(userId, page, size));
    }

    @Operation(summary = "我收藏的帖子")
    @GetMapping("/me/favorites")
    public Result<PageDTO<PostVO>> myFavorites(
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        return Result.ok(communityService.myFavorites(page, size));
    }

    @Operation(summary = "我的通知")
    @GetMapping("/notifications")
    public Result<List<NotificationVO>> notifications() {
        return Result.ok(communityService.myNotifications());
    }

    @Operation(summary = "全部标为已读")
    @PostMapping("/notifications/read-all")
    public Result<Map<String, Integer>> markAllRead() {
        return Result.ok(Map.of("updated", communityService.markAllNotificationsRead()));
    }

    @Operation(summary = "删除一条通知")
    @DeleteMapping("/notifications/{id}")
    public Result<Void> deleteNotification(@PathVariable Long id) {
        communityService.deleteNotification(id);
        return Result.ok();
    }

    @Operation(summary = "批量删除通知")
    @PostMapping("/notifications/delete-batch")
    public Result<Map<String, Integer>> deleteNotifications(@RequestBody List<Long> ids) {
        return Result.ok(Map.of("deleted", communityService.deleteNotifications(ids)));
    }
}
