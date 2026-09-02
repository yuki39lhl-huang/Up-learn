import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'
import { deleteExamPreference, fetchExamPreference, saveExamPreference, saveRandomSubjectFilter } from '../api/user'
import { useAuthStore } from './auth'
import { isCohortInRange } from '../utils/examCountdown'
import {
  selectionToAllSubjects,
  toPracticeSubject,
  toPracticeSubjects,
  type ExamSubjectSelection,
} from '../utils/examSubjects'

export type DailySubjectMode = 'fixed' | 'random'
export type RandomSubjectMode = 'all' | 'single'

export interface ExamPrefs {
  province: string
  cohortYear: number | null
  majorCategory: string
  /** 用户确认的考试科目（公共课 + 专业基础 + 专业综合） */
  subjectSelection: ExamSubjectSelection | null
  dailySubject: string
  dailySubjectMode: DailySubjectMode
  randomSubjectMode: RandomSubjectMode
  randomSubject: string
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
  randomSubjectMode: 'all',
  randomSubject: '',
}

function normalizeSlot(value: string | string[] | undefined): string[] {
  if (Array.isArray(value)) return value.filter(Boolean)
  if (typeof value === 'string' && value.trim()) return [value]
  return []
}

function normalizeSelection(raw: Partial<ExamSubjectSelection> & { publicSubjects?: string[] }): ExamSubjectSelection {
  const publicList =
    raw.public?.filter(Boolean).length
      ? normalizeSlot(raw.public)
      : normalizeSlot(raw.publicSubjects)
  return {
    public: publicList,
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
      randomSubjectMode: parsed.randomSubjectMode === 'single' ? 'single' : 'all',
      randomSubject: parsed.randomSubject ?? '',
    }
  } catch {
    return { ...defaults }
  }
}

export const useExamPrefsStore = defineStore('examPrefs', () => {
  const auth = useAuthStore()
  const prefs = ref<ExamPrefs>(readPrefs())
  /** 备考重置计数，供各业务面板同步清空 UI */
  const resetVersion = ref(0)

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
      localStorage.setItem(PREFS_KEY, JSON.stringify(prefs.value))
    }

    const localSnapshot = { ...prefs.value }

    try {
      const remote = await fetchExamPreference()
      if (!remote) {
        if (!localStorage.getItem(PREFS_OWNER_KEY) && localSnapshot.province) {
          localStorage.setItem(PREFS_OWNER_KEY, String(userId))
        }
        return
      }
      prefs.value = {
        province: remote.province,
        cohortYear: remote.cohortYear,
        majorCategory: remote.majorCategory,
        subjectSelection: normalizeSelection(remote.subjectSelection),
        dailySubject: remote.dailySubject,
        dailySubjectMode: remote.dailySubjectMode,
        randomSubjectMode: remote.randomSubjectMode === 'single' ? 'single' : 'all',
        randomSubject: remote.randomSubject ?? '',
      }
      localStorage.setItem(PREFS_OWNER_KEY, String(userId))
    } catch {
      /* 云端读取失败时继续使用本地设置 */
      prefs.value = localSnapshot
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
    resetVersion.value += 1
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

  /** 随机刷题：映射后的题库科目列表（政治/大学英语/高等数学/计算机基础） */
  function practiceSubjects(): string[] {
    const selection = prefs.value.subjectSelection
    return selection ? toPracticeSubjects(selection) : []
  }

  /** 科目标签展示：single 显示科目名，all 显示「全随机」 */
  function randomFilterLabel(): string {
    if (prefs.value.randomSubjectMode === 'single' && prefs.value.randomSubject) {
      return prefs.value.randomSubject
    }
    return '全随机'
  }

  /** 保存随机刷题科目筛选并同步云端 */
  async function saveRandomFilter(mode: RandomSubjectMode, subject?: string) {
    patch({
      randomSubjectMode: mode,
      randomSubject: mode === 'single' ? subject ?? '' : '',
    })
    if (!auth.isLoggedIn) return
    await saveRandomSubjectFilter({
      randomSubjectMode: mode,
      randomSubject: mode === 'single' ? subject : undefined,
    })
  }

  return {
    prefs,
    resetVersion,
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
    practiceSubjects,
    randomFilterLabel,
    saveRandomFilter,
  }
})
