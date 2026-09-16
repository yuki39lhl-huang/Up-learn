<script setup lang="ts">
/**
 * 卷面式作答页：布局贴近纸质试卷；选择题横向/双列；下载为无水印自生成 PDF。
 */
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import MathText from '../components/stitch/MathText.vue'
import {
  fetchPaperDetail,
  savePaperAnswers,
  startPaper,
  submitPaper,
  aiScorePaper,
} from '../api/papers'
import type { PaperDetailVO, PaperQuestionVO } from '../types/api'
import { useAuthStore } from '../stores/auth'
import { downloadPaperAsPdf } from '../utils/exportExamPdf'
import { optionBody, optionLetter } from '../utils/option'
import { buildSheetSections, displayQuestionNo, isMissingQuestion, sortBySeq } from '../utils/paperSheet'
import '../styles/console-workbench.css'

const DEFAULT_EXAM_MINUTES = 120
const DURATION_PRESETS = [60, 90, 120, 150] as const

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const loading = ref(true)
const submitting = ref(false)
const aiScoring = ref(false)
const detail = ref<PaperDetailVO | null>(null)
const questions = ref<PaperQuestionVO[]>([])
const attemptId = ref<number | null>(null)
const submitted = ref(false)
const objectiveScore = ref<number | null>(null)
const objectiveTotal = ref<number | null>(null)
const answers = ref<Record<number, string>>({})

const durationMinutes = ref(DEFAULT_EXAM_MINUTES)
const remainSeconds = ref(DEFAULT_EXAM_MINUTES * 60)
let timerId: ReturnType<typeof setInterval> | null = null

/** 自定义弹窗 */
const dlg = ref<{
  open: boolean
  mode: 'confirm' | 'prompt'
  title: string
  message: string
  input: string
  confirmText: string
  cancelText: string
  resolve: ((v: string | boolean) => void) | null
}>({
  open: false,
  mode: 'confirm',
  title: '',
  message: '',
  input: '',
  confirmText: '确定',
  cancelText: '取消',
  resolve: null,
})

const paperId = computed(() => Number(route.params.id))

const totalScore = computed(() =>
  questions.value.reduce((s, q) => s + (q.score || 0), 0),
)

const choiceCount = computed(
  () => detail.value?.choiceCount ?? questions.value.filter((q) => q.qType === 'choice' && !isMissingQuestion(q)).length,
)

const gradableChoiceCount = computed(
  () =>
    detail.value?.gradableChoiceCount ??
    questions.value.filter((q) => q.qType === 'choice' && q.hasStandardAnswer).length,
)

const gradableHint = computed(() => {
  if (!questions.value.length) return ''
  const g = gradableChoiceCount.value
  const c = choiceCount.value
  if (c <= 0) return '本卷无可机判选择题'
  return `本卷可机判 ${g}/${c} 道选择题`
})

/** 高等数学：公式难机打，填空/计算只提供卷面+草稿纸提示；其它科目提供输入框 */
const isMathPaper = computed(() => {
  const s = detail.value?.subject ?? ''
  return s === '高等数学' || s.includes('高等数学')
})

function allowTypedAnswer(q: PaperQuestionVO): boolean {
  if (isMissingQuestion(q)) return false
  if (q.qType === 'material' || q.qType === 'choice') return false
  if (isMathPaper.value) return false
  // reveal_only / answerable 均可机打；missing 已排除
  return q.qType === 'fill' || q.qType === 'essay' || q.qType === 'calc'
}

const canAiScore = computed(() => {
  if (!submitted.value || isMathPaper.value) return false
  return questions.value.some(
    (q) =>
      allowTypedAnswer(q) &&
      String(answers.value[q.id] || q.userAnswer || '').trim().length > 0
  )
})

/** 主观题 AI 得分合计（有任一题已评才计入） */
const aiSubjectiveScore = computed(() => {
  let sum = 0
  let counted = 0
  for (const q of questions.value) {
    if (q.aiScore == null) continue
    const n = Number(q.aiScore)
    if (!Number.isFinite(n)) continue
    sum += n
    counted++
  }
  return counted > 0 ? Math.round(sum * 10) / 10 : null
})

/** 右上角展示：客观 + AI 主观（若有） */
const totalScoreDisplay = computed(() => {
  if (!submitted.value || objectiveScore.value == null) return null
  const obj = objectiveScore.value
  const ai = aiSubjectiveScore.value
  if (ai == null) return obj
  return Math.round((obj + ai) * 10) / 10
})

const scoreBarHint = computed(() => {
  if (!submitted.value || objectiveScore.value == null) return ''
  if (aiScoring.value) return 'AI 评分中…'
  if (isMathPaper.value) {
    return `客观 ${objectiveScore.value}/${objectiveTotal.value ?? '—'}`
  }
  if (aiSubjectiveScore.value != null) {
    return `客观 ${objectiveScore.value} · AI ${aiSubjectiveScore.value}`
  }
  if (canAiScore.value) return `客观 ${objectiveScore.value}/${objectiveTotal.value ?? '—'}`
  return `客观 ${objectiveScore.value}/${objectiveTotal.value ?? '—'}`
})

async function runAiScore(opts?: { silent?: boolean; force?: boolean }) {
  if (!attemptId.value || aiScoring.value) return
  if (isMathPaper.value) return
  if (!canAiScore.value && !opts?.force) return
  aiScoring.value = true
  try {
    const result = await aiScorePaper(attemptId.value, opts?.force ? { force: true } : undefined)
    questions.value = sortBySeq(result.questions || [])
    for (const q of questions.value) {
      if (q.userAnswer) answers.value[q.id] = q.userAnswer
    }
    if (opts?.silent) {
      if (result.scoredCount > 0) {
        ElMessage.success(`AI 已评 ${result.scoredCount} 道主观题（仅供参考）`)
      }
      return
    }
    if (result.scoredCount > 0) {
      ElMessage.success(
        `已完成 ${result.scoredCount} 题 AI 评分（仅供参考${
          result.skippedCount ? `，跳过 ${result.skippedCount} 题` : ''
        }）`
      )
    } else {
      ElMessage.info(
        result.skippedCount
          ? `没有新的可评题目（已跳过 ${result.skippedCount} 题）`
          : '没有可评的主观作答'
      )
    }
  } catch (e) {
    if (!opts?.silent) {
      ElMessage.error(e instanceof Error ? e.message : 'AI 评分失败')
    } else {
      ElMessage.warning(e instanceof Error ? e.message : '自动 AI 评分失败，可稍后重试')
    }
  } finally {
    aiScoring.value = false
  }
}

async function onAiScore() {
  await runAiScore({ force: true })
}

const orderedQuestions = computed(() => sortBySeq(questions.value))

const sections = computed(() => buildSheetSections(questions.value))

function questionNo(q: PaperQuestionVO) {
  return displayQuestionNo(q, orderedQuestions.value)
}

const clockText = computed(() => {
  const s = Math.max(0, remainSeconds.value)
  const h = Math.floor(s / 3600)
  const m = Math.floor((s % 3600) / 60)
  const sec = s % 60
  if (h > 0) {
    return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(sec).padStart(2, '0')}`
  }
  return `${String(m).padStart(2, '0')}:${String(sec).padStart(2, '0')}`
})

const timerUrgent = computed(() => remainSeconds.value > 0 && remainSeconds.value <= 5 * 60)

/** 规范多选串：提取 A–E 并按字母序去重 */
function normalizeChoiceAnswer(raw: string | null | undefined): string {
  if (!raw) return ''
  const upper = raw.trim().toUpperCase()
  let out = ''
  for (const c of ['A', 'B', 'C', 'D', 'E'] as const) {
    if (upper.includes(c)) out += c
  }
  return out || upper
}

function answerHasLetter(answer: string | null | undefined, letter: string): boolean {
  return normalizeChoiceAnswer(answer).includes(letter.toUpperCase())
}

function storageKey(id: number) {
  return `ul_paper_exam_deadline_${id}`
}

function openConfirm(title: string, message: string, confirmText = '确定', cancelText = '取消') {
  return new Promise<boolean>((resolve) => {
    dlg.value = {
      open: true,
      mode: 'confirm',
      title,
      message,
      input: '',
      confirmText,
      cancelText,
      resolve: (v) => resolve(Boolean(v)),
    }
  })
}

function openPrompt(title: string, message: string, defaultValue: string) {
  return new Promise<string | null>((resolve) => {
    dlg.value = {
      open: true,
      mode: 'prompt',
      title,
      message,
      input: defaultValue,
      confirmText: '重新计时',
      cancelText: '取消',
      resolve: (v) => resolve(typeof v === 'string' ? v : null),
    }
  })
}

function dlgCancel() {
  const r = dlg.value.resolve
  const mode = dlg.value.mode
  dlg.value.open = false
  dlg.value.resolve = null
  if (mode === 'prompt') r?.(null as unknown as string)
  else r?.(false)
}

function dlgOk() {
  const r = dlg.value.resolve
  const mode = dlg.value.mode
  const input = dlg.value.input
  dlg.value.open = false
  dlg.value.resolve = null
  if (mode === 'prompt') r?.(input)
  else r?.(true)
}

function resolveInitialMinutes(): number {
  const q = Number(route.query.minutes)
  if (Number.isFinite(q) && q >= 5 && q <= 300) return Math.floor(q)
  const saved = Number(localStorage.getItem('ul_paper_exam_default_minutes'))
  if (Number.isFinite(saved) && saved >= 5 && saved <= 300) return Math.floor(saved)
  return DEFAULT_EXAM_MINUTES
}

function clearTimer() {
  if (timerId != null) {
    clearInterval(timerId)
    timerId = null
  }
}

function startCountdown(fromSeconds?: number) {
  clearTimer()
  if (submitted.value) return
  if (fromSeconds != null) remainSeconds.value = fromSeconds
  const deadline = Date.now() + remainSeconds.value * 1000
  localStorage.setItem(storageKey(paperId.value), String(deadline))
  timerId = setInterval(() => {
    const left = Math.ceil((deadline - Date.now()) / 1000)
    remainSeconds.value = left
    if (left <= 0) {
      clearTimer()
      remainSeconds.value = 0
      void onTimeUp()
    }
  }, 250)
}

async function onTimeUp() {
  if (submitted.value || !attemptId.value || !questions.value.length) {
    ElMessage.warning('考试时间已到')
    return
  }
  ElMessage.warning('考试时间已到，正在自动交卷')
  try {
    await persistDraft()
    const result = await submitPaper(attemptId.value)
    questions.value = sortBySeq(result.questions || [])
    for (const q of questions.value) {
      if (q.userAnswer) answers.value[q.id] = q.userAnswer
    }
    submitted.value = true
    objectiveScore.value = result.objectiveScore
    objectiveTotal.value = result.objectiveTotal
    localStorage.removeItem(storageKey(paperId.value))
    void runAiScore({ silent: true })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '自动交卷失败，请手动交卷')
  }
}

async function customizeDuration() {
  if (submitted.value) return
  const value = await openPrompt(
    '设置倒计时',
    `请输入考试时长（分钟）。常用：${DURATION_PRESETS.join(' / ')}。默认 ${DEFAULT_EXAM_MINUTES} 分钟。`,
    String(durationMinutes.value),
  )
  if (value == null) return
  const mins = Number(value)
  if (!Number.isFinite(mins) || mins < 5 || mins > 300) {
    ElMessage.error('时长须在 5～300 分钟')
    return
  }
  durationMinutes.value = mins
  localStorage.setItem('ul_paper_exam_default_minutes', String(mins))
  remainSeconds.value = mins * 60
  startCountdown()
  ElMessage.success(`已设为 ${mins} 分钟`)
}

async function load() {
  if (!Number.isFinite(paperId.value) || paperId.value <= 0) {
    ElMessage.error('无效试卷')
    return
  }
  loading.value = true
  clearTimer()
  try {
    let vo = await fetchPaperDetail(paperId.value)
    const wantRetake = route.query.retake === '1'
    if (vo.attemptStatus === 'submitted' && !wantRetake) {
      attemptId.value = vo.attemptId ?? null
      submitted.value = true
      localStorage.removeItem(storageKey(paperId.value))
    } else {
      const start = await startPaper(paperId.value)
      attemptId.value = start.attemptId
      vo = await fetchPaperDetail(paperId.value)
      submitted.value = vo.attemptStatus === 'submitted'
    }
    detail.value = vo
    questions.value = vo.questions ?? []
    const map: Record<number, string> = {}
    for (const q of questions.value) {
      if (q.userAnswer) map[q.id] = q.userAnswer
    }
    answers.value = map
    if (submitted.value) {
      objectiveScore.value = vo.objectiveScore ?? null
      objectiveTotal.value = vo.objectiveTotal ?? null
    } else {
      objectiveScore.value = null
      objectiveTotal.value = null
    }
    durationMinutes.value = resolveInitialMinutes()
    if (!submitted.value && questions.value.length > 0) {
      const raw = localStorage.getItem(storageKey(paperId.value))
      const deadline = raw ? Number(raw) : NaN
      if (Number.isFinite(deadline) && deadline > Date.now()) {
        startCountdown(Math.ceil((deadline - Date.now()) / 1000))
      } else {
        remainSeconds.value = durationMinutes.value * 60
        startCountdown()
      }
    } else {
      remainSeconds.value = 0
    }
    // 已交卷且有主观作答但尚未 AI 评：自动补评一次
    if (
      submitted.value &&
      !isMathPaper.value &&
      canAiScore.value &&
      questions.value.some(
        (q) =>
          allowTypedAnswer(q) &&
          String(answers.value[q.id] || q.userAnswer || '').trim() &&
          q.aiScore == null
      )
    ) {
      void runAiScore({ silent: true })
    }
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载试卷失败')
  } finally {
    loading.value = false
  }
}

async function persistDraft() {
  if (!attemptId.value || submitted.value) return
  const payload = Object.entries(answers.value).map(([questionId, userAnswer]) => ({
    questionId: Number(questionId),
    userAnswer,
  }))
  if (!payload.length) return
  try {
    await savePaperAnswers(attemptId.value, { answers: payload })
  } catch {
    /* ignore */
  }
}

watch(answers, () => void persistDraft(), { deep: true })

async function onSubmit() {
  if (!attemptId.value) return
  const ok = await openConfirm(
    '交卷确认',
    isMathPaper.value
      ? '提交后将批改选择题，并在填空/计算题区域展示参考答案供自行对照。确定交卷？'
      : '提交后将自动批改选择题，并对已作答主观题进行 AI 评分（仅供参考）。确定交卷？',
    '交卷',
    '再检查一下',
  )
  if (!ok) return
  submitting.value = true
  try {
    await persistDraft()
    const result = await submitPaper(attemptId.value)
    questions.value = sortBySeq(result.questions || [])
    for (const q of questions.value) {
      if (q.userAnswer) answers.value[q.id] = q.userAnswer
    }
    submitted.value = true
    objectiveScore.value = result.objectiveScore
    objectiveTotal.value = result.objectiveTotal
    clearTimer()
    localStorage.removeItem(storageKey(paperId.value))
    ElMessage.success(
      `已交卷：客观题 ${result.objectiveScore}/${result.objectiveTotal} 分${
        isMathPaper.value ? `（${gradableHint.value}；主观题请自行批改）` : '，正在 AI 评分…'
      }`,
    )
    if (!isMathPaper.value) {
      void runAiScore({ silent: true })
    }
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '交卷失败')
  } finally {
    submitting.value = false
  }
}

const exportingPdf = ref(false)

/** 当前页直接生成并下载 PDF，不跳转、不弹打印框 */
async function exportCleanPdf() {
  if (!questions.value.length) {
    ElMessage.warning('本题卷尚无结构化题目，无法生成卷面 PDF')
    return
  }
  if (exportingPdf.value) return
  exportingPdf.value = true
  const loadingMsg = ElMessage({ message: '正在生成 PDF…', type: 'info', duration: 0 })
  try {
    await downloadPaperAsPdf(paperId.value)
    ElMessage.success('PDF 已开始下载')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : 'PDF 生成失败')
  } finally {
    loadingMsg.close()
    exportingPdf.value = false
  }
}

async function onRetake() {
  localStorage.removeItem(storageKey(paperId.value))
  // 加 ts：交卷后 URL 往往仍是 retake=1，仅 replace 同参不会触发 watch，界面不刷新
  await router.replace({
    name: 'paper-exam',
    params: { id: String(paperId.value) },
    query: {
      retake: '1',
      minutes: String(durationMinutes.value),
      ts: String(Date.now()),
    },
  })
}

watch(
  () => [route.params.id, route.query.retake, route.query.ts] as const,
  () => void load(),
  { immediate: true },
)

onBeforeUnmount(() => clearTimer())
onMounted(() => {
  document.title = '试卷作答 · 升学通'
})
</script>

<template>
  <div class="paper-exam">
    <header class="paper-exam__bar">
      <button
        type="button"
        class="paper-exam__timer"
        :class="{ 'paper-exam__timer--urgent': timerUrgent, 'paper-exam__timer--done': submitted }"
        :title="submitted ? '已交卷' : '点击设置考试时长'"
        :disabled="submitted"
        @click="customizeDuration"
      >
        <span class="paper-exam__timer-label">{{ submitted ? '已交卷' : '剩余' }}</span>
        <span class="paper-exam__timer-clock">{{ submitted ? '--:--' : clockText }}</span>
      </button>

      <div class="paper-exam__actions">
        <div
          v-if="submitted && totalScoreDisplay != null"
          class="paper-exam__score-badge"
          :title="aiScoring ? '正在对主观题进行 AI 评分' : '客观题机判 + 主观题 AI（仅供参考）'"
        >
          <span class="paper-exam__score-badge-label">{{ aiScoring ? '评分中' : '得分' }}</span>
          <span class="paper-exam__score-badge-value">{{ totalScoreDisplay }}</span>
          <span class="paper-exam__score-badge-sub">{{ scoreBarHint }}</span>
        </div>
        <button
          type="button"
          class="paper-btn"
          :disabled="!questions.length || exportingPdf"
          @click="exportCleanPdf"
        >
          {{ exportingPdf ? '生成中…' : '下载 PDF' }}
        </button>
        <button
          v-if="!submitted && questions.length"
          type="button"
          class="paper-btn paper-btn--primary"
          :disabled="submitting"
          @click="onSubmit"
        >
          {{ submitting ? '提交中…' : '交卷' }}
        </button>
        <button
          v-if="submitted && questions.length && !isMathPaper && canAiScore"
          type="button"
          class="paper-btn"
          :disabled="aiScoring"
          title="重新对已作答主观题进行 AI 评分（仅供参考）"
          @click="onAiScore"
        >
          {{ aiScoring ? '评分中…' : '重新评分' }}
        </button>
        <button
          v-if="submitted && questions.length"
          type="button"
          class="paper-btn paper-btn--primary"
          @click="onRetake"
        >
          重新作答
        </button>
        <el-avatar :size="36" :src="auth.user?.avatarUrl" class="paper-exam__avatar">
          {{ (auth.user?.nickname || '用').slice(0, 1) }}
        </el-avatar>
      </div>
    </header>

    <main v-loading="loading" class="paper-exam__main">
      <div
        v-if="submitted && objectiveScore != null && objectiveTotal != null"
        class="paper-exam__score"
      >
        客观题得分：{{ objectiveScore }} / {{ objectiveTotal }}
        <template v-if="aiSubjectiveScore != null">
          · 主观题 AI：{{ aiSubjectiveScore }}
          · 合计约 {{ totalScoreDisplay }}
        </template>
        <span class="paper-exam__score-hint">
          {{ gradableHint }}
          <template v-if="isMathPaper">；填空与计算题请对照参考答案自行批改</template>
          <template v-else-if="aiScoring">；主观题 AI 评分进行中…</template>
          <template v-else-if="aiSubjectiveScore != null">；主观题 AI 分仅供参考</template>
          <template v-else>；已作答主观题将自动 AI 评分</template>
        </span>
      </div>
      <p v-else-if="!loading && questions.length" class="paper-exam__gradable">
        {{ gradableHint }}
        <span v-if="gradableChoiceCount < choiceCount" class="paper-exam__gradable-warn">
          · 无标准答案的选择题交卷后不计客观分
        </span>
      </p>

      <p v-if="!loading && !questions.length" class="paper-exam__empty">
        本题卷尚未录入结构化题目。录入后可在线作答并下载无水印卷面 PDF。
      </p>

      <!-- 可导出的卷面区域 -->
      <article v-show="questions.length" class="exam-sheet">
        <header class="exam-sheet__head">
          <h1 class="exam-sheet__title">
            《{{ detail?.subject || '试卷' }}》
          </h1>
          <p class="exam-sheet__sub">
            {{ detail?.year }}年{{ detail?.province }}专升本招生统一考试 · 升学通卷面
          </p>
          <p class="exam-sheet__meta">
            （本试卷满分 {{ totalScore || 100 }} 分，考试时间 {{ durationMinutes }} 分钟。）
          </p>
        </header>

        <section v-for="sec in sections" :key="sec.key" class="exam-section">
          <h2 v-if="sec.title" class="exam-section__title">{{ sec.title }}</h2>

          <div
            v-for="q in sec.items"
            :key="q.id"
            class="exam-q"
            :class="{
              'exam-q--material': q.qType === 'material',
              'exam-q--missing': isMissingQuestion(q),
            }"
          >
            <div class="exam-q__stem" :class="{ 'exam-q__stem--pre': q.qType === 'material' }">
              <span v-if="questionNo(q) != null" class="exam-q__no">{{ questionNo(q) }}.</span>
              <MathText :text="q.stem" />
              <span
                v-if="submitted && q.inputMode === 'answerable' && q.hasStandardAnswer && q.correct != null"
                class="exam-q__judge"
                :class="q.correct ? 'is-ok' : 'is-bad'"
              >
                {{ q.correct ? '✓' : '✗' }}
              </span>
            </div>

            <!-- 阅读材料：只展示，不作答 -->
            <template v-if="q.qType === 'material'" />

            <!-- 回忆版暂缺：占位提示，可继续作答其它题 -->
            <p v-else-if="isMissingQuestion(q)" class="exam-blank__hint exam-blank__hint--missing">
              原卷此题在考生回忆版中暂缺，已按卷面题号占位；不影响其它题目作答。
            </p>

            <!-- 选择题：横向双列，贴近纸质卷 -->
            <div v-else-if="q.qType === 'choice' && q.options?.length" class="exam-opts">
              <p
                v-if="!q.hasStandardAnswer && !submitted"
                class="exam-blank__hint exam-blank__hint--no-ans"
              >
                暂无标准答案，可作答但不计入客观机判
              </p>
              <label
                v-for="opt in q.options"
                :key="opt"
                class="exam-opt"
                :class="{
                  'exam-opt--picked': answers[q.id] === optionLetter(opt),
                  'exam-opt--ok':
                    submitted &&
                    q.answer &&
                    answerHasLetter(q.answer, optionLetter(opt)),
                  'exam-opt--bad':
                    submitted &&
                    answers[q.id] === optionLetter(opt) &&
                    q.answer &&
                    !answerHasLetter(q.answer, optionLetter(opt)),
                }"
              >
                <input
                  v-model="answers[q.id]"
                  type="radio"
                  class="exam-opt__radio"
                  :name="`q-${q.id}`"
                  :value="optionLetter(opt)"
                  :disabled="submitted"
                />
                <span class="exam-opt__letter">{{ optionLetter(opt) }}.</span>
                <MathText class="exam-opt__body" :text="optionBody(opt)" />
              </label>
            </div>

            <!-- 填空 / 写作：非数学提供机打；数学仅提示草稿纸 -->
            <div v-else class="exam-blank">
              <template v-if="!submitted && allowTypedAnswer(q)">
                <label class="exam-blank__label" :for="`ans-${q.id}`">作答</label>
                <textarea
                  v-if="q.qType === 'essay' || q.qType === 'calc'"
                  :id="`ans-${q.id}`"
                  v-model="answers[q.id]"
                  class="exam-typed exam-typed--area"
                  rows="6"
                  placeholder="在此输入答案…"
                />
                <input
                  v-else
                  :id="`ans-${q.id}`"
                  v-model="answers[q.id]"
                  class="exam-typed"
                  type="text"
                  placeholder="在此输入答案…"
                  autocomplete="off"
                />
              </template>
              <p v-else-if="!submitted" class="exam-blank__hint">
                {{
                  q.qType === 'fill'
                    ? '请在草稿纸填写；交卷后显示参考答案。'
                    : '请在草稿纸写出完整过程；交卷后显示参考答案供自批。'
                }}
              </p>
              <template v-else>
                <template v-if="allowTypedAnswer(q) || answers[q.id] || q.userAnswer">
                  <p class="exam-blank__label">你的作答</p>
                  <div class="exam-blank__ans exam-blank__ans--user">
                    {{ (answers[q.id] || q.userAnswer || '').trim() || '（未作答）' }}
                  </div>
                </template>
                <p class="exam-blank__label">参考答案</p>
                <div v-if="q.answer" class="exam-blank__ans"><MathText :text="q.answer" /></div>
                <p v-else class="exam-blank__hint">暂无参考答案</p>
                <div v-if="q.analysis" class="exam-blank__ana">
                  <p class="exam-blank__label">解析</p>
                  <MathText :text="q.analysis" />
                </div>
                <div v-if="q.aiScore != null" class="exam-blank__ai">
                  <p class="exam-blank__label">AI 评分（仅供参考）</p>
                  <p class="exam-blank__ai-score">
                    {{ q.aiScore }}
                    <template v-if="q.score != null"> / {{ q.score }}</template>
                  </p>
                  <p v-if="q.aiFeedback" class="exam-blank__ai-fb">{{ q.aiFeedback }}</p>
                </div>
              </template>
            </div>

            <div
              v-if="submitted && q.inputMode === 'answerable' && (q.answer || q.analysis)"
              class="exam-blank exam-blank--after"
            >
              <p class="exam-blank__label">标准答案 {{ q.answer }}</p>
              <div v-if="q.analysis"><MathText :text="q.analysis" /></div>
            </div>
          </div>
        </section>

        <footer class="exam-sheet__foot">升学通 · 无水印练习卷面（非招生考试原件扫描）</footer>
      </article>
    </main>

    <!-- 自定义弹窗 -->
    <Teleport to="body">
      <div v-if="dlg.open" class="ul-dlg" role="dialog" aria-modal="true">
        <div class="ul-dlg__mask" @click="dlgCancel" />
        <div class="ul-dlg__panel">
          <header class="ul-dlg__head">
            <h3>{{ dlg.title }}</h3>
            <button type="button" class="ul-dlg__x" aria-label="关闭" @click="dlgCancel">×</button>
          </header>
          <div class="ul-dlg__body">
            <p class="ul-dlg__msg">{{ dlg.message }}</p>
            <input
              v-if="dlg.mode === 'prompt'"
              v-model="dlg.input"
              class="ul-dlg__input"
              type="number"
              min="5"
              max="300"
              @keyup.enter="dlgOk"
            />
            <div v-if="dlg.mode === 'prompt'" class="ul-dlg__presets">
              <button
                v-for="m in DURATION_PRESETS"
                :key="m"
                type="button"
                class="ul-dlg__chip"
                @click="dlg.input = String(m)"
              >
                {{ m }} 分钟
              </button>
            </div>
          </div>
          <footer class="ul-dlg__foot">
            <button type="button" class="paper-btn" @click="dlgCancel">{{ dlg.cancelText }}</button>
            <button type="button" class="paper-btn paper-btn--primary" @click="dlgOk">
              {{ dlg.confirmText }}
            </button>
          </footer>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.paper-exam {
  min-height: 100vh;
  background: var(--ul-doc-page-bg);
  color: var(--ul-doc-sheet-fg);
}

.paper-exam__bar {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 20px;
  background: var(--st-glass-bg);
  border-bottom: 1px solid var(--ul-doc-bar-border);
  backdrop-filter: blur(8px);
}

.paper-exam__timer {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
  border: none;
  background: transparent;
  padding: 4px 8px;
  border-radius: 10px;
  cursor: pointer;
  font: inherit;
  color: inherit;
}

.paper-exam__timer:not(:disabled):hover {
  background: var(--ul-exam-timer-hover);
}

.paper-exam__timer:disabled {
  cursor: default;
}

.paper-exam__timer-label {
  font-size: 11px;
  color: var(--st-on-surface-variant);
}

.paper-exam__timer-clock {
  font-size: 28px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.04em;
  line-height: 1.1;
}

.paper-exam__timer--urgent .paper-exam__timer-clock {
  color: var(--ul-exam-timer-urgent);
}

.paper-exam__actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.paper-exam__score-badge {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  min-width: 72px;
  margin-right: 4px;
  padding: 4px 12px;
  border-radius: 10px;
  background: var(--ul-exam-score-bg);
  line-height: 1.15;
}

.paper-exam__score-badge-label {
  font-size: 11px;
  color: var(--ul-exam-score-label);
  font-weight: 500;
}

.paper-exam__score-badge-value {
  font-size: 26px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  color: var(--ul-exam-score-value);
  letter-spacing: 0.02em;
}

.paper-exam__score-badge-sub {
  margin-top: 2px;
  font-size: 11px;
  color: var(--ul-exam-score-sub);
  white-space: nowrap;
}

.paper-btn {
  height: 36px;
  padding: 0 14px;
  border-radius: 8px;
  border: 1px solid var(--ul-exam-btn-border);
  background: var(--ul-exam-btn-bg);
  font: inherit;
  font-size: 13px;
  cursor: pointer;
  color: var(--ul-exam-btn-fg);
}

.paper-btn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.paper-btn--primary {
  border-color: transparent;
  background: var(--ul-exam-btn-primary-bg);
  color: var(--ul-exam-btn-primary-fg);
  font-weight: 600;
}

.paper-exam__main {
  max-width: 860px;
  margin: 0 auto;
  padding: 20px 16px 64px;
}

.paper-exam__score {
  margin-bottom: 14px;
  padding: 12px 14px;
  border-radius: 10px;
  background: var(--ul-exam-score-bg);
  color: var(--ul-exam-score-value);
  font-weight: 600;
}

.paper-exam__score-hint {
  display: block;
  margin-top: 4px;
  font-size: 13px;
  font-weight: 400;
  color: var(--ul-exam-score-sub);
}

.paper-exam__gradable {
  margin: 0 0 14px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.paper-exam__gradable-warn {
  color: var(--ul-exam-warn);
}

.exam-blank__ai {
  margin-top: 10px;
  padding: 10px 12px;
  border-radius: 8px;
  background: var(--ul-exam-ai-bg);
}

.exam-blank__ai-score {
  margin: 0 0 6px;
  font-weight: 600;
  color: var(--ul-exam-ai-score);
}

.exam-blank__ai-fb {
  margin: 0;
  font-size: 13px;
  line-height: 1.55;
  color: var(--ul-exam-ai-fg);
  white-space: pre-wrap;
}

.paper-exam__empty {
  text-align: center;
  color: var(--st-on-surface-variant);
  padding: 48px 12px;
}

/* —— 卷面 —— */
.exam-sheet {
  background: var(--ul-doc-sheet-bg);
  color: var(--ul-doc-sheet-fg);
  padding: 28px 36px 40px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  border: 1px solid var(--ul-doc-sheet-border);
}

.exam-sheet__head {
  text-align: center;
  margin-bottom: 22px;
  border-bottom: 1px solid var(--ul-doc-sheet-head-border);
  padding-bottom: 14px;
}

.exam-sheet__title {
  margin: 0;
  font-size: 22px;
  font-weight: 700;
  letter-spacing: 0.06em;
}

.exam-sheet__sub {
  margin: 8px 0 0;
  font-size: 13px;
  color: var(--ul-doc-sheet-muted);
}

.exam-sheet__meta {
  margin: 6px 0 0;
  font-size: 13px;
  color: var(--ul-doc-sheet-muted);
}

.exam-section {
  margin-bottom: 18px;
}

.exam-section__title {
  margin: 0 0 12px;
  font-size: 15px;
  font-weight: 700;
  color: var(--ul-doc-sheet-fg);
}

.exam-q {
  margin-bottom: 14px;
  color: var(--ul-doc-sheet-fg);
}

.exam-q--material {
  margin-bottom: 16px;
  padding: 12px 14px;
  background: var(--ul-doc-material-bg);
  border: 1px solid var(--ul-doc-material-border);
  border-radius: 8px;
}

.exam-q__stem--pre {
  display: block;
  white-space: pre-wrap;
  line-height: 1.65;
  font-size: 14px;
}

.exam-q__stem {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 4px 6px;
  line-height: 1.7;
  font-size: 14.5px;
  margin-bottom: 8px;
}

.exam-q__no {
  font-weight: 600;
}

.exam-q__judge.is-ok {
  color: var(--ul-exam-judge-ok);
  font-weight: 700;
}

.exam-q__judge.is-bad {
  color: var(--ul-exam-judge-bad);
  font-weight: 700;
}

/* 横向双列选项（贴近纸质 A B / C D） */
.exam-opts {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px 20px;
  padding-left: 1.4em;
  margin-bottom: 4px;
}

@media (max-width: 640px) {
  .exam-opts {
    grid-template-columns: 1fr;
  }
}

.exam-opt {
  display: flex;
  align-items: baseline;
  gap: 6px;
  padding: 4px 6px;
  border-radius: 4px;
  cursor: pointer;
  line-height: 1.55;
  font-size: 14px;
}

.exam-opt__radio {
  margin: 0;
  flex-shrink: 0;
  transform: translateY(1px);
}

.exam-opt__letter {
  font-weight: 600;
  flex-shrink: 0;
}

.exam-opt--picked {
  background: var(--ul-exam-opt-picked);
}

.exam-opt--ok {
  background: var(--ul-doc-opt-ok-bg);
}

.exam-opt--bad {
  background: var(--ul-doc-opt-bad-bg);
}

.exam-blank {
  margin: 6px 0 4px 1.4em;
  padding: 8px 10px;
  background: var(--ul-doc-blank-bg);
  border-radius: 4px;
  font-size: 13px;
}

.exam-blank--after {
  margin-top: 8px;
}

.exam-blank__hint {
  margin: 0;
  color: var(--ul-doc-blank-hint);
}

.exam-blank__label {
  margin: 0 0 4px;
  font-size: 12px;
  font-weight: 600;
  color: var(--ul-doc-sheet-fg);
}

.exam-blank__hint--missing {
  color: var(--ul-exam-warn-fg);
  background: color-mix(in srgb, var(--st-tertiary-container) 28%, var(--st-surface));
  border: 1px dashed var(--ul-exam-warn-border);
  border-radius: 6px;
  padding: 8px 10px;
}

.exam-blank__hint--no-ans {
  color: var(--ul-exam-warn-fg);
  margin: 0 0 8px;
  font-size: 12px;
}

.exam-q--missing {
  opacity: 0.92;
}

.exam-blank__ans--user {
  white-space: pre-wrap;
  margin-bottom: 8px;
  color: var(--ul-doc-sheet-fg);
}

.exam-typed {
  display: block;
  width: 100%;
  max-width: 520px;
  box-sizing: border-box;
  margin-top: 4px;
  padding: 8px 10px;
  border: 1px solid var(--ul-doc-input-border);
  border-radius: 6px;
  background: var(--ul-doc-sheet-bg);
  font: inherit;
  font-size: 14px;
  color: var(--ul-doc-sheet-fg);
}

.exam-typed:focus {
  outline: 2px solid var(--ul-exam-focus-ring);
  border-color: var(--ul-exam-accent);
}

.exam-typed--area {
  max-width: 100%;
  min-height: 120px;
  resize: vertical;
  line-height: 1.6;
}

.exam-sheet__foot {
  margin-top: 28px;
  padding-top: 12px;
  border-top: 1px dashed var(--ul-doc-sheet-dash);
  text-align: center;
  font-size: 11px;
  color: var(--ul-doc-sheet-foot);
}

/* —— 弹窗 —— */
.ul-dlg {
  position: fixed;
  inset: 0;
  z-index: 1000;
  display: grid;
  place-items: center;
  padding: 16px;
}

.ul-dlg__mask {
  position: absolute;
  inset: 0;
  background: rgba(28, 25, 20, 0.45);
}

.ul-dlg__panel {
  position: relative;
  width: min(420px, 100%);
  background: var(--st-surface);
  border: 1px solid var(--st-outline-variant);
  border-radius: 14px;
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.18);
  overflow: hidden;
  color: var(--st-on-surface);
}

.ul-dlg__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px 0;
}

.ul-dlg__head h3 {
  margin: 0;
  font-size: 16px;
  color: var(--st-on-surface);
}

.ul-dlg__x {
  border: none;
  background: none;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  color: var(--st-on-surface-variant);
}

.ul-dlg__body {
  padding: 12px 16px 8px;
}

.ul-dlg__msg {
  margin: 0;
  font-size: 14px;
  line-height: 1.6;
  color: var(--st-on-surface-variant);
}

.ul-dlg__input {
  width: 100%;
  margin-top: 12px;
  height: 40px;
  padding: 0 12px;
  border: 1px solid var(--ul-exam-btn-border);
  border-radius: 8px;
  background: var(--st-surface-container-low);
  color: var(--st-on-surface);
  font: inherit;
  box-sizing: border-box;
}

.ul-dlg__presets {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 10px;
}

.ul-dlg__chip {
  border: 1px solid var(--ul-exam-btn-border);
  background: var(--st-surface-container);
  color: var(--st-on-surface);
  border-radius: 999px;
  padding: 4px 10px;
  font: inherit;
  font-size: 12px;
  cursor: pointer;
}

.ul-dlg__foot {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding: 12px 16px 16px;
}
</style>
