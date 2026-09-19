<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  fetchCommunityProfile,
  fetchMyFavoritePosts,
  fetchUserCommunityPosts,
  fetchUserFollowers,
  fetchUserFollowing,
  openCommunityWindow,
  toggleFollowUser,
  type CommunityFollowUserVO,
  type CommunityPostVO,
  type CommunityProfileVO,
} from '../../api/community'
import { updateUserProfile } from '../../api/user'
import { useAuthStore } from '../../stores/auth'
import { excerptCommunityText, formatCommunityTime } from '../../utils/communityFormat'
import { publishCommunitySync, subscribeCommunitySync } from '../../utils/communitySync'
import CommunityWindowShell from './CommunityWindowShell.vue'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const userId = computed(() => Number(route.params.userId))

const loading = ref(true)
const profile = ref<CommunityProfileVO | null>(null)
const posts = ref<CommunityPostVO[]>([])
const page = ref(1)
const total = ref(0)
const followBusy = ref(false)
/** 本人主页：帖子 / 收藏 */
const contentTab = ref<'posts' | 'favorites'>('posts')

const isSelf = computed(() => auth.user?.userId === userId.value)

const editBio = ref('')
const editShowFollow = ref(true)
const saving = ref(false)

const listOpen = ref(false)
const listKind = ref<'following' | 'followers'>('following')
const listLoading = ref(false)
const listUsers = ref<CommunityFollowUserVO[]>([])

function formatTime(v?: string | null) {
  return formatCommunityTime(v)
}

function excerpt(text: string, max = 100) {
  return excerptCommunityText(text, max)
}

async function loadProfile() {
  profile.value = await fetchCommunityProfile(userId.value)
  if (isSelf.value && profile.value) {
    editBio.value = profile.value.bio || ''
    editShowFollow.value = profile.value.showFollowList !== false
  }
}

async function loadPosts(reset = true) {
  if (reset) page.value = 1
  const data =
    isSelf.value && contentTab.value === 'favorites'
      ? await fetchMyFavoritePosts(page.value, 10)
      : await fetchUserCommunityPosts(userId.value, page.value, 10)
  posts.value = data.list || []
  total.value = data.total || 0
}

async function switchContentTab(tab: 'posts' | 'favorites') {
  if (contentTab.value === tab) return
  contentTab.value = tab
  loading.value = true
  try {
    await loadPosts(true)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

async function loadAll() {
  loading.value = true
  try {
    contentTab.value = 'posts'
    await Promise.all([loadProfile(), loadPosts(true)])
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载主页失败')
  } finally {
    loading.value = false
  }
}

async function onFollow() {
  if (!profile.value || isSelf.value) return
  followBusy.value = true
  try {
    const { followed } = await toggleFollowUser(userId.value)
    profile.value.followedByMe = followed
    profile.value.followerCount = Math.max(
      0,
      (profile.value.followerCount || 0) + (followed ? 1 : -1),
    )
    ElMessage.success(followed ? '已关注' : '已取消关注')
    publishCommunitySync({ type: 'follow-changed', userId: userId.value })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  } finally {
    followBusy.value = false
  }
}

async function saveSettings() {
  if (!isSelf.value) return
  const bio = editBio.value.trim()
  if (bio.length > 200) {
    ElMessage.warning('简介不能超过 200 字')
    return
  }
  saving.value = true
  try {
    await updateUserProfile({
      bio,
      showFollowList: editShowFollow.value,
    })
    ElMessage.success('已保存')
    await loadProfile()
    publishCommunitySync({ type: 'profile-changed', userId: userId.value })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    saving.value = false
  }
}

async function openFollowList(kind: 'following' | 'followers') {
  if (!profile.value) return
  if (!isSelf.value && !profile.value.canViewFollowList) {
    ElMessage.info('对方已关闭关注/粉丝列表公开')
    return
  }
  listKind.value = kind
  listOpen.value = true
  listLoading.value = true
  listUsers.value = []
  try {
    listUsers.value =
      kind === 'following'
        ? await fetchUserFollowing(userId.value)
        : await fetchUserFollowers(userId.value)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
    listOpen.value = false
  } finally {
    listLoading.value = false
  }
}

function openUser(uid: number) {
  listOpen.value = false
  if (uid === userId.value) return
  void router.push(`/community/u/${uid}`)
}

function openPost(id: number) {
  openCommunityWindow(`/community/post/${id}`)
}

watch(userId, () => {
  void loadAll()
})

let unsubSync: (() => void) | null = null
let syncTimer: ReturnType<typeof setTimeout> | null = null

onMounted(() => {
  void loadAll()
  unsubSync = subscribeCommunitySync((ev) => {
    const uid = userId.value
    const related =
      ev.userId === uid ||
      (isSelf.value && (ev.type === 'favorite-changed' || ev.type === 'post-created'))
    if (!related) return
    if (syncTimer) clearTimeout(syncTimer)
    syncTimer = setTimeout(() => {
      syncTimer = null
      void loadProfile()
      void loadPosts(false)
    }, 280)
  })
})

onBeforeUnmount(() => {
  unsubSync?.()
  if (syncTimer) clearTimeout(syncTimer)
})
</script>

<template>
  <CommunityWindowShell :title="isSelf ? '个人主页 / 设置' : '个人主页'">
    <div v-loading="loading" class="profile-page">
      <section v-if="profile" class="profile-head">
        <el-avatar :size="72" :src="profile.avatarUrl || undefined">
          {{ (profile.nickname || 'U').slice(0, 1) }}
        </el-avatar>
        <div class="profile-head__info">
          <h2>{{ profile.nickname || `用户${profile.userId}` }}</h2>
          <p v-if="profile.province || profile.majorCategory" class="profile-exam">
            <span v-if="profile.province">{{ profile.province }}</span>
            <span v-if="profile.province && profile.majorCategory"> · </span>
            <span v-if="profile.majorCategory">{{ profile.majorCategory }}</span>
            <span class="profile-exam__hint">（来自备考设置）</span>
          </p>
          <p
            v-if="profile.targetSchools && profile.targetSchools.length"
            class="profile-targets"
          >
            <span class="profile-targets__label">目标院校</span>
            <span
              v-for="(name, idx) in profile.targetSchools"
              :key="`${idx}-${name}`"
              class="profile-targets__item"
            >
              {{ name }}
            </span>
          </p>
          <p v-if="profile.bio" class="profile-bio">{{ profile.bio }}</p>
          <p v-else-if="!isSelf" class="profile-bio profile-bio--empty">暂无简介</p>
          <div class="profile-stats">
            <span>帖子 {{ profile.postCount || 0 }}</span>
            <button
              type="button"
              class="profile-stat-btn"
              :disabled="!isSelf && !profile.canViewFollowList"
              @click="openFollowList('following')"
            >
              关注 {{ profile.followingCount || 0 }}
            </button>
            <button
              type="button"
              class="profile-stat-btn"
              :disabled="!isSelf && !profile.canViewFollowList"
              @click="openFollowList('followers')"
            >
              粉丝 {{ profile.followerCount || 0 }}
            </button>
          </div>
        </div>
        <el-button
          v-if="!isSelf"
          type="primary"
          :loading="followBusy"
          :plain="!!profile.followedByMe"
          @click="onFollow"
        >
          {{ profile.followedByMe ? '已关注' : '关注' }}
        </el-button>
      </section>

      <section v-if="isSelf" class="profile-settings">
        <h3>个人设置</h3>
        <label class="profile-label">简介（最多 200 字）</label>
        <el-input
          v-model="editBio"
          type="textarea"
          :rows="3"
          maxlength="200"
          show-word-limit
          placeholder="介绍一下你的备考方向、目标院校…"
        />
        <div class="profile-switch">
          <span>公开关注 / 粉丝列表</span>
          <el-switch v-model="editShowFollow" />
        </div>
        <p class="profile-hint">关闭后，他人无法点击查看你的关注与粉丝；你自己仍可查看。</p>
        <div class="profile-settings__foot">
          <el-button type="primary" :loading="saving" @click="saveSettings">保存</el-button>
        </div>
      </section>

      <section class="profile-posts">
        <div v-if="isSelf" class="profile-tabs">
          <button
            type="button"
            class="profile-tabs__btn"
            :class="{ 'is-on': contentTab === 'posts' }"
            @click="switchContentTab('posts')"
          >
            我的帖子
          </button>
          <button
            type="button"
            class="profile-tabs__btn"
            :class="{ 'is-on': contentTab === 'favorites' }"
            @click="switchContentTab('favorites')"
          >
            我的收藏
          </button>
        </div>
        <h3 v-else>Ta 的帖子</h3>
        <article
          v-for="p in posts"
          :key="p.id"
          class="profile-post"
          @click="openPost(p.id)"
        >
          <div>
            <h4>{{ p.title }}</h4>
            <p>{{ excerpt(p.content) }}</p>
            <div class="profile-post__meta">
              <span v-if="contentTab === 'favorites' && p.nickname">{{ p.nickname }}</span>
              <span>{{ formatTime(p.createdAt) }}</span>
              <span>赞 {{ p.likeCount || 0 }}</span>
              <span>评 {{ p.commentCount || 0 }}</span>
            </div>
          </div>
          <img v-if="p.coverUrl" :src="p.coverUrl" alt="" />
        </article>
        <p v-if="!loading && posts.length === 0" class="profile-empty">
          {{
            contentTab === 'favorites'
              ? '还没有收藏帖子，去信息流点「收藏」吧'
              : '还没有发过帖子'
          }}
        </p>
        <div v-if="total > 10" class="profile-pager">
          <el-pagination
            layout="prev, pager, next"
            :total="total"
            :page-size="10"
            :current-page="page"
            @current-change="
              (p: number) => {
                page = p
                loadPosts(false)
              }
            "
          />
        </div>
      </section>
    </div>

    <el-drawer
      v-model="listOpen"
      :title="listKind === 'following' ? '关注' : '粉丝'"
      size="360px"
      append-to-body
    >
      <div v-loading="listLoading" class="follow-list">
        <button
          v-for="u in listUsers"
          :key="u.userId"
          type="button"
          class="follow-item"
          @click="openUser(u.userId)"
        >
          <el-avatar :size="36" :src="u.avatarUrl || undefined">
            {{ (u.nickname || 'U').slice(0, 1) }}
          </el-avatar>
          <span>{{ u.nickname || `用户${u.userId}` }}</span>
        </button>
        <p v-if="!listLoading && listUsers.length === 0" class="profile-empty">暂无数据</p>
      </div>
    </el-drawer>
  </CommunityWindowShell>
</template>

<style scoped>
.profile-page {
  display: flex;
  flex-direction: column;
  gap: 16px;
  min-height: 240px;
}

.profile-head,
.profile-posts,
.profile-settings {
  padding: 18px;
  border-radius: 16px;
  background: color-mix(in srgb, var(--st-surface) 92%, transparent);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 50%, transparent);
}

.profile-head {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  gap: 16px;
}

.profile-head__info {
  flex: 1;
  min-width: 160px;
}

.profile-head__info h2 {
  margin: 0 0 6px;
  font-size: 22px;
}

.profile-exam {
  margin: 0 0 8px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.profile-exam__hint {
  opacity: 0.7;
  font-size: 12px;
}

.profile-targets {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 6px;
  margin: 0 0 8px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.profile-targets__label {
  flex-shrink: 0;
  color: var(--st-primary);
  font-weight: 600;
  margin-right: 2px;
}

.profile-targets__item {
  display: inline-flex;
  align-items: center;
  max-width: 100%;
  padding: 2px 10px;
  border-radius: 999px;
  background: color-mix(in srgb, var(--st-primary) 12%, transparent);
  color: var(--st-on-surface);
  font-size: 12px;
  line-height: 1.4;
}

.profile-bio {
  margin: 0 0 10px;
  font-size: 14px;
  line-height: 1.55;
  white-space: pre-wrap;
}

.profile-bio--empty {
  color: var(--st-on-surface-variant);
}

.profile-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  align-items: center;
}

.profile-stat-btn {
  border: none;
  background: transparent;
  padding: 0;
  font: inherit;
  color: inherit;
  cursor: pointer;
}

.profile-stat-btn:hover:not(:disabled) {
  color: var(--st-primary);
  text-decoration: underline;
}

.profile-stat-btn:disabled {
  cursor: default;
  opacity: 0.65;
}

.profile-settings h3,
.profile-posts h3 {
  margin: 0 0 12px;
  font-size: 15px;
}

.profile-tabs {
  display: inline-flex;
  gap: 4px;
  margin-bottom: 12px;
  padding: 3px;
  border-radius: 999px;
  background: color-mix(in srgb, var(--st-surface-variant) 55%, transparent);
}

.profile-tabs__btn {
  border: none;
  background: transparent;
  color: var(--st-on-surface-variant);
  font: inherit;
  font-size: 13px;
  font-weight: 600;
  padding: 7px 14px;
  border-radius: 999px;
  cursor: pointer;
}

.profile-tabs__btn.is-on {
  background: var(--st-surface);
  color: var(--st-primary);
  box-shadow: 0 1px 2px rgb(0 0 0 / 6%);
}

.profile-label {
  display: block;
  margin-bottom: 6px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.profile-switch {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 14px;
  font-size: 14px;
}

.profile-hint {
  margin: 8px 0 0;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.profile-settings__foot {
  display: flex;
  justify-content: flex-end;
  margin-top: 14px;
}

.profile-post {
  display: flex;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 40%, transparent);
  cursor: pointer;
}

.profile-post:hover h4 {
  color: var(--st-primary);
}

.profile-post h4 {
  margin: 0 0 6px;
  font-size: 16px;
}

.profile-post p {
  margin: 0 0 8px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  line-height: 1.5;
}

.profile-post__meta {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.profile-post img {
  width: 96px;
  height: 64px;
  object-fit: cover;
  border-radius: 8px;
  flex-shrink: 0;
}

.profile-empty {
  margin: 16px 0 0;
  color: var(--st-on-surface-variant);
  font-size: 13px;
}

.profile-pager {
  display: flex;
  justify-content: center;
  padding-top: 12px;
}

.follow-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-height: 120px;
}

.follow-item {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  border: none;
  background: transparent;
  padding: 10px 4px;
  text-align: left;
  font: inherit;
  cursor: pointer;
  border-radius: 8px;
  color: var(--st-on-surface);
}

.follow-item:hover {
  background: color-mix(in srgb, var(--st-primary) 8%, transparent);
}
</style>
