import request, { getData } from './request'
import { useAuthStore } from '../stores/auth'
import type { ChatReplyVO, Result } from '../types/api'

const SESSION_KEY = 'ul_agent_session'

export function getAgentSessionId(): string {
  let id = localStorage.getItem(SESSION_KEY)
  if (!id) {
    id = crypto.randomUUID().replace(/-/g, '')
    localStorage.setItem(SESSION_KEY, id)
  }
  return id
}

export function resetAgentSession(): string {
  const id = crypto.randomUUID().replace(/-/g, '')
  localStorage.setItem(SESSION_KEY, id)
  return id
}

/** 同步对话（备用） */
export function chatSync(message: string, sessionId?: string) {
  return getData<ChatReplyVO>(
    request.post('/agent/chat', { message, sessionId: sessionId ?? getAgentSessionId() })
  )
}

/** 流式对话：onChunk 收到当前累积全文 */
export async function chatStream(
  message: string,
  sessionId: string,
  onChunk: (accumulated: string) => void,
  signal?: AbortSignal
): Promise<void> {
  const auth = useAuthStore()
  const params = new URLSearchParams({ message, sessionId })
  const res = await fetch(`/api/agent/chat/stream?${params}`, {
    headers: auth.accessToken ? { Authorization: `Bearer ${auth.accessToken}` } : {},
    signal,
  })

  if (!res.ok) {
    let msg = `请求失败 (${res.status})`
    try {
      const body = (await res.json()) as Result<unknown>
      if (body.msg) msg = body.msg
    } catch {
      /* ignore */
    }
    throw new Error(msg)
  }

  const reader = res.body?.getReader()
  if (!reader) throw new Error('无法读取响应流')

  const decoder = new TextDecoder()
  let buffer = ''
  while (true) {
    const { done, value } = await reader.read()
    if (done) break
    buffer += decoder.decode(value, { stream: true })
    onChunk(buffer)
  }
}
