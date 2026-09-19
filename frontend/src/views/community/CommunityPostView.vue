<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Delete } from '@element-plus/icons-vue'
import {
  createPostComment,
  deleteCommunityPost,
  deletePostComment,
  fetchCommunityPost,
  fetchPostComments,
  openCommunityWindow,
  toggleCommentLike,
  togglePostFavorite,
  togglePostLike,
  type CommunityCommentVO,
  type CommunityPostVO,
} from '../../api/community'
import { useAuthStore } from '../../stores/auth'
import { formatCommunityTime } from '../../utils/communityFormat'
import { publishCommunitySync, subscribeCommunitySync } from '../../utils/communitySync'
import CommunityWindowShell from './CommunityWindowShell.vue'

const route = useRoute()
const auth = useAuthStore()
const postId = computed(() => Number(route.params.id))

const loading = ref(true)
const post = ref<CommunityPostVO | null>(null)
const comments = ref<CommunityCommentVO[]>([])
const commentText = ref('')
const replyParentId = ref<number | null>(null)
const replyHint = ref('')
const cmtBoxRef = ref<HTMLElement | null>(null)
const replyDeepLinkDone = ref(false)
const submitting = ref(false)
const deletingPost = ref(false)
const deletingCommentId = ref<number | null>(null)
/** 二级回复：抖音式默认全部折叠，展开后显示全部 */
const expandedReplyMap = ref<Record<number, boolean>>({})

const isPostAuthor = computed(
  () => !!post.value && auth.user?.userId === post.value.userId,
)

function isMine(userId: number) {
  return auth.user?.userId === userId
}

/** 本人可删自己的；帖主可删该帖下任意评论 */
function canDeleteComment(c: CommunityCommentVO) {
  return isMine(c.userId) || isPostAuthor.value
}

const deleteBoxOptions = {
  type: 'warning' as const,
  confirmButtonText: '删除',
  cancelButtonText: '取消',
  customClass: 'community-delete-msgbox',
  confirmButtonClass: 'el-button--danger community-delete-confirm',
  cancelButtonClass: 'community-delete-cancel',
  closeOnClickModal: false,
}

function formatTime(v?: string | null) {
  return formatCommunityTime(v)
}

function replyList(c: CommunityCommentVO) {
  return c.replies || []
}

function isReplyExpanded(parentId: number) {
  return expandedReplyMap.value[Number(parentId)] === true
}

function expandReplies(parentId: number) {
  const id = Number(parentId)
  expandedReplyMap.value = { ...expandedReplyMap.value, [id]: true }
}

function collapseReplies(parentId: number) {
  const id = Number(parentId)
  const next = { ...expandedReplyMap.value }
  delete next[id]
  expandedReplyMap.value = next
}

/** 有新回复的楼自动展开；首次加载（无 prev）不展开，保持默认收起 */
function expandGrownThreads(prev: CommunityCommentVO[], next: CommunityCommentVO[]) {
  if (!prev.length) return
  const prevCount = new Map<number, number>()
  for (const c of prev) {
    prevCount.set(Number(c.id), c.replies?.length || 0)
  }
  const map = { ...expandedReplyMap.value }
  let changed = false
  for (const c of next) {
    const id = Number(c.id)
    const n = c.replies?.length || 0
    const old = prevCount.get(id)
    // 仅在「已有该楼且回复数增加」时展开；新出现的楼保持收起
    if (old != null && n > old) {
      map[id] = true
      changed = true
    }
  }
  if (changed) expandedReplyMap.value = map
}

function applyComments(next: CommunityCommentVO[]) {
  const prev = comments.value
  expandGrownThreads(prev, next)
  comments.value = next
}

async function loadAll(silent = false) {
  if (!silent) loading.value = true
  try {
    const [p, c] = await Promise.all([
      fetchCommunityPost(postId.value),
      fetchPostComments(postId.value),
    ])
    if (p) post.value = p
    applyComments(c || [])
  } catch (e) {
    if (!silent) ElMessage.error(e instanceof Error ? e.message : '加载帖子失败')
  } finally {
    if (!silent) loading.value = false
  }
  if (!silent) {
    await nextTick()
    applyReplyDeepLink()
  }
}

async function onLikePost() {
  if (!post.value) return
  try {
    const { liked } = await togglePostLike(post.value.id)
    post.value.liked = liked
    post.value.likeCount = Math.max(0, (post.value.likeCount || 0) + (liked ? 1 : -1))
    publishCommunitySync({
      type: 'post-updated',
      postId: post.value.id,
      userId: post.value.userId,
    })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  }
}

async function onFavorite() {
  if (!post.value) return
  try {
    const { favorited } = await togglePostFavorite(post.value.id)
    post.value.favorited = favorited
    post.value.favoriteCount = Math.max(0, (post.value.favoriteCount || 0) + (favorited ? 1 : -1))
    publishCommunitySync({
      type: 'favorite-changed',
      postId: post.value.id,
      userId: post.value.userId,
    })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  }
}

function scrollToReplyBox() {
  nextTick(() => {
    cmtBoxRef.value?.scrollIntoView({ behavior: 'smooth', block: 'center' })
    const ta = cmtBoxRef.value?.querySelector('textarea') as HTMLTextAreaElement | null
    ta?.focus()
  })
}

function findCommentById(id: number): CommunityCommentVO | null {
  for (const c of comments.value) {
    if (c.id === id) return c
    for (const r of c.replies || []) {
      if (r.id === id) return r
    }
  }
  return null
}

function startReply(c: CommunityCommentVO) {
  replyParentId.value = c.id
  replyHint.value = `回复 @${c.nickname || `用户${c.userId}`}`
  if (c.parentId != null) {
    expandReplies(c.parentId)
  }
  scrollToReplyBox()
}

/** 从通知 ?replyTo=commentId 进入：展开楼层并进入回复态 */
function applyReplyDeepLink() {
  if (replyDeepLinkDone.value) return
  const raw = route.query.replyTo
  const replyTo = Number(Array.isArray(raw) ? raw[0] : raw)
  if (!replyTo || Number.isNaN(replyTo)) return
  const found = findCommentById(replyTo)
  if (!found) return
  replyDeepLinkDone.value = true
  startReply(found)
}

function cancelReply() {
  replyParentId.value = null
  replyHint.value = ''
}

async function submitComment() {
  const text = commentText.value.trim()
  if (!text) {
    ElMessage.warning('请输入评论内容')
    return
  }
  submitting.value = true
  try {
    const repliedTargetId = replyParentId.value
    await createPostComment(postId.value, {
      content: text,
      parentId: replyParentId.value,
    })
    commentText.value = ''
    cancelReply()
    await loadAll(true)
    if (repliedTargetId != null) {
      for (const c of comments.value) {
        if (c.id === repliedTargetId || c.replies?.some((r) => r.id === repliedTargetId)) {
          expandReplies(c.id)
          break
        }
      }
    }
    publishCommunitySync({
      type: 'comment-changed',
      postId: postId.value,
      userId: post.value?.userId,
    })
    ElMessage.success('已发布')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '评论失败')
  } finally {
    submitting.value = false
  }
}

async function onLikeComment(c: CommunityCommentVO) {
  try {
    const { liked } = await toggleCommentLike(c.id)
    c.liked = liked
    c.likeCount = Math.max(0, (c.likeCount || 0) + (liked ? 1 : -1))
    // 评论点赞只做乐观更新，不再广播全量刷新
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  }
}

async function onDeleteComment(c: CommunityCommentVO) {
  if (!canDeleteComment(c)) return
  const isReply = c.parentId != null
  try {
    await ElMessageBox.confirm(
      isReply ? '确定删除这条回复？' : '确定删除这条评论？其下回复也会一并删除。',
      isReply ? '删除回复' : '删除评论',
      deleteBoxOptions,
    )
  } catch {
    return
  }
  deletingCommentId.value = c.id
  try {
    await deletePostComment(c.id)
    if (
      replyParentId.value === c.id ||
      (c.replies || []).some((r) => r.id === replyParentId.value)
    ) {
      cancelReply()
    }
    await loadAll(true)
    publishCommunitySync({
      type: 'comment-changed',
      postId: postId.value,
      userId: post.value?.userId,
    })
    ElMessage.success('已删除')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '删除失败')
  } finally {
    deletingCommentId.value = null
  }
}

async function onDeletePost() {
  if (!post.value || !isPostAuthor.value) return
  try {
    await ElMessageBox.confirm('确定删除这篇帖子？删除后不可恢复。', '删除帖子', deleteBoxOptions)
  } catch {
    return
  }
  deletingPost.value = true
  try {
    const id = post.value.id
    await deleteCommunityPost(id)
    publishCommunitySync({ type: 'post-deleted', postId: id, userId: post.value.userId })
    ElMessage.success('帖子已删除')
    window.setTimeout(() => window.close(), 600)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '删除失败')
  } finally {
    deletingPost.value = false
  }
}

function openProfile(userId: number) {
  openCommunityWindow(`/community/u/${userId}`)
}

let unsubSync: (() => void) | null = null
let syncTimer: ReturnType<typeof setTimeout> | null = null

function scheduleCommentRefresh() {
  if (syncTimer) clearTimeout(syncTimer)
  syncTimer = setTimeout(() => {
    syncTimer = null
    void loadAll(true)
  }, 180)
}

function onVisibility() {
  if (document.visibilityState === 'visible') {
    void loadAll(true)
  }
}

onMounted(() => {
  void loadAll()
  unsubSync = subscribeCommunitySync((ev) => {
    const samePost = ev.postId == null || Number(ev.postId) === Number(postId.value)
    if (!samePost) return
    // 仅评论变更 / 删帖需要静默重拉；点赞收藏已在本页乐观更新
    if (ev.type === 'comment-changed' || ev.type === 'post-deleted') {
      scheduleCommentRefresh()
    }
  })
  document.addEventListener('visibilitychange', onVisibility)
})

onBeforeUnmount(() => {
  unsubSync?.()
  document.removeEventListener('visibilitychange', onVisibility)
  if (syncTimer) clearTimeout(syncTimer)
})
</script>

<template>
  <CommunityWindowShell title="帖子详情">
    <div v-loading="loading" class="post-page">
      <template v-if="post">
        <article class="post-main">
          <div class="post-meta">
            <button type="button" class="post-author" @click="openProfile(post.userId)">
              <el-avatar :size="36" :src="post.avatarUrl || undefined">
                {{ (post.nickname || 'U').slice(0, 1) }}
              </el-avatar>
              <div>
                <strong>{{ post.nickname || `用户${post.userId}` }}</strong>
                <p>{{ formatTime(post.createdAt) }}</p>
              </div>
            </button>
            <span v-if="post.tag" class="post-tag">{{ post.tag }}</span>
          </div>
          <h2 class="post-title">{{ post.title }}</h2>
          <img v-if="post.coverUrl" class="post-cover" :src="post.coverUrl" alt="" />
          <div class="post-content">{{ post.content }}</div>
          <div class="post-actions">
            <el-button :type="post.liked ? 'primary' : 'default'" @click="onLikePost">
              {{ post.liked ? '已赞' : '点赞' }} · {{ post.likeCount || 0 }}
            </el-button>
            <el-button :type="post.favorited ? 'primary' : 'default'" @click="onFavorite">
              {{ post.favorited ? '已收藏' : '收藏' }} · {{ post.favoriteCount || 0 }}
            </el-button>
            <span class="post-cmt-count">评论 {{ post.commentCount || 0 }}</span>
            <el-button
              v-if="isPostAuthor"
              type="danger"
              plain
              :loading="deletingPost"
              class="post-delete"
              @click="onDeletePost"
            >
              删除帖子
            </el-button>
          </div>
        </article>

        <section ref="cmtBoxRef" class="cmt-box">
          <h3>评论</h3>
          <div v-if="replyHint" class="cmt-reply-hint">
            {{ replyHint }}
            <button type="button" @click="cancelReply">取消</button>
          </div>
          <el-input
            v-model="commentText"
            type="textarea"
            :rows="3"
            maxlength="1000"
            show-word-limit
            :placeholder="replyHint || '写下你的看法…'"
          />
          <div class="cmt-box__foot">
            <el-button type="primary" :loading="submitting" @click="submitComment">发送</el-button>
          </div>

          <div v-for="c in comments" :key="c.id" class="cmt-item">
            <button type="button" class="cmt-author" @click="openProfile(c.userId)">
              <el-avatar :size="30" :src="c.avatarUrl || undefined">
                {{ (c.nickname || 'U').slice(0, 1) }}
              </el-avatar>
              <strong>{{ c.nickname || `用户${c.userId}` }}</strong>
            </button>
            <p class="cmt-body">{{ c.content }}</p>
            <div class="cmt-ops">
              <span>{{ formatTime(c.createdAt) }}</span>
              <button type="button" @click="startReply(c)">回复</button>
              <button type="button" @click="onLikeComment(c)">
                {{ c.liked ? '已赞' : '赞' }} {{ c.likeCount || 0 }}
              </button>
              <el-dropdown
                v-if="canDeleteComment(c)"
                trigger="click"
                popper-class="cmt-more-popper"
                @command="(cmd: string) => cmd === 'delete' && onDeleteComment(c)"
              >
                <button
                  type="button"
                  class="cmt-more"
                  :disabled="deletingCommentId === c.id"
                  aria-label="更多操作"
                >
                  {{ deletingCommentId === c.id ? '…' : '···' }}
                </button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="delete" class="cmt-drop-delete">
                      删除
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>

            <div v-if="replyList(c).length" class="cmt-replies">
              <template v-if="isReplyExpanded(c.id)">
                <div
                  v-for="r in replyList(c)"
                  :key="`${c.id}-${r.id}`"
                  class="cmt-item cmt-item--reply"
                >
                  <button type="button" class="cmt-author" @click="openProfile(r.userId)">
                    <el-avatar :size="26" :src="r.avatarUrl || undefined">
                      {{ (r.nickname || 'U').slice(0, 1) }}
                    </el-avatar>
                    <strong>{{ r.nickname || `用户${r.userId}` }}</strong>
                    <span v-if="r.replyToNickname" class="cmt-to">
                      回复
                      <button
                        v-if="r.replyToUserId"
                        type="button"
                        class="cmt-at"
                        @click.stop="openProfile(r.replyToUserId)"
                      >
                        @{{ r.replyToNickname }}
                      </button>
                      <template v-else>@{{ r.replyToNickname }}</template>
                    </span>
                  </button>
                  <p class="cmt-body">{{ r.content }}</p>
                  <div class="cmt-ops">
                    <span>{{ formatTime(r.createdAt) }}</span>
                    <button type="button" @click="startReply(r)">回复</button>
                    <button type="button" @click="onLikeComment(r)">
                      {{ r.liked ? '已赞' : '赞' }} {{ r.likeCount || 0 }}
                    </button>
                    <button
                      v-if="canDeleteComment(r)"
                      type="button"
                      class="cmt-trash"
                      :disabled="deletingCommentId === r.id"
                      aria-label="删除回复"
                      @click="onDeleteComment(r)"
                    >
                      <el-icon :size="14"><Delete /></el-icon>
                    </button>
                  </div>
                </div>
                <button type="button" class="cmt-expand" @click.stop="collapseReplies(c.id)">
                  —— 收起
                </button>
              </template>
              <button
                v-else
                type="button"
                class="cmt-expand"
                @click.stop="expandReplies(c.id)"
              >
                —— 展开{{ replyList(c).length }}条回复
              </button>
            </div>
          </div>

          <p v-if="!comments.length" class="cmt-empty">还没有评论，来抢沙发吧。</p>
        </section>
      </template>
    </div>
  </CommunityWindowShell>
</template>

<style scoped>
.post-page {
  min-height: 240px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.post-main,
.cmt-box {
  padding: 18px;
  border-radius: 16px;
  background: color-mix(in srgb, var(--st-surface) 92%, transparent);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 50%, transparent);
}

.post-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.post-author {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  border: none;
  background: transparent;
  padding: 0;
  text-align: left;
  cursor: pointer;
  color: inherit;
  font: inherit;
}

.post-author p {
  margin: 2px 0 0;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.post-tag {
  padding: 2px 10px;
  border-radius: 999px;
  background: color-mix(in srgb, var(--st-primary) 12%, transparent);
  color: var(--st-primary);
  font-size: 12px;
  font-weight: 600;
}

.post-title {
  margin: 0 0 12px;
  font-size: 24px;
  line-height: 1.3;
}

.post-cover {
  width: 100%;
  max-height: 320px;
  object-fit: cover;
  border-radius: 12px;
  margin-bottom: 14px;
}

.post-content {
  white-space: pre-wrap;
  line-height: 1.7;
  font-size: 15px;
  margin-bottom: 16px;
}

.post-actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.post-delete {
  margin-left: auto;
}

.post-cmt-count {
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.cmt-box h3 {
  margin: 0 0 12px;
  font-size: 16px;
}

.cmt-reply-hint {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
  font-size: 13px;
  color: var(--st-primary);
}

.cmt-reply-hint button {
  border: none;
  background: transparent;
  color: var(--st-on-surface-variant);
  cursor: pointer;
  font: inherit;
}

.cmt-box__foot {
  display: flex;
  justify-content: flex-end;
  margin: 10px 0 18px;
}

.cmt-item {
  padding: 12px 0;
  border-top: 1px solid color-mix(in srgb, var(--st-outline-variant) 40%, transparent);
}

.cmt-item--reply {
  padding-left: 12px;
  margin-left: 18px;
  border-left: 2px solid color-mix(in srgb, var(--st-primary) 25%, transparent);
}

.cmt-author {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: none;
  background: transparent;
  padding: 0;
  cursor: pointer;
  color: inherit;
  font: inherit;
}

.cmt-to {
  font-size: 12px;
  color: var(--st-on-surface-variant);
  font-weight: 400;
  display: inline-flex;
  align-items: center;
  gap: 2px;
}

.cmt-at {
  border: none;
  background: transparent;
  padding: 0;
  margin: 0;
  font: inherit;
  font-size: 12px;
  font-weight: 600;
  color: var(--st-primary);
  cursor: pointer;
}

.cmt-at:hover {
  text-decoration: underline;
}

.cmt-body {
  margin: 8px 0;
  line-height: 1.55;
  white-space: pre-wrap;
}

.cmt-ops {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
  align-items: center;
}

.cmt-ops button {
  border: none;
  background: transparent;
  color: inherit;
  cursor: pointer;
  font: inherit;
  padding: 0;
}

.cmt-ops button:hover {
  color: var(--st-primary);
}

.cmt-more {
  letter-spacing: 0.5px;
  line-height: 1;
  padding: 0 2px !important;
  color: var(--st-on-surface-variant) !important;
}

.cmt-more:hover {
  color: var(--st-on-surface) !important;
}

.cmt-trash {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 6px;
  color: var(--st-on-surface-variant) !important;
}

.cmt-trash:hover:not(:disabled) {
  color: #ef4444 !important;
  background: color-mix(in srgb, #ef4444 12%, transparent);
}

.cmt-ops button:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.cmt-replies {
  margin-top: 4px;
}

.cmt-expand {
  display: inline-flex;
  align-items: center;
  margin: 6px 0 2px 18px;
  border: none;
  background: transparent;
  padding: 4px 0;
  font: inherit;
  font-size: 13px;
  font-weight: 600;
  color: var(--st-primary);
  cursor: pointer;
}

.cmt-expand:hover {
  text-decoration: underline;
}

.cmt-empty {
  margin: 8px 0 0;
  color: var(--st-on-surface-variant);
  font-size: 13px;
}
</style>

<style>
/* teleported 下拉，需非 scoped */
.cmt-more-popper .cmt-drop-delete {
  color: #f56c6c !important;
}

.cmt-more-popper .cmt-drop-delete:hover {
  background: color-mix(in srgb, #f56c6c 12%, transparent) !important;
  color: #f56c6c !important;
}
</style>
