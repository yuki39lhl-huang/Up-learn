import request, { getData } from './request'
import type { PageDTO } from '../types/api'

export type CommunityFeedTab = 'recommend' | 'hot' | 'following'

export interface CommunityPostVO {
  id: number
  userId: number
  nickname?: string | null
  avatarUrl?: string | null
  title: string
  content: string
  coverUrl?: string | null
  tag?: string | null
  likeCount: number
  commentCount: number
  favoriteCount: number
  liked?: boolean | null
  favorited?: boolean | null
  createdAt?: string | null
}

export interface CommunityCommentVO {
  id: number
  postId: number
  userId: number
  nickname?: string | null
  avatarUrl?: string | null
  parentId?: number | null
  replyToUserId?: number | null
  replyToNickname?: string | null
  content: string
  likeCount: number
  liked?: boolean | null
  createdAt?: string | null
  replies?: CommunityCommentVO[]
}

export interface CommunityProfileVO {
  userId: number
  nickname?: string | null
  avatarUrl?: string | null
  bio?: string | null
  province?: string | null
  majorCategory?: string | null
  targetSchools?: string[] | null
  showFollowList?: boolean | null
  canViewFollowList?: boolean | null
  followingCount: number
  followerCount: number
  postCount: number
  followedByMe?: boolean | null
}

export interface CommunityFollowUserVO {
  userId: number
  nickname?: string | null
  avatarUrl?: string | null
}

export interface CreatePostPayload {
  title: string
  content: string
  coverUrl?: string
  tag?: string
}

export interface CreateCommentPayload {
  content: string
  parentId?: number | null
}

export function fetchCommunityFeed(params: {
  tab?: CommunityFeedTab
  kw?: string
  page?: number
  size?: number
}) {
  return getData<PageDTO<CommunityPostVO>>(request.get('/community/posts', { params }))
}

export function fetchCommunityPost(id: number) {
  return getData<CommunityPostVO>(request.get(`/community/posts/${id}`))
}

export function createCommunityPost(payload: CreatePostPayload) {
  return getData<CommunityPostVO>(request.post('/community/posts', payload))
}

export function deleteCommunityPost(id: number) {
  return getData<void>(request.delete(`/community/posts/${id}`))
}

export function fetchPostComments(postId: number) {
  return getData<CommunityCommentVO[]>(request.get(`/community/posts/${postId}/comments`))
}

export function createPostComment(postId: number, payload: CreateCommentPayload) {
  return getData<CommunityCommentVO>(request.post(`/community/posts/${postId}/comments`, payload))
}

export function deletePostComment(commentId: number) {
  return getData<void>(request.delete(`/community/comments/${commentId}`))
}

export function togglePostLike(postId: number) {
  return getData<{ liked: boolean }>(request.post(`/community/posts/${postId}/like`))
}

export function togglePostFavorite(postId: number) {
  return getData<{ favorited: boolean }>(request.post(`/community/posts/${postId}/favorite`))
}

export function toggleCommentLike(commentId: number) {
  return getData<{ liked: boolean }>(request.post(`/community/comments/${commentId}/like`))
}

export function toggleFollowUser(userId: number) {
  return getData<{ followed: boolean }>(request.post(`/community/users/${userId}/follow`))
}

export function fetchCommunityProfile(userId: number) {
  return getData<CommunityProfileVO>(request.get(`/community/users/${userId}`))
}

export function fetchUserFollowing(userId: number) {
  return getData<CommunityFollowUserVO[]>(request.get(`/community/users/${userId}/following`))
}

export function fetchUserFollowers(userId: number) {
  return getData<CommunityFollowUserVO[]>(request.get(`/community/users/${userId}/followers`))
}

export function fetchUserCommunityPosts(userId: number, page = 1, size = 10) {
  return getData<PageDTO<CommunityPostVO>>(
    request.get(`/community/users/${userId}/posts`, { params: { page, size } }),
  )
}

/** 当前登录用户收藏的帖子 */
export function fetchMyFavoritePosts(page = 1, size = 10) {
  return getData<PageDTO<CommunityPostVO>>(
    request.get('/community/me/favorites', { params: { page, size } }),
  )
}

export interface CommunityNotificationVO {
  id: number
  type: string
  refId?: number | null
  /** 已解析的帖子 id，打开详情用它（勿用可能是 commentId 的 refId） */
  postId?: number | null
  postTitle?: string | null
  /** 回复/评论赞类：深链 ?replyTo= */
  commentId?: number | null
  actorId?: number | null
  actorNickname?: string | null
  actorAvatarUrl?: string | null
  content?: string | null
  read?: boolean | null
  createdAt?: string | null
}

export function fetchCommunityNotifications() {
  return getData<CommunityNotificationVO[]>(request.get('/community/notifications'))
}

export function markAllCommunityNotificationsRead() {
  return getData<{ updated: number }>(request.post('/community/notifications/read-all'))
}

export function deleteCommunityNotification(id: number) {
  return getData<void>(request.delete(`/community/notifications/${id}`))
}

export function deleteCommunityNotifications(ids: number[]) {
  return getData<{ deleted: number }>(request.post('/community/notifications/delete-batch', ids))
}

/** 社区独立窗口：发帖 / 帖子详情 / 个人主页 */
export function openCommunityWindow(path: string) {
  const url = path.startsWith('/') ? path : `/${path}`
  window.open(url, '_blank', 'noopener,noreferrer')
}
