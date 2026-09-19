/**
 * 社区跨窗口同步：发帖 / 互动后通知主展示区与其它社区窗刷新，无需整页 F5。
 * 优先 BroadcastChannel；不支持时回落 localStorage 事件。
 */

export type CommunitySyncType =
  | 'post-created'
  | 'post-updated'
  | 'post-deleted'
  | 'comment-changed'
  | 'favorite-changed'
  | 'follow-changed'
  | 'profile-changed'

export interface CommunitySyncPayload {
  type: CommunitySyncType
  postId?: number
  userId?: number
  at?: number
}

const CHANNEL = 'ul-community-sync'
const STORAGE_KEY = 'ul-community-sync-ping'

type Handler = (payload: CommunitySyncPayload) => void

let channel: BroadcastChannel | null = null
const handlers = new Set<Handler>()

function ensureChannel() {
  if (typeof window === 'undefined') return null
  if (channel) return channel
  if (typeof BroadcastChannel === 'undefined') return null
  channel = new BroadcastChannel(CHANNEL)
  channel.onmessage = (ev: MessageEvent<CommunitySyncPayload>) => {
    dispatch(ev.data)
  }
  return channel
}

function dispatch(payload: CommunitySyncPayload | null | undefined) {
  if (!payload?.type) return
  for (const h of handlers) {
    try {
      h(payload)
    } catch {
      // ignore subscriber errors
    }
  }
}

function onStorage(ev: StorageEvent) {
  if (ev.key !== STORAGE_KEY || !ev.newValue) return
  try {
    dispatch(JSON.parse(ev.newValue) as CommunitySyncPayload)
  } catch {
    // ignore
  }
}

/** 发布同步事件。BroadcastChannel 不回传给发送页；其它窗口靠 BC / storage 接收。 */
export function publishCommunitySync(payload: Omit<CommunitySyncPayload, 'at'> & { at?: number }) {
  const full: CommunitySyncPayload = { ...payload, at: payload.at ?? Date.now() }
  const ch = ensureChannel()
  if (ch) {
    ch.postMessage(full)
  }
  try {
    // 用时间戳 value，避免立刻 remove 导致其它页签漏收 storage 事件
    localStorage.setItem(STORAGE_KEY, JSON.stringify(full))
  } catch {
    // private mode 等
  }
  // 不再本页自 dispatch：详情页乐观更新后无需再全量重拉
}

/** 订阅；返回取消函数 */
export function subscribeCommunitySync(handler: Handler): () => void {
  ensureChannel()
  if (typeof window !== 'undefined' && handlers.size === 0) {
    window.addEventListener('storage', onStorage)
  }
  handlers.add(handler)
  return () => {
    handlers.delete(handler)
    if (handlers.size === 0 && typeof window !== 'undefined') {
      window.removeEventListener('storage', onStorage)
      if (channel) {
        channel.close()
        channel = null
      }
    }
  }
}
