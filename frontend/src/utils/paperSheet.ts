/**
 * 卷面排版：有阅读材料时按 seq 穿插（原文→紧随题目），贴近纸质 PDF；
 * 无材料时仍按题型分大题。
 */
import type { PaperQuestionVO } from '../types/api'

export type SheetSection = {
  key: string
  title: string | null
  items: PaperQuestionVO[]
}

const TYPE_ORDER = ['choice', 'fill', 'calc', 'essay'] as const

const TYPE_LABELS: Record<string, string> = {
  choice: '一、单项选择题',
  fill: '二、填空题',
  calc: '三、计算题',
  essay: '四、写作 / 问答题',
}

export function sortBySeq(qs: PaperQuestionVO[]): PaperQuestionVO[] {
  return [...qs].sort((a, b) => a.seq - b.seq)
}

/** 卷面展示题号：材料不计号，其余按出现顺序 1、2、3…（与 PDF 一致） */
export function displayQuestionNo(q: PaperQuestionVO, ordered: PaperQuestionVO[]): number | null {
  if (q.qType === 'material') return null
  let n = 0
  for (const item of ordered) {
    if (item.qType === 'material') continue
    n += 1
    if (item.id === q.id) return n
  }
  return q.seq
}

export function buildSheetSections(qs: PaperQuestionVO[]): SheetSection[] {
  const ordered = sortBySeq(qs)
  if (!ordered.length) return []

  // 英语等：材料与题目按卷面顺序穿插
  if (ordered.some((q) => q.qType === 'material')) {
    return [{ key: 'flow', title: null, items: ordered }]
  }

  const groups: SheetSection[] = []
  for (const key of TYPE_ORDER) {
    const items = ordered.filter((q) => q.qType === key)
    if (!items.length) continue
    const scoreSum = items.reduce((s, q) => s + (q.score || 0), 0)
    const per = items[0]?.score ?? 0
    const same = items.every((q) => q.score === per)
    const hint = same
      ? `本大题共 ${items.length} 小题，每小题 ${per} 分，共 ${scoreSum} 分`
      : `本大题共 ${items.length} 小题，共 ${scoreSum} 分`
    groups.push({
      key,
      title: `${TYPE_LABELS[key] || key}（${hint}）`,
      items,
    })
  }
  const known = new Set<string>(TYPE_ORDER)
  const rest = ordered.filter((q) => !known.has(q.qType))
  if (rest.length) groups.push({ key: 'other', title: '其它题型', items: rest })
  return groups
}
