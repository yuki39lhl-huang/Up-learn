/** 一期题库已有科目 */
export const BANK_SUBJECTS = ['政治', '大学英语', '高等数学', '计算机基础'] as const

export type SubjectSlot = 'public' | 'foundation' | 'comprehensive'

export interface ExamSubjectSelection {
  public: string[]
  foundation: string[]
  comprehensive: string[]
}

const PRACTICE_SUBJECT_MAP: Record<string, string> = {
  政治: '政治',
  政治理论: '政治',
  大学英语: '大学英语',
  英语: '大学英语',
  高等数学: '高等数学',
  管理学: '高等数学',
  经济学: '高等数学',
  民法: '政治',
  教育理论: '政治',
  大学语文: '大学英语',
  艺术概论: '政治',
  生态学基础: '高等数学',
  生理学: '高等数学',
  计算机基础与程序设计: '计算机基础',
  计算机基础: '计算机基础',
  电子技术基础: '计算机基础',
  机械工程基础: '高等数学',
  基础会计学: '高等数学',
  金融学: '高等数学',
  学前教育基础: '政治',
  遗传学: '高等数学',
  法理学: '政治',
  汉语言文学学科基础: '大学英语',
  英语基础与写作: '大学英语',
  设计基础: '政治',
  电子商务概论: '高等数学',
  市场营销学: '高等数学',
  人力资源管理: '高等数学',
  行政管理学: '政治',
  国际贸易理论与实务: '高等数学',
  数学专业综合: '高等数学',
}

export function selectionToAllSubjects(selection: ExamSubjectSelection): string[] {
  return [
    ...new Set([
      ...selection.public.filter(Boolean),
      ...selection.foundation.filter(Boolean),
      ...selection.comprehensive.filter(Boolean),
    ]),
  ]
}

/** 单个考试科目 → 题库科目；无映射时返回 null */
export function toPracticeSubject(examSubject: string): string | null {
  if (!examSubject?.trim()) return null
  const mapped = PRACTICE_SUBJECT_MAP[examSubject]
  return mapped && BANK_SUBJECTS.includes(mapped as (typeof BANK_SUBJECTS)[number]) ? mapped : null
}

export function toPracticeSubjects(selection: ExamSubjectSelection): string[] {
  return mapToPracticeSubjects(selectionToAllSubjects(selection))
}

export function isSelfExamComprehensive(name: string): boolean {
  return name === '院校自命题综合课'
}

export function hasSelfExamComprehensive(comprehensive: string[]): boolean {
  return comprehensive.some(isSelfExamComprehensive)
}

export function practiceNoteForSelection(selection: ExamSubjectSelection): string {
  const practiceSubjects = toPracticeSubjects(selection)
  if (practiceSubjects.length === 0) return '当前科目组合暂无题库覆盖，请调整科目或稍后再试'
  return `每日一练在题库已覆盖科目中刷题：${practiceSubjects.join('、')}`
}

function mapToPracticeSubjects(subjects: string[]): string[] {
  const mapped = subjects
    .map((s) => PRACTICE_SUBJECT_MAP[s])
    .filter((s): s is string => !!s && BANK_SUBJECTS.includes(s as (typeof BANK_SUBJECTS)[number]))
  return [...new Set(mapped)]
}
