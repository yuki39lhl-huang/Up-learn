<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import {
  fetchCommunityFeed,
  openCommunityWindow,
  type CommunityFeedTab,
  type CommunityPostVO,
} from '../../api/community'
import { useAuthStore } from '../../stores/auth'
import { excerptCommunityText, formatCommunityTime } from '../../utils/communityFormat'
import { subscribeCommunitySync } from '../../utils/communitySync'

const auth = useAuthStore()
const tab = ref<CommunityFeedTab>('recommend')
const kw = ref('')
const loading = ref(false)
const page = ref(1)
const total = ref(0)
const posts = ref<CommunityPostVO[]>([])
const hotPosts = ref<CommunityPostVO[]>([])

let refreshTimer: ReturnType<typeof setTimeout> | null = null

function scheduleRefresh(resetPage = false) {
  if (refreshTimer) clearTimeout(refreshTimer)
  refreshTimer = setTimeout(() => {
    refreshTimer = null
    void loadFeed(resetPage)
    // 当前已是热门 tab 时复用 feed，避免重复请求
    if (tab.value !== 'hot') void loadHot()
  }, 280)
}

const TABS: { key: CommunityFeedTab; label: string }[] = [
  { key: 'recommend', label: '推荐' },
  { key: 'hot', label: '热门' },
  { key: 'following', label: '关注' },
]

async function loadFeed(reset = true) {
  if (reset) page.value = 1
  loading.value = true
  try {
    const data = await fetchCommunityFeed({
      tab: tab.value,
      kw: kw.value.trim() || undefined,
      page: page.value,
      size: 10,
    })
    posts.value = data.list || []
    total.value = data.total || 0
    if (tab.value === 'hot' && page.value === 1 && !kw.value.trim()) {
      hotPosts.value = (data.list || []).slice(0, 8)
    }
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载信息流失败')
  } finally {
    loading.value = false
  }
}

async function loadHot() {
  try {
    const data = await fetchCommunityFeed({ tab: 'hot', page: 1, size: 8 })
    hotPosts.value = data.list || []
  } catch {
    hotPosts.value = []
  }
}

function onSearch() {
  void loadFeed(true)
}

function openCompose() {
  openCommunityWindow('/community/compose')
}

function openMyProfile() {
  const id = auth.user?.userId
  if (!id) {
    ElMessage.warning('请先登录')
    return
  }
  openCommunityWindow(`/community/u/${id}`)
}

function openPost(id: number) {
  openCommunityWindow(`/community/post/${id}`)
}

function openProfile(userId: number) {
  openCommunityWindow(`/community/u/${userId}`)
}

function onVisibility() {
  if (document.visibilityState === 'visible') scheduleRefresh()
}

watch(tab, () => {
  void loadFeed(true)
})

let unsubSync: (() => void) | null = null

onMounted(() => {
  void loadFeed(true)
  void loadHot()
  unsubSync = subscribeCommunitySync((ev) => {
    if (
      ev.type === 'post-created' ||
      ev.type === 'post-updated' ||
      ev.type === 'post-deleted' ||
      ev.type === 'comment-changed' ||
      ev.type === 'favorite-changed' ||
      ev.type === 'follow-changed'
    ) {
      scheduleRefresh(ev.type === 'post-created' || ev.type === 'post-deleted')
    }
  })
  document.addEventListener('visibilitychange', onVisibility)
})

onBeforeUnmount(() => {
  unsubSync?.()
  document.removeEventListener('visibilitychange', onVisibility)
  if (refreshTimer) clearTimeout(refreshTimer)
})
</script>

<template>
  <div class="module-shell community-panel">
    <section class="module-card community-panel__card">
      <header class="community-panel__toolbar">
        <div class="community-tabs" role="tablist">
          <button
            v-for="item in TABS"
            :key="item.key"
            type="button"
            class="community-tabs__btn"
            :class="{ 'is-active': tab === item.key }"
            role="tab"
            :aria-selected="tab === item.key"
            @click="tab = item.key"
          >
            {{ item.label }}
          </button>
        </div>
        <div class="community-panel__actions">
          <el-input
            v-model="kw"
            class="community-search"
            clearable
            placeholder="搜索帖子标题 / 正文"
            @keyup.enter="onSearch"
          >
            <template #append>
              <el-button @click="onSearch">搜索</el-button>
            </template>
          </el-input>
          <el-button type="primary" @click="openCompose">发布</el-button>
          <button
            type="button"
            class="community-me"
            title="个人主页 / 设置"
            @click="openMyProfile"
          >
            <el-avatar :size="32" :src="auth.user?.avatarUrl || undefined">
              {{ (auth.user?.nickname || '我').slice(0, 1) }}
            </el-avatar>
          </button>
        </div>
      </header>

      <div class="community-layout">
        <div v-loading="loading" class="community-feed">
          <article
            v-for="post in posts"
            :key="post.id"
            class="community-post-card"
            @click="openPost(post.id)"
          >
            <div class="community-post-card__main">
              <div class="community-post-card__meta">
                <button
                  type="button"
                  class="community-author"
                  @click.stop="openProfile(post.userId)"
                >
                  <el-avatar :size="28" :src="post.avatarUrl || undefined">
                    {{ (post.nickname || 'U').slice(0, 1) }}
                  </el-avatar>
                  <span>{{ post.nickname || `用户${post.userId}` }}</span>
                </button>
                <span v-if="post.tag" class="community-tag">{{ post.tag }}</span>
                <span class="community-time">{{ formatCommunityTime(post.createdAt) }}</span>
              </div>
              <h3 class="community-post-card__title">{{ post.title }}</h3>
              <p class="community-post-card__excerpt">{{ excerptCommunityText(post.content) }}</p>
              <div class="community-post-card__stats">
                <span>赞 {{ post.likeCount || 0 }}</span>
                <span>评 {{ post.commentCount || 0 }}</span>
                <span>藏 {{ post.favoriteCount || 0 }}</span>
              </div>
            </div>
            <img
              v-if="post.coverUrl"
              class="community-post-card__cover"
              :src="post.coverUrl"
              alt=""
            />
          </article>

          <div v-if="!loading && posts.length === 0" class="community-empty">
            <h3>{{ tab === 'following' ? '关注流还是空的' : '还没有帖子' }}</h3>
            <p>
              {{
                tab === 'following'
                  ? '先去关注几位同学，或切换到「推荐」看看。'
                  : '点击右上角「发布」，分享院校 / 专业 / 备考经验。'
              }}
            </p>
          </div>

          <div v-if="total > 10" class="community-pager">
            <el-pagination
              layout="prev, pager, next"
              :total="total"
              :page-size="10"
              :current-page="page"
              @current-change="
                (p: number) => {
                  page = p
                  loadFeed(false)
                }
              "
            />
          </div>
        </div>

        <aside class="community-hot">
          <h3 class="community-hot__title">热榜</h3>
          <ol class="community-hot__list">
            <li v-for="(item, idx) in hotPosts" :key="item.id">
              <button type="button" class="community-hot__item" @click="openPost(item.id)">
                <span class="community-hot__rank" :class="{ 'is-top': idx < 3 }">{{ idx + 1 }}</span>
                <span class="community-hot__text">{{ item.title }}</span>
              </button>
            </li>
          </ol>
          <p v-if="hotPosts.length === 0" class="community-hot__empty">暂无热帖</p>
        </aside>
      </div>
    </section>
  </div>
</template>

<style scoped>
.community-panel__card {
  display: flex;
  flex-direction: column;
  min-height: 0;
  gap: 0;
  padding: 0;
  overflow: hidden;
}

.community-panel__toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 18px;
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 55%, transparent);
}

.community-tabs {
  display: inline-flex;
  gap: 4px;
  padding: 3px;
  border-radius: 999px;
  background: color-mix(in srgb, var(--st-surface-variant) 55%, transparent);
}

.community-tabs__btn {
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

.community-tabs__btn.is-active {
  background: var(--st-surface);
  color: var(--st-primary);
  box-shadow: 0 1px 2px rgb(0 0 0 / 6%);
}

.community-panel__actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.community-me {
  border: none;
  background: transparent;
  padding: 0;
  cursor: pointer;
  border-radius: 50%;
  line-height: 0;
}

.community-me:hover {
  outline: 2px solid color-mix(in srgb, var(--st-primary) 45%, transparent);
  outline-offset: 2px;
}

.community-search {
  width: min(280px, 100%);
}

.community-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 260px;
  gap: 0;
  min-height: 0;
  flex: 1;
}

.community-feed {
  min-height: 320px;
  padding: 8px 12px 20px;
  overflow: auto;
}

.community-post-card {
  display: flex;
  gap: 14px;
  padding: 16px 10px;
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 45%, transparent);
  cursor: pointer;
  transition: background 0.15s ease;
}

.community-post-card:hover {
  background: color-mix(in srgb, var(--st-primary) 4%, transparent);
}

.community-post-card__main {
  flex: 1;
  min-width: 0;
}

.community-post-card__meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.community-author {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: none;
  background: transparent;
  padding: 0;
  color: inherit;
  font: inherit;
  cursor: pointer;
}

.community-author:hover {
  color: var(--st-primary);
}

.community-tag {
  padding: 1px 8px;
  border-radius: 999px;
  background: color-mix(in srgb, var(--st-primary) 12%, transparent);
  color: var(--st-primary);
  font-weight: 600;
}

.community-post-card__title {
  margin: 0 0 6px;
  font-size: 17px;
  font-weight: 700;
  line-height: 1.35;
  color: var(--st-on-surface);
}

.community-post-card__excerpt {
  margin: 0 0 10px;
  font-size: 13px;
  line-height: 1.55;
  color: var(--st-on-surface-variant);
}

.community-post-card__stats {
  display: flex;
  gap: 14px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.community-post-card__cover {
  width: 112px;
  height: 76px;
  object-fit: cover;
  border-radius: 10px;
  flex-shrink: 0;
  background: var(--st-surface-variant);
}

.community-empty {
  padding: 48px 16px;
  text-align: center;
  color: var(--st-on-surface-variant);
}

.community-empty h3 {
  margin: 0 0 8px;
  color: var(--st-on-surface);
}

.community-pager {
  display: flex;
  justify-content: center;
  padding: 16px 0 4px;
}

.community-hot {
  padding: 16px 16px 20px;
  border-left: 1px solid color-mix(in srgb, var(--st-outline-variant) 55%, transparent);
  background: color-mix(in srgb, var(--st-surface-variant) 28%, transparent);
}

.community-hot__title {
  margin: 0 0 12px;
  font-size: 14px;
  font-weight: 700;
}

.community-hot__list {
  margin: 0;
  padding: 0;
  list-style: none;
}

.community-hot__item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  width: 100%;
  border: none;
  background: transparent;
  padding: 8px 0;
  text-align: left;
  font: inherit;
  cursor: pointer;
  color: var(--st-on-surface);
}

.community-hot__item:hover .community-hot__text {
  color: var(--st-primary);
}

.community-hot__rank {
  width: 18px;
  flex-shrink: 0;
  font-size: 13px;
  font-weight: 700;
  color: var(--st-on-surface-variant);
}

.community-hot__rank.is-top {
  color: var(--st-primary);
}

.community-hot__text {
  font-size: 13px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.community-hot__empty {
  margin: 0;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

@media (max-width: 960px) {
  .community-layout {
    grid-template-columns: 1fr;
  }

  .community-hot {
    border-left: none;
    border-top: 1px solid color-mix(in srgb, var(--st-outline-variant) 55%, transparent);
  }

  .community-post-card__cover {
    width: 88px;
    height: 64px;
  }
}
</style>
