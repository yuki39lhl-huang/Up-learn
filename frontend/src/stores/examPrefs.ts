import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'
import { deleteExamPreference, fetchExamPreference, saveExamPreference } from '../api/user'
import { useAuthStore } from './auth'
import { isCohortInRange } from '../utils/examCountdown'
import {
  selectionToAllSubjects,
  toPracticeSubject,
  toPracticeSubjects,
  type ExamSubjectSelection,
} from '../utils/examSubjects'

export type DailySubjectMode = 'fixed' | 'random'

export interface ExamPrefs {
  province: string
  cohortYear: number | null
  majorCategory: string
  /** 用户确认的考试科目（公共课 + 专业基础 + 专业综合） */
  subjectSelection: ExamSubjectSelection | null
  dailySubject: string
  dailySubjectMode: DailySubjectMode
}

const PREFS_KEY = 'ul_exam_prefs'
const PREFS_OWNER_KEY = 'ul_exam_prefs_owner'

const defaults: ExamPrefs = {
  province: '',
  cohortYear: null,
  majorCategory: '',
  subjectSelection: null,
  dailySubject: '',
  dailySubjectMode: 'fixed',
}

function normalizeSlot(value: string | string[] | undefined): string[] {
  if (Array.isArray(value)) return value.filter(Boolean)
  if (typeof value === 'string' && value.trim()) return [value]
  return []
}

function normalizeSelection(raw: Partial<ExamSubjectSelection>): ExamSubjectSelection {
  return {
    public: normalizeSlot(raw.public),
    foundation: normalizeSlot(raw.foundation as string | string[] | undefined),
    comprehensive: normalizeSlot(raw.comprehensive as string | string[] | undefined),
  }
}

function readPrefs(): ExamPrefs {
  try {
    const raw = localStorage.getItem(PREFS_KEY)
    if (!raw) return { ...defaults }
    const parsed = JSON.parse(raw) as Partial<ExamPrefs> & {
      subjectSelection?: ExamSubjectSelection | null
      examSubjects?: string[]
    }
    const province = parsed.province ?? ''
    const majorCategory = parsed.majorCategory ?? ''
    const cohortYear =
      parsed.cohortYear != null && isCohortInRange(parsed.cohortYear)
        ? parsed.cohortYear
        : null
    const legacySelection = parsed.examSubjects?.length
      ? { public: parsed.examSubjects }
      : null
    const rawSelection = parsed.subjectSelection ?? legacySelection
    const subjectSelection =
      province && majorCategory && rawSelection
        ? normalizeSelection(rawSelection)
        : null
    return {
      province,
      cohortYear,
      majorCategory,
      subjectSelection,
      dailySubject: parsed.dailySubject ?? '',
      dailySubjectMode: parsed.dailySubjectMode ?? 'fixed',
    }
  } catch {
    return { ...defaults }
  }
}

export const useExamPrefsStore = defineStore('examPrefs', () => {
  const auth = useAuthStore()
  const prefs = ref<ExamPrefs>(readPrefs())

  const examSubjects = computed(() =>
    prefs.value.subjectSelection ? selectionToAllSubjects(prefs.value.subjectSelection) : [],
  )

  const hasProvince = computed(() => !!prefs.value.province.trim())
  const hasMajorCategory = computed(() => !!prefs.value.majorCategory.trim())
  const hasCohort = computed(() => prefs.value.cohortYear != null)
  const isConfigured = computed(
    () =>
      hasProvince.value &&
      hasCohort.value &&
      hasMajorCategory.value &&
      !!prefs.value.subjectSelection &&
      examSubjects.value.length > 0 &&
      toPracticeSubjects(prefs.value.subjectSelection).length > 0,
  )

  watch(
    prefs,
    (v) => localStorage.setItem(PREFS_KEY, JSON.stringify(v)),
    { deep: true },
  )

  async function loadRemote() {
    const userId = auth.user?.userId
    if (!auth.isLoggedIn || userId == null) return

    const owner = localStorage.getItem(PREFS_OWNER_KEY)
    if (owner && owner !== String(userId)) {
      prefs.value = { ...defaults }
      localStorage.removeItem(PREFS_OWNER_KEY)
    }

    try {
      const remote = await fetchExamPreference()
      if (!remote) return
      prefs.value = {
        province: remote.province,
        cohortYear: remote.cohortYear,
        majorCategory: remote.majorCategory,
        subjectSelection: normalizeSelection(remote.subjectSelection),
        dailySubject: remote.dailySubject,
        dailySubjectMode: remote.dailySubjectMode,
      }
      localStorage.setItem(PREFS_OWNER_KEY, String(userId))
    } catch {
      /* 云端读取失败时继续使用本地设置 */
    }
  }

  async function saveRemote() {
    const userId = auth.user?.userId
    const selection = prefs.value.subjectSelection
    if (!auth.isLoggedIn || userId == null || !selection || prefs.value.cohortYear == null) return

    const subjects = selectionToAllSubjects(selection)
    const dailySubject = prefs.value.dailySubject || subjects[0]
    if (!dailySubject) return

    await saveExamPreference({
      province: prefs.value.province,
      cohortYear: prefs.value.cohortYear,
      majorCategory: prefs.value.majorCategory,
      subjectSelection: selection,
      dailySubject,
      dailySubjectMode: prefs.value.dailySubjectMode,
    })
    localStorage.setItem(PREFS_OWNER_KEY, String(userId))
  }

  async function deleteRemote() {
    if (auth.isLoggedIn) await deleteExamPreference()
    localStorage.removeItem(PREFS_OWNER_KEY)
  }

  watch(
    () => [auth.isLoggedIn, auth.user?.userId] as const,
    ([loggedIn]) => {
      if (loggedIn) void loadRemote()
    },
    { immediate: true },
  )

  function patch(partial: Partial<ExamPrefs>) {
    prefs.value = { ...prefs.value, ...partial }
  }

  function reset() {
    const empty: ExamPrefs = { ...defaults }
    prefs.value = empty
    localStorage.setItem(PREFS_KEY, JSON.stringify(empty))
  }

  function pickDailySubject(): string {
    const list = examSubjects.value.filter(Boolean)
    if (list.length === 0) return prefs.value.dailySubject
    if (prefs.value.dailySubjectMode === 'fixed') {
      const fixed = prefs.value.dailySubject
      return fixed && list.includes(fixed) ? fixed : list[0]!
    }
    return list[Math.floor(Math.random() * list.length)]!
  }

  function pickDailyPracticeSubject(): string {
    const examSubject = pickDailySubject()
    return toPracticeSubject(examSubject) ?? examSubject
  }

  return {
    prefs,
    examSubjects,
    hasProvince,
    hasMajorCategory,
    isConfigured,
    patch,
    reset,
    loadRemote,
    saveRemote,
    deleteRemote,
    pickDailyPracticeSubject,
  }
})
