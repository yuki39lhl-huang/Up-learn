<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  deleteCommunityNotification,
  deleteCommunityNotifications,
  fetchCommunityNotifications,
  markAllCommunityNotificationsRead,
  openCommunityWindow,
  type CommunityNotificationVO,
} from '../../api/community'
import { formatCommunityTime } from '../../utils/communityFormat'
import { subscribeCommunitySync } from '../../utils/communitySync'

const props = defineProps<{
  active?: boolean
}>()

const emit = defineEmits<{
  unreadChange: [count: number]
}>()

type NotifyTab = 'like' | 'reply' | 'follow'

const TABS: { key: NotifyTab; label: string }[] = [
  { key: 'like', label: '点赞收藏' },
  { key: 'reply', label: '回复我的' },
  { key: 'follow', label: '关注' },
]

const LIKE_TYPES = new Set(['POST_LIKED', 'COMMENT_LIKED', 'POST_FAVORITED'])
const REPLY_TYPES = new Set(['COMMENT_CREATED'])
const FOLLOW_TYPES = new Set(['USER_FOLLOWED'])

interface NotifyGroup {
  key: string
  tab: NotifyTab
  postId?: number
  postTitle?: string
  items: CommunityNotificationVO[]
}

const loading = ref(false)
const marking = ref(false)
const deletingId = ref<number | null>(null)
const items = ref<CommunityNotificationVO[]>([])
const tab = ref<NotifyTab>('like')
const expandedMap = ref<Record<string, boolean>>({})

const unreadCount = computed(() => items.value.filter((n) => !n.read).length)

const tabUnread = computed(() => ({
  like: items.value.filter((n) => LIKE_TYPES.has(n.type) && !n.read).length,
  reply: items.value.filter((n) => REPLY_TYPES.has(n.type) && !n.read).length,
  follow: items.value.filter((n) => FOLLOW_TYPES.has(n.type) && !n.read).length,
}))

const filtered = computed(() => {
  const set =
    tab.value === 'like' ? LIKE_TYPES : tab.value === 'reply' ? REPLY_TYPES : FOLLOW_TYPES
  return items.value.filter((n) => set.has(n.type))
})

const groups = computed((): NotifyGroup[] => {
  const list = filtered.value
  if (tab.value === 'follow') {
    return list.map((n) => ({
      key: `follow-${n.id}`,
      tab: 'follow' as const,
      items: [n],
    }))
  }
  const map = new Map<string, NotifyGroup>()
  const order: string[] = []
  for (const n of list) {
    const pid = n.postId
    const key = pid != null ? `post-${tab.value}-${pid}` : `one-${n.id}`
    let g = map.get(key)
    if (!g) {
      g = {
        key,
        tab: tab.value,
        postId: pid ?? undefined,
        postTitle: n.postTitle || undefined,
        items: [],
      }
      map.set(key, g)
      order.push(key)
    }
    g.items.push(n)
    if (!g.postTitle && n.postTitle) g.postTitle = n.postTitle
  }
  return order.map((k) => map.get(k)!)
})

const groupCountLabel = computed(() => {
  const n = groups.value.length
  if (!n) return ''
  return tab.value === 'follow' ? `${n} 项` : `${n} 组`
})

function isExpanded(key: string) {
  return expandedMap.value[key] === true
}

function toggleExpand(key: string, ev?: Event) {
  ev?.stopPropagation()
  const next = { ...expandedMap.value }
  if (next[key]) delete next[key]
  else next[key] = true
  expandedMap.value = next
}

function actorName(n: CommunityNotificationVO) {
  return n.actorNickname || (n.actorId ? `用户${n.actorId}` : '有人')
}

function actionWord(type: string) {
  switch (type) {
    case 'POST_LIKED':
      return '赞了你的帖子'
    case 'COMMENT_LIKED':
      return '赞了你的评论'
    case 'POST_FAVORITED':
      return '收藏了你的帖子'
    case 'COMMENT_CREATED':
      return '回复了你'
    case 'USER_FOLLOWED':
      return '关注了你'
    default:
      return '互动了'
  }
}

/** 按 actor 去重后的摘要 */
function uniqueActors(g: NotifyGroup) {
  const seen = new Set<number | string>()
  const list: CommunityNotificationVO[] = []
  for (const n of g.items) {
    const key = n.actorId ?? `name:${actorName(n)}`
    if (seen.has(key)) continue
    seen.add(key)
    list.push(n)
  }
  return list
}

function groupSummary(g: NotifyGroup) {
  const actors = uniqueActors(g)
  const names = actors.map(actorName)
  const n = g.items.length
  const people = actors.length
  const head = names.slice(0, 2).join('、')
  const types = new Set(g.items.map((i) => i.type))
  let verb = '互动了你的内容'
  if (g.tab === 'reply') verb = '回复了你'
  else if (types.size === 1) verb = actionWord([...types][0])
  else if ([...types].every((t) => LIKE_TYPES.has(t))) verb = '赞了/收藏了你的内容'

  if (people <= 1) return `${head} ${verb}`
  if (n <= 2 && people === n) return `${head} ${verb}`
  return `${head} 等 ${people} 人${verb}（共 ${n} 条）`
}

function groupUnread(g: NotifyGroup) {
  return g.items.some((i) => !i.read)
}

function groupTime(g: NotifyGroup) {
  return formatCommunityTime(g.items[0]?.createdAt)
}

function isGenericNotifyContent(c?: string | null) {
  if (!c?.trim()) return true
  const t = c.trim()
  return t === '评论了你的内容' || t === '互动了你的内容'
}

/** 回复类：展示最新一条回复正文 */
function groupReplySnippet(g: NotifyGroup) {
  if (g.tab !== 'reply') return ''
  const c = g.items[0]?.content?.trim()
  if (!c || isGenericNotifyContent(c)) return ''
  return c
}

function itemReplySnippet(n: CommunityNotificationVO) {
  const c = n.content?.trim()
  if (!c || isGenericNotifyContent(c)) return ''
  if (n.type !== 'COMMENT_CREATED') return ''
  return c
}

function previewAvatars(g: NotifyGroup) {
  return uniqueActors(g).slice(0, 3)
}

function openProfile(userId?: number | null, ev?: Event) {
  ev?.stopPropagation()
  if (!userId) return
  openCommunityWindow(`/community/u/${userId}`)
}

function openNotify(n?: CommunityNotificationVO | null, ev?: Event) {
  ev?.stopPropagation()
  const postId = n?.postId
  if (!postId) {
    ElMessage.info('原帖不可用或已删除')
    return
  }
  const q = n?.commentId ? `?replyTo=${n.commentId}` : ''
  openCommunityWindow(`/community/post/${postId}${q}`)
}

function openGroupPost(g: NotifyGroup, ev?: Event) {
  openNotify(g.items[0], ev)
}

function onGroupClick(g: NotifyGroup) {
  if (g.tab === 'follow') {
    openProfile(g.items[0]?.actorId)
    return
  }
  if (g.items.length > 1) {
    toggleExpand(g.key)
    return
  }
  openNotify(g.items[0])
}

async function removeOne(id: number, ev?: Event) {
  ev?.stopPropagation()
  try {
    await ElMessageBox.confirm('删除这条通知？', '删除', {
      type: 'warning',
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      confirmButtonClass: 'el-button--danger community-delete-confirm',
      cancelButtonClass: 'community-delete-cancel',
      customClass: 'community-delete-msgbox',
    })
  } catch {
    return
  }
  deletingId.value = id
  try {
    await deleteCommunityNotification(id)
    items.value = items.value.filter((n) => n.id !== id)
    emit('unreadChange', unreadCount.value)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '删除失败')
  } finally {
    deletingId.value = null
  }
}

async function removeGroup(g: NotifyGroup, ev?: Event) {
  ev?.stopPropagation()
  const ids = g.items.map((i) => i.id)
  const tip =
    ids.length > 1 ? `删除这组 ${ids.length} 条相关通知？` : '删除这条通知？'
  try {
    await ElMessageBox.confirm(tip, '删除', {
      type: 'warning',
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      confirmButtonClass: 'el-button--danger community-delete-confirm',
      cancelButtonClass: 'community-delete-cancel',
      customClass: 'community-delete-msgbox',
    })
  } catch {
    return
  }
  deletingId.value = ids[0]
  try {
    if (ids.length === 1) await deleteCommunityNotification(ids[0])
    else await deleteCommunityNotifications(ids)
    const drop = new Set(ids)
    items.value = items.value.filter((n) => !drop.has(n.id))
    const next = { ...expandedMap.value }
    delete next[g.key]
    expandedMap.value = next
    emit('unreadChange', unreadCount.value)
    ElMessage.success('已删除')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '删除失败')
  } finally {
    deletingId.value = null
  }
}

async function load() {
  loading.value = true
  try {
    items.value = (await fetchCommunityNotifications()) || []
    emit('unreadChange', unreadCount.value)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载通知失败')
  } finally {
    loading.value = false
  }
}

async function markAllRead() {
  if (!unreadCount.value) return
  marking.value = true
  try {
    await markAllCommunityNotificationsRead()
    items.value = items.value.map((n) => ({ ...n, read: true }))
    emit('unreadChange', 0)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  } finally {
    marking.value = false
  }
}

let unsub: (() => void) | null = null

onMounted(() => {
  void load()
  unsub = subscribeCommunitySync((ev) => {
    if (
      ev.type === 'comment-changed' ||
      ev.type === 'post-updated' ||
      ev.type === 'favorite-changed' ||
      ev.type === 'follow-changed'
    ) {
      void load()
    }
  })
})

watch(
  () => props.active,
  (on) => {
    if (on) void load()
  },
)

onBeforeUnmount(() => {
  unsub?.()
})

defineExpose({ reload: load, unreadCount })
</script>

<template>
  <div v-loading="loading" class="msg-center">
    <aside class="msg-side">
      <h3 class="msg-side__title">消息中心</h3>
      <nav class="msg-side__nav">
        <button
          v-for="t in TABS"
          :key="t.key"
          type="button"
          class="msg-side__item"
          :class="{ 'is-on': tab === t.key }"
          @click="tab = t.key"
        >
          <span>{{ t.label }}</span>
          <em v-if="tabUnread[t.key] > 0">{{ tabUnread[t.key] }}</em>
        </button>
      </nav>
    </aside>

    <section class="msg-main">
      <div class="msg-panel">
        <header class="msg-main__head">
          <div class="msg-main__crumb">
            <span class="msg-main__title">{{ TABS.find((t) => t.key === tab)?.label }}</span>
            <small v-if="groups.length" class="msg-main__count">{{ groupCountLabel }}</small>
          </div>
          <button
            type="button"
            class="msg-main__read"
            :disabled="!unreadCount || marking"
            @click="markAllRead"
          >
            {{ marking ? '处理中…' : '全部已读' }}
          </button>
        </header>

        <div class="msg-list">
          <div v-for="g in groups" :key="g.key" class="msg-group">
            <div
              class="msg-row"
              :class="{
                'is-unread': groupUnread(g),
                'is-open': isExpanded(g.key),
                'msg-row--snip': !!g.postTitle,
              }"
              role="button"
              tabindex="0"
              @click="onGroupClick(g)"
              @keydown.enter="onGroupClick(g)"
            >
              <div class="msg-avatars" :class="{ 'msg-avatars--stack': previewAvatars(g).length > 1 }">
                <button
                  v-for="(a, idx) in previewAvatars(g)"
                  :key="`${g.key}-av-${a.actorId}-${idx}`"
                  type="button"
                  class="msg-avatar"
                  :style="{ zIndex: 3 - idx }"
                  title="查看主页"
                  @click="openProfile(a.actorId, $event)"
                >
                  <el-avatar :size="40" :src="a.actorAvatarUrl || undefined">
                    {{ actorName(a).slice(0, 1) }}
                  </el-avatar>
                </button>
              </div>

              <div class="msg-row__body">
                <p class="msg-row__text">{{ groupSummary(g) }}</p>
                <p v-if="groupReplySnippet(g)" class="msg-row__quote">{{ groupReplySnippet(g) }}</p>
                <small>{{ groupTime(g) }}</small>
              </div>

              <button
                v-if="g.postTitle"
                type="button"
                class="msg-row__snip"
                @click="openGroupPost(g, $event)"
              >
                {{ g.postTitle }}
              </button>

              <div class="msg-row__ops">
                <button
                  v-if="g.items.length > 1"
                  type="button"
                  class="msg-row__more"
                  @click="toggleExpand(g.key, $event)"
                >
                  {{ isExpanded(g.key) ? '收起' : `展开 ${g.items.length}` }}
                </button>
                <button
                  type="button"
                  class="msg-row__del"
                  :disabled="deletingId != null"
                  title="删除"
                  @click="removeGroup(g, $event)"
                >
                  <el-icon :size="15"><Delete /></el-icon>
                </button>
              </div>
            </div>

            <ul v-if="isExpanded(g.key) && g.items.length > 1" class="msg-detail">
              <li
                v-for="n in g.items"
                :key="n.id"
                class="msg-detail__item"
                :class="{ 'is-unread': !n.read }"
              >
                <button type="button" class="msg-avatar" @click="openProfile(n.actorId)">
                  <el-avatar :size="36" :src="n.actorAvatarUrl || undefined">
                    {{ actorName(n).slice(0, 1) }}
                  </el-avatar>
                </button>
                <div class="msg-detail__body">
                  <p>
                    <button type="button" class="msg-name" @click="openProfile(n.actorId)">
                      {{ actorName(n) }}
                    </button>
                    {{ actionWord(n.type) }}
                  </p>
                  <p v-if="itemReplySnippet(n)" class="msg-detail__quote">{{ itemReplySnippet(n) }}</p>
                  <small>{{ formatCommunityTime(n.createdAt) }}</small>
                </div>
                <button type="button" class="msg-detail__go" @click="openNotify(n)">看帖子</button>
                <button
                  type="button"
                  class="msg-row__del"
                  :disabled="deletingId === n.id"
                  title="删除这条"
                  @click="removeOne(n.id, $event)"
                >
                  <el-icon :size="14"><Delete /></el-icon>
                </button>
              </li>
            </ul>
          </div>

          <p v-if="!loading && groups.length === 0" class="msg-empty">暂无此类消息</p>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.msg-center {
  display: grid;
  grid-template-columns: 168px minmax(0, 1fr);
  flex: 1;
  min-height: 0;
  align-self: stretch;
  background: color-mix(in srgb, var(--st-surface-container-low) 35%, transparent);
  overflow: hidden;
}

.msg-side {
  display: flex;
  flex-direction: column;
  min-height: 0;
  background: var(--ul-content-fill);
  border-right: 1px solid color-mix(in srgb, var(--st-outline-variant) 40%, transparent);
}

.msg-side__title {
  box-sizing: border-box;
  height: 48px;
  margin: 0;
  padding: 0 16px;
  display: flex;
  align-items: center;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.04em;
  color: var(--st-on-surface-variant);
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 28%, transparent);
}

.msg-side__nav {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 12px 10px;
  overflow: auto;
}

.msg-side__item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  width: 100%;
  border: none;
  background: transparent;
  color: var(--st-on-surface-variant);
  text-align: left;
  padding: 10px 12px 10px 14px;
  border-radius: 8px;
  font: inherit;
  font-size: 13px;
  cursor: pointer;
  transition: background 0.12s, color 0.12s;
}

.msg-side__item:hover {
  color: var(--st-on-surface);
  background: color-mix(in srgb, var(--st-on-surface) 5%, transparent);
}

.msg-side__item.is-on {
  color: var(--st-primary);
  background: color-mix(in srgb, var(--st-primary) 12%, transparent);
  font-weight: 600;
}

.msg-side__item.is-on::before {
  content: '';
  position: absolute;
  left: 0;
  top: 9px;
  bottom: 9px;
  width: 3px;
  border-radius: 2px;
  background: var(--st-primary);
}

.msg-side__item em {
  font-style: normal;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 999px;
  background: #ef4444;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  line-height: 18px;
  text-align: center;
}

.msg-main {
  min-width: 0;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding: 14px 16px 16px;
}

.msg-panel {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  background: var(--ul-content-fill-strong);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 36%, transparent);
  border-radius: 12px;
  overflow: hidden;
}

.msg-main__head {
  box-sizing: border-box;
  height: 48px;
  margin: 0;
  padding: 0 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 28%, transparent);
  background: color-mix(in srgb, var(--st-on-surface) 2%, transparent);
}

.msg-main__crumb {
  display: flex;
  align-items: baseline;
  gap: 10px;
  min-width: 0;
}

.msg-main__title {
  font-size: 14px;
  font-weight: 700;
  color: var(--st-on-surface);
}

.msg-main__count {
  font-size: 12px;
  font-weight: 500;
  color: var(--st-on-surface-variant);
}

.msg-main__read {
  border: none;
  background: transparent;
  color: var(--st-primary);
  font: inherit;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 2px;
  cursor: pointer;
  flex-shrink: 0;
}

.msg-main__read:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.msg-list {
  flex: 1;
  min-height: 0;
  overflow: auto;
}

.msg-group + .msg-group {
  border-top: 1px solid color-mix(in srgb, var(--st-outline-variant) 16%, transparent);
}

.msg-row {
  display: grid;
  grid-template-columns: 48px minmax(0, 1fr) auto;
  gap: 12px 14px;
  align-items: center;
  padding: 14px 16px;
  cursor: pointer;
  transition: background 0.12s;
}

.msg-row--snip {
  grid-template-columns: 48px minmax(0, 1fr) minmax(96px, 148px) auto;
}

.msg-row:hover {
  background: color-mix(in srgb, var(--st-on-surface) 4%, transparent);
}

.msg-row.is-unread {
  background: color-mix(in srgb, var(--st-primary) 6%, transparent);
}

.msg-row.is-unread:hover {
  background: color-mix(in srgb, var(--st-primary) 9%, transparent);
}

.msg-row:hover .msg-row__del,
.msg-detail__item:hover .msg-row__del {
  opacity: 1;
}

.msg-avatars {
  display: flex;
  align-items: center;
  width: 48px;
}

.msg-avatars--stack .msg-avatar + .msg-avatar {
  margin-left: -14px;
}

.msg-avatar {
  border: none;
  background: transparent;
  padding: 0;
  cursor: pointer;
  border-radius: 50%;
  line-height: 0;
}

.msg-avatar :deep(.el-avatar) {
  border: 2px solid color-mix(in srgb, var(--st-surface) 70%, transparent);
}

.msg-row__body {
  min-width: 0;
}

.msg-row__text {
  margin: 0 0 4px;
  font-size: 14px;
  line-height: 1.45;
  color: var(--st-on-surface);
}

.msg-row__quote,
.msg-detail__quote {
  margin: 0 0 4px;
  font-size: 13px;
  line-height: 1.45;
  color: var(--st-on-surface-variant);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  word-break: break-word;
}

.msg-row__body small,
.msg-detail__body small {
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.msg-row__snip {
  max-height: 52px;
  overflow: hidden;
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 45%, transparent);
  font: inherit;
  font-size: 12px;
  line-height: 1.4;
  text-align: left;
  color: var(--st-on-surface-variant);
  background: var(--ul-content-fill);
  border-radius: 6px;
  padding: 8px 10px;
  cursor: pointer;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.msg-row__snip:hover {
  color: var(--st-primary);
  border-color: color-mix(in srgb, var(--st-primary) 45%, transparent);
}

.msg-row__ops {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
  min-width: 28px;
}

.msg-row__more {
  border: none;
  background: transparent;
  font: inherit;
  font-size: 12px;
  color: var(--st-primary);
  font-weight: 600;
  white-space: nowrap;
  cursor: pointer;
  padding: 4px 2px;
}

.msg-row__del {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border: none;
  border-radius: 8px;
  background: transparent;
  color: var(--st-on-surface-variant);
  cursor: pointer;
  opacity: 0.28;
  transition: opacity 0.12s, background 0.12s, color 0.12s;
}

.msg-row__del:hover:not(:disabled) {
  color: #ef4444;
  background: color-mix(in srgb, #ef4444 12%, transparent);
  opacity: 1;
}

.msg-row__del:disabled {
  cursor: not-allowed;
}

.msg-detail {
  list-style: none;
  margin: 0;
  padding: 0 16px 12px 78px;
  background: color-mix(in srgb, var(--st-on-surface) 2.5%, transparent);
  border-top: 1px solid color-mix(in srgb, var(--st-outline-variant) 16%, transparent);
}

.msg-detail__item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 0;
  border-top: 1px solid color-mix(in srgb, var(--st-outline-variant) 14%, transparent);
}

.msg-detail__item:first-child {
  border-top: none;
}

.msg-detail__body {
  flex: 1;
  min-width: 0;
}

.msg-detail__body p {
  margin: 0 0 2px;
  font-size: 13px;
}

.msg-name {
  border: none;
  background: transparent;
  padding: 0;
  font: inherit;
  font-weight: 700;
  color: var(--st-on-surface);
  cursor: pointer;
}

.msg-name:hover {
  color: var(--st-primary);
}

.msg-detail__go {
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 50%, transparent);
  background: transparent;
  border-radius: 6px;
  padding: 4px 10px;
  font: inherit;
  font-size: 12px;
  cursor: pointer;
  color: var(--st-on-surface-variant);
  white-space: nowrap;
}

.msg-detail__go:hover {
  color: var(--st-primary);
  border-color: var(--st-primary);
}

.msg-empty {
  margin: 72px 16px;
  text-align: center;
  color: var(--st-on-surface-variant);
  font-size: 13px;
}

@media (max-width: 720px) {
  .msg-center {
    grid-template-columns: 1fr;
    grid-template-rows: auto minmax(0, 1fr);
  }

  .msg-side {
    border-right: none;
    border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 28%, transparent);
  }

  .msg-side__nav {
    flex-direction: row;
    flex-wrap: wrap;
    padding: 8px 10px;
  }

  .msg-side__item {
    width: auto;
    padding: 8px 12px;
  }

  .msg-side__item.is-on::before {
    display: none;
  }

  .msg-main {
    padding: 10px;
  }

  .msg-row,
  .msg-row--snip {
    grid-template-columns: 48px minmax(0, 1fr);
  }

  .msg-row__snip,
  .msg-row__ops {
    grid-column: 2;
  }

  .msg-row__ops {
    justify-content: flex-start;
  }

  .msg-row__del {
    opacity: 1;
  }

  .msg-detail {
    padding-left: 16px;
  }
}
</style>
