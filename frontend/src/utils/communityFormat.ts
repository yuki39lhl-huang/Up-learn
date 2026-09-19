/** 社区时间展示：2026-09-19 15:51 */
export function formatCommunityTime(v?: string | null) {
  if (!v) return ''
  return String(v).replace('T', ' ').slice(0, 16)
}

/** 帖子摘要截断 */
export function excerptCommunityText(text: string, max = 120) {
  const t = (text || '').replace(/\s+/g, ' ').trim()
  return t.length > max ? `${t.slice(0, max)}…` : t
}
