/** 默认省份（推断规则兜底用） */
export const DEFAULT_PROVINCE = '广东'

/** 届别可选范围：当前年份 ±3（2 位届别，如 2027 年 → 24–30 届） */
export function getCohortOptions(referenceDate = new Date()): number[] {
  const current = referenceDate.getFullYear() % 100
  const min = current - 3
  const max = current + 3
  return Array.from({ length: max - min + 1 }, (_, i) => min + i)
}

export function isCohortInRange(cohortYear: number | null, referenceDate = new Date()): boolean {
  if (cohortYear == null) return false
  return getCohortOptions(referenceDate).includes(cohortYear)
}

/**
 * 广东春季高考惯例：届别入学年 + 3 → 考试年 3 月最后一个周六。
 * 例：24 届 → 2027 年 3 月最后一个周六。
 */
export function calcGuangdongExamDate(cohortYear: number): Date {
  const examYear = 2000 + cohortYear + 3
  const lastDay = new Date(examYear, 2, 31)
  while (lastDay.getDay() !== 6) {
    lastDay.setDate(lastDay.getDate() - 1)
  }
  lastDay.setHours(0, 0, 0, 0)
  return lastDay
}

export interface CountdownParts {
  days: number
  hours: number
  minutes: number
  examDate: Date
  examDateLabel: string
}

export function calcExamCountdown(cohortYear: number | null, province?: string): CountdownParts | null {
  if (cohortYear == null || !province?.trim()) return null
  const examDate = calcGuangdongExamDate(cohortYear)
  const now = new Date()
  const diffMs = examDate.getTime() - now.getTime()
  const totalMinutes = Math.max(0, Math.floor(diffMs / 60_000))
  const days = Math.floor(totalMinutes / (60 * 24))
  const hours = Math.floor((totalMinutes % (60 * 24)) / 60)
  const minutes = totalMinutes % 60
  const y = examDate.getFullYear()
  const m = examDate.getMonth() + 1
  const d = examDate.getDate()
  return {
    days,
    hours,
    minutes,
    examDate,
    examDateLabel: `${province} · ${y}年${m}月${d}日（预估）`,
  }
}
