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
} from '../api/papers'
import type { PaperDetailVO, PaperQuestionVO } from '../types/api'
import { useAuthStore } from '../stores/auth'
import { downloadPaperAsPdf } from '../utils/exportExamPdf'
import { buildSheetSections, displayQuestionNo, sortBySeq } from '../utils/paperSheet'
import '../styles/console-workbench.css'

const DEFAULT_EXAM_MINUTES = 120
const DURATION_PRESETS = [60, 90, 120, 150] as const

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const loading = ref(true)
const submitting = ref(false)
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

/** 高等数学：公式难机打，填空/计算只提供卷面+草稿纸提示；其它科目提供输入框 */
const isMathPaper = computed(() => {
  const s = detail.value?.subject ?? ''
  return s === '高等数学' || s.includes('高等数学')
})

function allowTypedAnswer(q: PaperQuestionVO): boolean {
  if (q.qType === 'material' || q.qType === 'choice') return false
  if (isMathPaper.value) return false
  return q.qType === 'fill' || q.qType === 'essay' || q.qType === 'calc'
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

function optionLetter(opt: string): string {
  const m = opt.trim().match(/^([A-Da-d])[.、．\s]/)
  return m ? m[1].toUpperCase() : opt.trim().charAt(0).toUpperCase()
}

function optionBody(opt: string): string {
  return opt.replace(/^[A-Da-d][.、．\s]+/, '').trim()
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
    questions.value = result.questions
    submitted.value = true
    objectiveScore.value = result.objectiveScore
    objectiveTotal.value = result.objectiveTotal
    localStorage.removeItem(storageKey(paperId.value))
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
      : '提交后将批改选择题；填空/写作等机打答案会保留，并展示参考答案供自行对照。确定交卷？',
    '交卷',
    '再检查一下',
  )
  if (!ok) return
  submitting.value = true
  try {
    await persistDraft()
    const result = await submitPaper(attemptId.value)
    questions.value = result.questions
    submitted.value = true
    objectiveScore.value = result.objectiveScore
    objectiveTotal.value = result.objectiveTotal
    clearTimer()
    localStorage.removeItem(storageKey(paperId.value))
    ElMessage.success(
      `已交卷：客观题 ${result.objectiveScore}/${result.objectiveTotal} 分（主观题请自行批改）`,
    )
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

function onRetake() {
  localStorage.removeItem(storageKey(paperId.value))
  void router.replace({
    name: 'paper-exam',
    params: { id: String(paperId.value) },
    query: { retake: '1', minutes: String(durationMinutes.value) },
  })
}

watch(
  () => [route.params.id, route.query.retake] as const,
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
        <span class="paper-exam__score-hint">填空与计算题请对照参考答案自行批改</span>
      </div>

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
            :class="{ 'exam-q--material': q.qType === 'material' }"
          >
            <div class="exam-q__stem" :class="{ 'exam-q__stem--pre': q.qType === 'material' }">
              <span v-if="questionNo(q) != null" class="exam-q__no">{{ questionNo(q) }}.</span>
              <MathText :text="q.stem" />
              <span
                v-if="submitted && q.inputMode === 'answerable' && q.correct != null"
                class="exam-q__judge"
                :class="q.correct ? 'is-ok' : 'is-bad'"
              >
                {{ q.correct ? '✓' : '✗' }}
              </span>
            </div>

            <!-- 阅读材料：只展示，不作答 -->
            <template v-if="q.qType === 'material'" />

            <!-- 选择题：横向双列，贴近纸质卷 -->
            <div v-else-if="q.qType === 'choice' && q.options?.length" class="exam-opts">
              <label
                v-for="opt in q.options"
                :key="opt"
                class="exam-opt"
                :class="{
                  'exam-opt--picked': answers[q.id] === optionLetter(opt),
                  'exam-opt--ok':
                    submitted && q.answer && optionLetter(opt) === q.answer.toUpperCase(),
                  'exam-opt--bad':
                    submitted &&
                    answers[q.id] === optionLetter(opt) &&
                    q.answer &&
                    optionLetter(opt) !== q.answer.toUpperCase(),
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
  background: #e8e6e1;
  color: #1a1a1a;
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
  background: rgba(255, 255, 255, 0.92);
  border-bottom: 1px solid #d8d4cc;
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
  background: #f0eee8;
}

.paper-exam__timer:disabled {
  cursor: default;
}

.paper-exam__timer-label {
  font-size: 11px;
  color: #666;
}

.paper-exam__timer-clock {
  font-size: 28px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.04em;
  line-height: 1.1;
}

.paper-exam__timer--urgent .paper-exam__timer-clock {
  color: #b42318;
}

.paper-exam__actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.paper-btn {
  height: 36px;
  padding: 0 14px;
  border-radius: 8px;
  border: 1px solid #cfc9be;
  background: #fff;
  font: inherit;
  font-size: 13px;
  cursor: pointer;
  color: #1a1a1a;
}

.paper-btn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.paper-btn--primary {
  border-color: transparent;
  background: #3d6b4f;
  color: #fff;
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
  background: #e7efe9;
  font-weight: 600;
}

.paper-exam__score-hint {
  display: block;
  margin-top: 4px;
  font-size: 13px;
  font-weight: 400;
}

.paper-exam__empty {
  text-align: center;
  color: #666;
  padding: 48px 12px;
}

/* —— 卷面 —— */
.exam-sheet {
  background: #fff;
  padding: 28px 36px 40px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  border: 1px solid #ddd;
}

.exam-sheet__head {
  text-align: center;
  margin-bottom: 22px;
  border-bottom: 1px solid #222;
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
  color: #444;
}

.exam-sheet__meta {
  margin: 6px 0 0;
  font-size: 13px;
}

.exam-section {
  margin-bottom: 18px;
}

.exam-section__title {
  margin: 0 0 12px;
  font-size: 15px;
  font-weight: 700;
}

.exam-q {
  margin-bottom: 14px;
}

.exam-q--material {
  margin-bottom: 16px;
  padding: 12px 14px;
  background: #faf9f6;
  border: 1px solid #e5e1d8;
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
  color: #1b7f4a;
  font-weight: 700;
}

.exam-q__judge.is-bad {
  color: #b42318;
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
  background: rgba(61, 107, 79, 0.12);
}

.exam-opt--ok {
  background: #e8f6ee;
}

.exam-opt--bad {
  background: #fdecea;
}

.exam-blank {
  margin: 6px 0 4px 1.4em;
  padding: 8px 10px;
  background: #f7f5f1;
  border-radius: 4px;
  font-size: 13px;
}

.exam-blank--after {
  margin-top: 8px;
}

.exam-blank__hint {
  margin: 0;
  color: #666;
}

.exam-blank__label {
  margin: 0 0 4px;
  font-size: 12px;
  font-weight: 600;
  color: #555;
}

.exam-blank__ans--user {
  white-space: pre-wrap;
  margin-bottom: 8px;
  color: #1a1a1a;
}

.exam-typed {
  display: block;
  width: 100%;
  max-width: 520px;
  box-sizing: border-box;
  margin-top: 4px;
  padding: 8px 10px;
  border: 1px solid #cfc9be;
  border-radius: 6px;
  background: #fff;
  font: inherit;
  font-size: 14px;
  color: #1a1a1a;
}

.exam-typed:focus {
  outline: 2px solid rgba(61, 107, 79, 0.35);
  border-color: #3d6b4f;
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
  border-top: 1px dashed #ccc;
  text-align: center;
  font-size: 11px;
  color: #888;
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
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.18);
  overflow: hidden;
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
}

.ul-dlg__x {
  border: none;
  background: none;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  color: #888;
}

.ul-dlg__body {
  padding: 12px 16px 8px;
}

.ul-dlg__msg {
  margin: 0;
  font-size: 14px;
  line-height: 1.6;
  color: #333;
}

.ul-dlg__input {
  width: 100%;
  margin-top: 12px;
  height: 40px;
  padding: 0 12px;
  border: 1px solid #cfc9be;
  border-radius: 8px;
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
  border: 1px solid #cfc9be;
  background: #f7f5f1;
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
