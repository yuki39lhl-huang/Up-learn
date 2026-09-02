<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  addPracticeNote,
  addWrongBook,
  clearPracticeNotes,
  clearWrongBook,
  deletePracticeNote,
  deleteWrongBook,
  fetchDaily,
  fetchNoteDetail,
  fetchNoteList,
  fetchAnswerHistory,
  fetchRandom,
  fetchRandomPendingHint,
  fetchWrongDetail,
  fetchWrongList,
  resetRandomPractice,
} from '../../api/practice'
import { usePracticeQuiz, type PracticeMode } from '../../composables/usePracticeQuiz'
import { useExamPrefsStore, type RandomSubjectMode } from '../../stores/examPrefs'
import { pushConsole } from '../../utils/consoleNav'
import { parseOption } from '../../utils/option'
import type { AnswerHistoryVO, PracticeNoteVO, StudyStatsVO, WrongQuestionVO } from '../../types/api'
import StitchDialog from './StitchDialog.vue'
import StitchIcon from './StitchIcon.vue'

const STITCH_POPPER = 'stitch-popper'

const props = withDefaults(
  defineProps<{
    defaultMode?: PracticeMode
  }>(),
  { defaultMode: 'daily' },
)

const mode = ref<PracticeMode>(props.defaultMode)
const route = useRoute()
const router = useRouter()
const examPrefs = useExamPrefsStore()
const resetDialogOpen = ref(false)

const wrongDrawerOpen = ref(false)
const wrongView = ref<'list' | 'detail'>('list')
const wrongListDate = ref('')
const wrongListSubject = ref('')
const wrongList = ref<WrongQuestionVO[]>([])
const wrongDetail = ref<WrongQuestionVO | null>(null)
const wrongListLoading = ref(false)
const wrongAdding = ref(false)

const notesDrawerOpen = ref(false)
const notesView = ref<'list' | 'detail'>('list')
const notesListDate = ref('')
const notesListSubject = ref('')
const notesList = ref<PracticeNoteVO[]>([])
const notesDetail = ref<PracticeNoteVO | null>(null)
const notesListLoading = ref(false)

const historyDrawerOpen = ref(false)
const historyList = ref<AnswerHistoryVO[]>([])
const historyLoading = ref(false)
const historyPageNo = ref(1)
const historyPageSize = 20
const historyTotal = ref(0)

const poolExhausted = ref(false)
const resetScope = ref<'all' | 'single'>('all')
const resetSubject = ref('')
const resetLoading = ref(false)

const confirmDialogOpen = ref(false)
const confirmDialogTitle = ref('')
const confirmDialogSubtitle = ref('')
const confirmDialogDanger = ref(false)
const confirmDialogLoading = ref(false)
let confirmDialogAction: (() => Promise<void>) | null = null

const noteDialogOpen = ref(false)
const noteDraft = ref('')
const noteSaving = ref(false)

const setupGuideDialogOpen = ref(false)

const filterDrawerOpen = ref(false)
const filterMode = ref<RandomSubjectMode>('all')
const filterSubject = ref('')
const filterSaving = ref(false)

const otherPendingSubjects = ref<string[]>([])

const wrongQuestionIds = ref<Set<number>>(new Set())
const noteQuestionIds = ref<Set<number>>(new Set())

const currentInWrongBook = computed(
  () => question.value != null && wrongQuestionIds.value.has(question.value.id),
)
const currentInNotes = computed(
  () => question.value != null && noteQuestionIds.value.has(question.value.id),
)

const {
  loading,
  submitting,
  question,
  selected,
  result,
  stats,
  loadStats,
  resetAnswer,
  optionClass,
  submit,
} = usePracticeQuiz()

const panelTitle = computed(() => (mode.value === 'daily' ? '每日一练' : '随机刷题'))
const practiceSubjects = computed(() => examPrefs.practiceSubjects())
const subjectFilterLabel = computed(() => examPrefs.randomFilterLabel())
const showOtherPendingHint = computed(
  () => mode.value === 'random' && otherPendingSubjects.value.length > 0,
)
const showResetButton = computed(
  () =>
    mode.value === 'random' &&
    examPrefs.isConfigured &&
    (stats.value?.totalAnswered ?? 0) > 0,
)
const otherPendingHintText = computed(() => {
  const names = otherPendingSubjects.value.join('、')
  return `其它科目（${names}）仍有待复习错题，可点「自定义范围」切换科目继续`
})

function openFilterDrawer() {
  if (!examPrefs.isConfigured) {
    promptSetupGuide()
    return
  }
  filterMode.value = examPrefs.prefs.randomSubjectMode
  const subjects = practiceSubjects.value
  const current = examPrefs.prefs.randomSubject
  filterSubject.value =
    current && subjects.includes(current) ? current : subjects[0] ?? ''
  filterDrawerOpen.value = true
}

async function applyRandomFilter() {
  if (filterMode.value === 'single' && !filterSubject.value) {
    ElMessage.warning('请选择科目')
    return
  }
  filterSaving.value = true
  try {
    await examPrefs.saveRandomFilter(
      filterMode.value,
      filterMode.value === 'single' ? filterSubject.value : undefined,
    )
    filterDrawerOpen.value = false
    ElMessage.success('刷题范围已更新')
    poolExhausted.value = false
    await loadQuestion('random')
    await refreshPendingHint()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    filterSaving.value = false
  }
}

function goDashboardForSettings() {
  setupGuideDialogOpen.value = false
  pushConsole(router, 'dashboard', { setup: '1' })
}

function promptSetupGuide() {
  setupGuideDialogOpen.value = true
}

function openConfirmDialog(
  title: string,
  subtitle: string,
  action: () => Promise<void>,
  danger = true,
) {
  confirmDialogTitle.value = title
  confirmDialogSubtitle.value = subtitle
  confirmDialogDanger.value = danger
  confirmDialogAction = action
  confirmDialogOpen.value = true
}

async function runConfirmDialog() {
  if (!confirmDialogAction) return
  confirmDialogLoading.value = true
  try {
    await confirmDialogAction()
    confirmDialogOpen.value = false
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '操作失败')
  } finally {
    confirmDialogLoading.value = false
    confirmDialogAction = null
  }
}

function zeroRandomStats() {
  stats.value = {
    totalAnswered: 0,
    correctCount: 0,
    accuracy: 0,
    streak: 0,
    totalCheckInDays: 0,
  } satisfies StudyStatsVO
}

/** 备考失效或重置时清空随机刷题面板内存状态 */
function resetRandomPanelState() {
  if (props.defaultMode !== 'random') return
  question.value = null
  resetAnswer()
  poolExhausted.value = false
  otherPendingSubjects.value = []
  wrongQuestionIds.value = new Set()
  noteQuestionIds.value = new Set()
  resetDialogOpen.value = false
  filterDrawerOpen.value = false
  setupGuideDialogOpen.value = false
  zeroRandomStats()
}

async function refreshPendingHint() {
  if (mode.value !== 'random' || !examPrefs.isConfigured) {
    otherPendingSubjects.value = []
    return
  }
  try {
    const hint = await fetchRandomPendingHint()
    otherPendingSubjects.value = hint.otherSubjects ?? []
  } catch {
    otherPendingSubjects.value = []
  }
}

function formatTime(value?: string) {
  if (!value) return ''
  return value.replace('T', ' ').slice(0, 16)
}

function sourceLabel(source?: string) {
  if (source === 'daily') return '每日一练'
  if (source === 'random') return '随机刷题'
  return source ?? '—'
}

async function loadHistoryList() {
  historyLoading.value = true
  try {
    const page = await fetchAnswerHistory({
      pageNo: historyPageNo.value,
      pageSize: historyPageSize,
    })
    historyList.value = page.list
    historyTotal.value = page.total
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载答题历史失败')
  } finally {
    historyLoading.value = false
  }
}

function openHistoryDrawer() {
  historyDrawerOpen.value = true
  historyPageNo.value = 1
  loadHistoryList()
}

function onHistoryPageChange(page: number) {
  historyPageNo.value = page
  loadHistoryList()
}

function detailOptionClass(
  label: string,
  userAnswer?: string,
  correctAnswer?: string,
) {
  if (correctAnswer && label === correctAnswer) return 'option--correct'
  if (userAnswer && label === userAnswer && userAnswer !== correctAnswer) return 'option--wrong'
  return ''
}

async function refreshBookmarks() {
  if (mode.value !== 'random') return
  try {
    const wrongPage = await fetchWrongList({ pageNo: 1, pageSize: 200 })
    wrongQuestionIds.value = new Set(wrongPage.list.map((w) => w.questionId))
    const notePage = await fetchNoteList({ pageNo: 1, pageSize: 200 })
    noteQuestionIds.value = new Set(notePage.list.map((n) => n.questionId))
  } catch {
    /* 书签索引失败不阻断刷题 */
  }
}

function isPoolExhaustedMessage(msg: string) {
  return msg.includes('已刷完') || msg.includes('暂无可用题目')
}

async function loadQuestion(nextMode: PracticeMode) {
  mode.value = nextMode
  resetAnswer()
  poolExhausted.value = false
  loading.value = true
  try {
    if (nextMode === 'daily') {
      question.value = await fetchDaily()
    } else {
      if (!examPrefs.isConfigured) {
        question.value = null
        return
      }
      question.value = await fetchRandom()
      await refreshBookmarks()
      await refreshPendingHint()
    }
  } catch (e) {
    question.value = null
    const msg = e instanceof Error ? e.message : '加载题目失败'
    if (nextMode === 'random' && isPoolExhaustedMessage(msg)) {
      poolExhausted.value = true
    } else if (nextMode === 'random' && msg.includes('备考设置')) {
      /* 未配置时由空状态区引导，不弹窗打断 */
    } else {
      ElMessage.error(msg)
    }
  } finally {
    loading.value = false
  }
}

function isRandomRouteActive() {
  const hash = route.hash.replace('#', '')
  return hash === 'practice' || hash === 'random'
}

async function ensureRandomQuestion() {
  if (props.defaultMode !== 'random' || !isRandomRouteActive()) return
  if (!examPrefs.isConfigured) {
    resetRandomPanelState()
    return
  }
  if (loading.value) return
  if (question.value || poolExhausted.value) return
  await loadQuestion('random')
}

async function handleSubmit() {
  if (!examPrefs.isConfigured) return
  await submit(mode.value)
  if (mode.value === 'random') {
    await refreshPendingHint()
  }
}

async function loadWrongList() {
  wrongListLoading.value = true
  try {
    const page = await fetchWrongList({
      pageNo: 1,
      pageSize: 50,
      date: wrongListDate.value || undefined,
      subject: wrongListSubject.value || undefined,
    })
    wrongList.value = page.list
    wrongQuestionIds.value = new Set(page.list.map((w) => w.questionId))
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载错题本失败')
  } finally {
    wrongListLoading.value = false
  }
}

async function openWrongDrawer() {
  wrongView.value = 'list'
  wrongDetail.value = null
  wrongDrawerOpen.value = true
  await loadWrongList()
}

async function openWrongDetail(id: number) {
  wrongListLoading.value = true
  try {
    wrongDetail.value = await fetchWrongDetail(id)
    wrongView.value = 'detail'
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载错题详情失败')
  } finally {
    wrongListLoading.value = false
  }
}

function backToWrongList() {
  wrongView.value = 'list'
  wrongDetail.value = null
}

async function handleAddWrongBook() {
  if (!question.value || !result.value || currentInWrongBook.value) return
  wrongAdding.value = true
  try {
    await addWrongBook(question.value.id, result.value.userAnswer)
    wrongQuestionIds.value.add(question.value.id)
    ElMessage.success('已加入错题本')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加入错题本失败')
  } finally {
    wrongAdding.value = false
  }
}

async function handleClearWrongBook() {
  const subtitle = wrongListDate.value
    ? `将删除 ${wrongListDate.value} 筛选条件下的全部错题，此操作不可恢复。`
    : '将清空全部错题本记录，此操作不可恢复。'
  openConfirmDialog('一键清空错题本', subtitle, async () => {
    const count = await clearWrongBook(
      wrongListDate.value || undefined,
      wrongListSubject.value || undefined,
    )
    wrongQuestionIds.value = new Set()
    if (wrongView.value === 'detail') backToWrongList()
    await loadWrongList()
    await refreshBookmarks()
    ElMessage.success(count > 0 ? `已删除 ${count} 条` : '暂无记录可删')
  })
}

async function handleClearNotes() {
  const subtitle = notesListDate.value
    ? `将删除 ${notesListDate.value} 筛选条件下的全部备忘录，此操作不可恢复。`
    : '将清空全部备忘录，此操作不可恢复。'
  openConfirmDialog('一键清空备忘录', subtitle, async () => {
    const count = await clearPracticeNotes(
      notesListDate.value || undefined,
      notesListSubject.value || undefined,
    )
    noteQuestionIds.value = new Set()
    if (notesView.value === 'detail') backToNotesList()
    await loadNotesList()
    await refreshBookmarks()
    ElMessage.success(count > 0 ? `已删除 ${count} 条` : '暂无记录可删')
  })
}

async function handleDeleteWrong(id: number, questionId: number) {
  openConfirmDialog('移出错题本', '确定从错题本移除此题？', async () => {
    await deleteWrongBook(id)
    wrongQuestionIds.value.delete(questionId)
    if (wrongView.value === 'detail' && wrongDetail.value?.id === id) {
      backToWrongList()
    }
    await loadWrongList()
    ElMessage.success('已移除')
  })
}

async function loadNotesList() {
  notesListLoading.value = true
  try {
    const page = await fetchNoteList({
      pageNo: 1,
      pageSize: 50,
      date: notesListDate.value || undefined,
      subject: notesListSubject.value || undefined,
    })
    notesList.value = page.list
    noteQuestionIds.value = new Set(page.list.map((n) => n.questionId))
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载备忘录失败')
  } finally {
    notesListLoading.value = false
  }
}

async function openNotesDrawer() {
  notesView.value = 'list'
  notesDetail.value = null
  notesDrawerOpen.value = true
  await loadNotesList()
}

async function openNoteDetail(id: number) {
  notesListLoading.value = true
  try {
    notesDetail.value = await fetchNoteDetail(id)
    notesView.value = 'detail'
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载笔记详情失败')
  } finally {
    notesListLoading.value = false
  }
}

function backToNotesList() {
  notesView.value = 'list'
  notesDetail.value = null
}

async function handleAddNote() {
  if (!question.value || currentInNotes.value) return
  noteDraft.value = ''
  noteDialogOpen.value = true
}

async function saveNote() {
  if (!question.value) return
  noteSaving.value = true
  try {
    await addPracticeNote(question.value.id, noteDraft.value.trim() || undefined)
    noteQuestionIds.value.add(question.value.id)
    noteDialogOpen.value = false
    ElMessage.success('已添加到笔记')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '添加笔记失败')
  } finally {
    noteSaving.value = false
  }
}

async function handleDeleteNote(id: number, questionId: number) {
  openConfirmDialog('删除备忘录', '确定删除这条备忘录？', async () => {
    await deletePracticeNote(id)
    noteQuestionIds.value.delete(questionId)
    if (notesView.value === 'detail' && notesDetail.value?.id === id) {
      backToNotesList()
    }
    await loadNotesList()
    ElMessage.success('已删除')
  })
}

function openResetDialog() {
  if (!showResetButton.value) return
  resetScope.value = 'all'
  resetSubject.value = practiceSubjects.value[0] || ''
  resetDialogOpen.value = true
}

async function applyReset() {
  if (resetScope.value === 'single' && !resetSubject.value) {
    ElMessage.warning('请选择科目')
    return
  }
  resetLoading.value = true
  try {
    const vo = await resetRandomPractice(
      resetScope.value,
      resetScope.value === 'single' ? resetSubject.value : undefined,
    )
    resetDialogOpen.value = false
    poolExhausted.value = false
    ElMessage.success(`已清除 ${vo.clearedRecordCount} 条复习记录，统计已重置`)
    await loadStats('random')
    await loadQuestion('random')
    await refreshPendingHint()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '清空失败')
  } finally {
    resetLoading.value = false
  }
}

watch(wrongListDate, () => {
  if (wrongDrawerOpen.value && wrongView.value === 'list') loadWrongList()
})

watch(wrongListSubject, () => {
  if (wrongDrawerOpen.value && wrongView.value === 'list') loadWrongList()
})

watch(notesListDate, () => {
  if (notesDrawerOpen.value && notesView.value === 'list') loadNotesList()
})

watch(notesListSubject, () => {
  if (notesDrawerOpen.value && notesView.value === 'list') loadNotesList()
})

watch(
  () => examPrefs.isConfigured,
  (configured) => {
    if (configured) {
      void ensureRandomQuestion()
    } else {
      resetRandomPanelState()
    }
  },
)

watch(
  () => examPrefs.resetVersion,
  () => {
    resetRandomPanelState()
  },
)

watch(
  () => route.hash,
  () => {
    void ensureRandomQuestion()
  },
)

onMounted(async () => {
  await examPrefs.loadRemote()
  await loadStats(mode.value)
  await loadQuestion(props.defaultMode)
})
</script>

<template>
  <section class="practice-panel st-card" v-loading="loading">
    <header class="st-card-header panel-title">{{ panelTitle }}</header>
    <div class="st-card-body">
      <div v-if="mode === 'random'" class="panel-meta panel-meta--random">
        <button type="button" class="side-entry" @click="openWrongDrawer">错题本</button>
        <div class="panel-meta-center">
          <button
            type="button"
            class="filter-hint filter-hint--btn"
            :disabled="!examPrefs.isConfigured"
            @click="openFilterDrawer"
          >
            当前范围 · {{ subjectFilterLabel }}
          </button>
          <div class="meta-tags">
            <button
              v-if="!examPrefs.isConfigured"
              type="button"
              class="subject-tag subject-tag--link"
              @click="promptSetupGuide"
            >
              前往主页设置
            </button>
            <button
              v-if="examPrefs.isConfigured"
              type="button"
              class="subject-tag subject-tag--link"
              @click="openFilterDrawer"
            >
              自定义范围
            </button>
            <button
              v-if="showResetButton"
              type="button"
              class="subject-tag subject-tag--btn"
              @click="openResetDialog"
            >
              清空重刷
            </button>
          </div>
          <p v-if="showOtherPendingHint" class="other-pending-hint">{{ otherPendingHintText }}</p>
        </div>
        <div class="panel-meta-side panel-meta-side--right">
          <button type="button" class="side-entry" @click="openHistoryDrawer">答题历史</button>
          <button type="button" class="side-entry" @click="openNotesDrawer">备忘录</button>
        </div>
      </div>
      <div v-else class="panel-meta">
        <span class="streak">
          <StitchIcon name="flame" class="streak-icon" />
          连续打卡 {{ stats?.streak ?? 0 }} 天
        </span>
        <span v-if="question" class="subject-tag">{{ question.subject }}</span>
      </div>

      <div class="panel-stats">
        <span>{{ stats?.totalAnswered ?? 0 }} 题累计</span>
        <span class="sep">|</span>
        <span>{{ stats?.accuracy ?? 0 }}% 正确率</span>
      </div>

      <template v-if="question">
        <p v-if="mode === 'random'" class="question-subject">本题科目：{{ question.subject }}</p>
        <p class="stem">{{ question.stem }}</p>

        <div class="options">
          <button
            v-for="opt in question.options"
            :key="opt"
            type="button"
            class="option-btn"
            :class="[
              optionClass(parseOption(opt).label),
              { 'option-btn--active': selected === parseOption(opt).label && !result },
            ]"
            :disabled="!!result"
            @click="selected = parseOption(opt).label"
          >
            <span class="opt-key">{{ parseOption(opt).label }}</span>
            <span>{{ parseOption(opt).text }}</span>
            <span
              v-if="result && parseOption(opt).label === result.userAnswer && !result.correct"
              class="tag-wrong"
            >
              你的答案
            </span>
            <span v-if="result && parseOption(opt).label === result.answer" class="tag-correct">
              正确答案
            </span>
          </button>
        </div>

        <div v-if="result?.analysis" class="analysis">
          <span class="st-label-caps">解析</span>
          <p>{{ result.analysis }}</p>
        </div>

        <div class="actions">
          <el-button v-if="!result" type="primary" :loading="submitting" @click="handleSubmit">
            提交答案
          </el-button>
          <template v-else-if="mode === 'random'">
            <el-button type="primary" @click="loadQuestion('random')">再来一题</el-button>
            <el-button
              v-if="!result.correct"
              :loading="wrongAdding"
              :disabled="currentInWrongBook"
              @click="handleAddWrongBook"
            >
              {{ currentInWrongBook ? '已在错题本' : '加入错题本' }}
            </el-button>
            <el-button
              v-else
              :loading="noteSaving"
              :disabled="currentInNotes"
              @click="handleAddNote"
            >
              {{ currentInNotes ? '已在备忘录' : '添加到笔记' }}
            </el-button>
          </template>
          <p v-else class="daily-done-tip">今日每日一练请在主页完成</p>
        </div>
      </template>

      <div v-else-if="mode === 'random' && !examPrefs.isConfigured" class="exhausted-panel">
        <p class="exhausted-title">请先完成备考设置</p>
        <p class="exhausted-tip">在主页设置省份、届别、专业类型与考试科目后，即可开始随机刷题。</p>
        <el-button type="primary" @click="promptSetupGuide">前往主页设置</el-button>
      </div>

      <div v-else-if="mode === 'random' && poolExhausted" class="exhausted-panel">
        <p class="exhausted-title">今日该范围题目已刷完</p>
        <p class="exhausted-tip">可明天再来、在主页切换科目，或清空复习记录后重新刷题。</p>
        <el-button v-if="showResetButton" type="primary" @click="openResetDialog">清空重刷</el-button>
      </div>

      <el-empty v-else description="暂无题目" :image-size="64" />
    </div>

    <el-drawer
      v-model="wrongDrawerOpen"
      title="错题本"
      direction="ltr"
      size="400px"
      class="stitch-drawer"
      :append-to-body="true"
    >
      <div class="drawer-body stitch-form" v-loading="wrongListLoading">
        <template v-if="wrongView === 'list'">
          <div class="drawer-filters">
            <div class="filter-field">
              <span class="filter-label">科目筛选</span>
              <el-select
                v-model="wrongListSubject"
                placeholder="全部科目"
                clearable
                class="filter-control"
                :popper-class="STITCH_POPPER"
              >
                <el-option label="全部科目" value="" />
                <el-option v-for="s in practiceSubjects" :key="s" :label="s" :value="s" />
              </el-select>
            </div>
            <div class="filter-field-row">
              <div class="filter-field filter-field--grow">
                <span class="filter-label">加入日期</span>
                <el-date-picker
                  v-model="wrongListDate"
                  type="date"
                  value-format="YYYY-MM-DD"
                  placeholder="不限日期"
                  clearable
                  class="filter-control"
                  :popper-class="STITCH_POPPER"
                />
              </div>
              <button
                type="button"
                class="batch-clear-btn"
                :disabled="!wrongList.length"
                @click="handleClearWrongBook"
              >
                一键清空
              </button>
            </div>
          </div>
          <el-empty v-if="!wrongList.length" description="暂无错题" :image-size="56" />
          <ul v-else class="record-list">
            <li v-for="item in wrongList" :key="item.id" class="record-card">
              <button type="button" class="record-item" @click="openWrongDetail(item.id)">
                <div class="record-item-head">
                  <span class="record-subject">{{ item.subject }}</span>
                  <span
                    class="record-delete-inline"
                    @click.stop="handleDeleteWrong(item.id, item.questionId)"
                  >
                    删除
                  </span>
                </div>
                <span class="record-stem">{{ item.stem }}</span>
                <span class="record-meta">
                  错选 {{ item.userAnswer }} · {{ formatTime(item.lastWrongAt) }}
                </span>
              </button>
            </li>
          </ul>
        </template>
        <template v-else-if="wrongDetail">
          <el-button link type="primary" class="drawer-back" @click="backToWrongList">
            返回列表
          </el-button>
          <span class="detail-subject">{{ wrongDetail.subject }}</span>
          <p class="stem">{{ wrongDetail.stem }}</p>
          <div class="options options--readonly">
            <div
              v-for="opt in wrongDetail.options"
              :key="opt"
              class="option-btn"
              :class="detailOptionClass(
                parseOption(opt).label,
                wrongDetail.userAnswer,
                wrongDetail.answer,
              )"
            >
              <span class="opt-key">{{ parseOption(opt).label }}</span>
              <span>{{ parseOption(opt).text }}</span>
            </div>
          </div>
          <div v-if="wrongDetail.analysis" class="analysis">
            <span class="st-label-caps">解析</span>
            <p>{{ wrongDetail.analysis }}</p>
          </div>
        </template>
      </div>
    </el-drawer>

    <el-drawer
      v-model="notesDrawerOpen"
      title="备忘录"
      direction="rtl"
      size="400px"
      class="stitch-drawer"
      :append-to-body="true"
    >
      <div class="drawer-body stitch-form" v-loading="notesListLoading">
        <template v-if="notesView === 'list'">
          <div class="drawer-filters">
            <div class="filter-field">
              <span class="filter-label">科目筛选</span>
              <el-select
                v-model="notesListSubject"
                placeholder="全部科目"
                clearable
                class="filter-control"
                :popper-class="STITCH_POPPER"
              >
                <el-option label="全部科目" value="" />
                <el-option v-for="s in practiceSubjects" :key="s" :label="s" :value="s" />
              </el-select>
            </div>
            <div class="filter-field-row">
              <div class="filter-field filter-field--grow">
                <span class="filter-label">创建日期</span>
                <el-date-picker
                  v-model="notesListDate"
                  type="date"
                  value-format="YYYY-MM-DD"
                  placeholder="不限日期"
                  clearable
                  class="filter-control"
                  :popper-class="STITCH_POPPER"
                />
              </div>
              <button
                type="button"
                class="batch-clear-btn"
                :disabled="!notesList.length"
                @click="handleClearNotes"
              >
                一键清空
              </button>
            </div>
          </div>
          <el-empty v-if="!notesList.length" description="暂无笔记" :image-size="56" />
          <ul v-else class="record-list">
            <li v-for="item in notesList" :key="item.id" class="record-card">
              <button type="button" class="record-item" @click="openNoteDetail(item.id)">
                <div class="record-item-head">
                  <span class="record-subject">{{ item.subject }}</span>
                  <span
                    class="record-delete-inline"
                    @click.stop="handleDeleteNote(item.id, item.questionId)"
                  >
                    删除
                  </span>
                </div>
                <span class="record-stem">{{ item.stem }}</span>
                <span v-if="item.userNote" class="record-note">{{ item.userNote }}</span>
                <span class="record-meta">{{ formatTime(item.createdAt) }}</span>
              </button>
            </li>
          </ul>
        </template>
        <template v-else-if="notesDetail">
          <el-button link type="primary" class="drawer-back" @click="backToNotesList">
            返回列表
          </el-button>
          <span class="detail-subject">{{ notesDetail.subject }}</span>
          <p class="stem">{{ notesDetail.stem }}</p>
          <div class="options options--readonly">
            <div
              v-for="opt in notesDetail.options"
              :key="opt"
              class="option-btn"
              :class="detailOptionClass(parseOption(opt).label, undefined, notesDetail.answer)"
            >
              <span class="opt-key">{{ parseOption(opt).label }}</span>
              <span>{{ parseOption(opt).text }}</span>
            </div>
          </div>
          <div v-if="notesDetail.userNote" class="user-note">
            <span class="st-label-caps">备注</span>
            <p>{{ notesDetail.userNote }}</p>
          </div>
          <div v-if="notesDetail.analysis" class="analysis">
            <span class="st-label-caps">解析</span>
            <p>{{ notesDetail.analysis }}</p>
          </div>
        </template>
      </div>
    </el-drawer>

    <el-drawer
      v-model="historyDrawerOpen"
      title="答题历史"
      direction="ltr"
      size="400px"
      class="stitch-drawer"
      :append-to-body="true"
    >
      <div class="drawer-body stitch-form" v-loading="historyLoading">
        <el-empty v-if="!historyLoading && !historyList.length" description="暂无答题记录" :image-size="56" />
        <ul v-else class="record-list">
          <li v-for="item in historyList" :key="item.id" class="record-card">
            <div class="record-item record-item--static">
              <div class="record-item-head">
                <span class="record-subject">{{ item.subject }}</span>
                <span
                  class="record-result"
                  :class="item.correct ? 'record-result--ok' : 'record-result--bad'"
                >
                  {{ item.correct ? '正确' : '错误' }}
                </span>
              </div>
              <span class="record-stem">{{ item.stem }}</span>
              <span class="record-meta">
                {{ sourceLabel(item.source) }} · 作答 {{ item.userAnswer }} ·
                {{ formatTime(item.createdAt) }}
              </span>
            </div>
          </li>
        </ul>
        <el-pagination
          v-if="historyTotal > historyPageSize"
          class="history-pagination"
          layout="prev, pager, next"
          small
          background
          :total="historyTotal"
          :page-size="historyPageSize"
          :current-page="historyPageNo"
          @current-change="onHistoryPageChange"
        />
      </div>
    </el-drawer>

    <el-drawer
      v-model="filterDrawerOpen"
      title="自定义刷题范围"
      direction="rtl"
      size="360px"
      class="stitch-drawer"
      :append-to-body="true"
    >
      <div class="drawer-body stitch-form filter-drawer">
        <p class="filter-drawer__tip">
          默认在全随机模式下，从已选备考科目中混合抽题。可改为只刷某一科；切换范围不会清除复习记录。
        </p>
        <div class="filter-drawer__field">
          <span class="filter-label">刷题模式</span>
          <el-radio-group v-model="filterMode" class="filter-drawer__options">
            <el-radio value="all">全随机（全部备考科目混合）</el-radio>
            <el-radio value="single">指定科目</el-radio>
          </el-radio-group>
        </div>
        <div v-if="filterMode === 'single'" class="filter-drawer__field">
          <span class="filter-label">选择科目</span>
          <el-select
            v-model="filterSubject"
            placeholder="选择科目"
            class="filter-control"
            :popper-class="STITCH_POPPER"
          >
            <el-option v-for="s in practiceSubjects" :key="s" :label="s" :value="s" />
          </el-select>
        </div>
        <el-button type="primary" class="filter-drawer__save" :loading="filterSaving" @click="applyRandomFilter">
          保存并刷新题目
        </el-button>
      </div>
    </el-drawer>

    <StitchDialog
      v-model="setupGuideDialogOpen"
      title="请先完成备考设置"
      subtitle="随机刷题需要先在主页配置省份、届别、专业类型与考试科目。确认后将跳转到主页并打开备考设置。"
      confirm-text="前往主页设置"
      cancel-text="稍后再说"
      width="440px"
      @confirm="goDashboardForSettings"
    />

    <StitchDialog
      v-model="resetDialogOpen"
      title="清空重刷"
      subtitle="清除复习进度、今日已做与累计统计；错题本与备忘录不受影响。"
      confirm-text="确认清空并重刷"
      :loading="resetLoading"
      danger
      width="460px"
      @confirm="applyReset"
    >
      <div class="reset-form stitch-form">
        <p class="reset-form__label">清空范围</p>
        <el-radio-group v-model="resetScope" class="reset-form__options">
          <el-radio value="all">全部备考科目</el-radio>
          <el-radio value="single">指定科目</el-radio>
        </el-radio-group>
        <el-select
          v-if="resetScope === 'single'"
          v-model="resetSubject"
          placeholder="选择科目"
          class="reset-form__select"
          :popper-class="STITCH_POPPER"
        >
          <el-option v-for="s in practiceSubjects" :key="s" :label="s" :value="s" />
        </el-select>
      </div>
    </StitchDialog>

    <StitchDialog
      v-model="confirmDialogOpen"
      :title="confirmDialogTitle"
      :subtitle="confirmDialogSubtitle"
      confirm-text="确定"
      :loading="confirmDialogLoading"
      :danger="confirmDialogDanger"
      @confirm="runConfirmDialog"
    />

    <StitchDialog
      v-model="noteDialogOpen"
      title="添加到笔记"
      subtitle="可填写备注，便于日后复习（可选）"
      confirm-text="保存"
      :loading="noteSaving"
      @confirm="saveNote"
    >
      <textarea
        v-model="noteDraft"
        class="note-textarea"
        rows="4"
        placeholder="例如：考点、易错点…"
      />
    </StitchDialog>
  </section>
</template>

<style scoped>
.practice-panel {
  height: 100%;
}

.panel-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.panel-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
  gap: 8px;
}

.panel-meta--random {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: start;
  gap: 8px;
}

.panel-meta-side--right {
  display: flex;
  flex-direction: column;
  gap: 4px;
  align-items: flex-end;
}

.record-item--static {
  cursor: default;
}

.record-result {
  font-size: 11px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 999px;
}

.record-result--ok {
  color: #15803d;
  background: rgb(34 197 94 / 12%);
}

.record-result--bad {
  color: #b91c1c;
  background: rgb(239 68 68 / 12%);
}

.history-pagination {
  margin-top: 12px;
  justify-content: center;
}

.panel-meta-center {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  flex: 1;
  min-width: 0;
}

.meta-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  justify-content: center;
}

.drawer-filters {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 14px;
  margin: 0 0 8px;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(12px) saturate(1.25);
  -webkit-backdrop-filter: blur(12px) saturate(1.25);
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.55);
}

.filter-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  min-width: 0;
}

.filter-field--grow {
  flex: 1;
  min-width: 0;
}

.filter-field-row {
  display: flex;
  gap: 8px;
  align-items: flex-end;
}

.filter-label {
  font-size: 12px;
  font-weight: 600;
  color: var(--st-on-surface-variant);
}

.filter-control {
  width: 100%;
}

.batch-clear-btn {
  flex-shrink: 0;
  border: none;
  background: rgb(220 38 38 / 10%);
  color: #dc2626;
  padding: 0 14px;
  height: 36px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  align-self: flex-end;
  transition: background 0.15s, transform 0.12s;
}

.batch-clear-btn:hover:not(:disabled) {
  background: rgb(220 38 38 / 16%);
}

.batch-clear-btn:active:not(:disabled) {
  transform: scale(0.98);
}

.batch-clear-btn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

.side-entry {
  flex-shrink: 0;
  border: 1px solid var(--st-outline-variant);
  background: var(--st-surface-container-low);
  color: var(--st-secondary);
  padding: 4px 10px;
  border-radius: var(--st-radius-sm);
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
}

.side-entry:hover {
  border-color: var(--st-secondary);
}

.streak {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-weight: 600;
  color: var(--st-tertiary);
}

.filter-hint {
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.filter-hint--btn {
  margin: 0;
  padding: 0;
  border: none;
  background: transparent;
  font: inherit;
  cursor: pointer;
  text-decoration: underline;
  text-decoration-color: rgb(100 116 139 / 35%);
  text-underline-offset: 3px;
}

.filter-hint--btn:hover:not(:disabled) {
  color: var(--st-secondary);
  text-decoration-color: rgb(34 197 94 / 45%);
}

.filter-hint--btn:disabled {
  cursor: default;
  text-decoration: none;
  opacity: 0.72;
}

.filter-drawer {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.filter-drawer__tip {
  margin: 0;
  font-size: 13px;
  line-height: 1.5;
  color: var(--st-on-surface-variant);
}

.filter-drawer__field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-drawer__options {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
}

.filter-drawer__options :deep(.el-radio) {
  height: auto;
  margin-right: 0;
  white-space: normal;
  align-items: flex-start;
}

.filter-drawer__options :deep(.el-radio__label) {
  line-height: 1.45;
  white-space: normal;
}

.filter-drawer__save {
  align-self: flex-start;
}

.other-pending-hint {
  margin: 0;
  font-size: 12px;
  line-height: 1.45;
  color: var(--st-tertiary);
  text-align: center;
  max-width: 100%;
}

.streak-icon {
  width: 16px;
  height: 16px;
  color: var(--st-tertiary-container);
}

.subject-tag {
  background: var(--st-surface-container);
  color: var(--st-secondary);
  padding: 2px 10px;
  border-radius: var(--st-radius-sm);
  font-size: 13px;
  font-weight: 600;
}

.subject-tag--btn {
  border: 1px solid var(--st-outline-variant);
  cursor: pointer;
}

.subject-tag--btn:hover {
  border-color: var(--st-secondary);
}

.subject-tag--link {
  border: 1px dashed #93c5fd;
  cursor: pointer;
  background: rgb(59 130 246 / 8%);
  color: #1d4ed8;
}

.subject-tag--link:hover {
  border-color: #3b82f6;
  background: rgb(59 130 246 / 14%);
}

.reset-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.reset-form__label {
  margin: 0;
  font-size: 13px;
  font-weight: 600;
  color: var(--st-on-surface-variant);
}

.reset-form__options {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: stretch;
}

.reset-form__options :deep(.el-radio) {
  margin-right: 0;
  width: 100%;
}

.reset-form__select {
  width: 100%;
}

.note-textarea {
  width: 100%;
  min-height: 96px;
  padding: 12px 14px;
  border: 1px solid var(--st-outline-variant);
  border-radius: 12px;
  font: inherit;
  font-size: 14px;
  line-height: 1.55;
  resize: vertical;
  background: var(--st-surface-container-low);
  color: var(--st-on-surface);
}

.note-textarea:focus {
  outline: none;
  border-color: var(--st-secondary);
  box-shadow: 0 0 0 3px rgb(34 197 94 / 12%);
}

.panel-stats {
  font-size: 13px;
  color: var(--st-on-surface-variant);
  margin-bottom: 16px;
}

.sep {
  margin: 0 8px;
  opacity: 0.5;
}

.stem {
  margin: 0 0 16px;
  font-size: 15px;
  line-height: 1.6;
  color: var(--st-on-surface);
}

.question-subject {
  margin: 0 0 8px;
  font-size: 12px;
  font-weight: 600;
  color: var(--st-secondary);
}

.options {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.options--readonly .option-btn {
  cursor: default;
}

.option-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  text-align: left;
  padding: 10px 12px;
  border: 1px solid var(--st-outline-variant);
  border-radius: var(--st-radius-sm);
  background: var(--st-surface);
  cursor: pointer;
  font: inherit;
  color: var(--st-on-surface);
  transition: border-color 0.15s, background 0.15s;
}

.option-btn:hover:not(:disabled) {
  border-color: var(--st-secondary);
  background: var(--st-surface-container-low);
}

.option-btn--active {
  border-color: var(--st-secondary);
  background: var(--st-surface-container-low);
}

.option-btn:disabled {
  cursor: default;
}

.option--correct {
  border-color: var(--st-primary-container);
  background: rgb(34 197 94 / 10%);
}

.option--wrong {
  border-color: #ba1a1a;
  background: rgb(186 26 26 / 8%);
}

.opt-key {
  font-weight: 700;
  min-width: 18px;
}

.tag-wrong,
.tag-correct {
  margin-left: auto;
  font-size: 11px;
  font-weight: 600;
}

.tag-wrong {
  color: #ba1a1a;
}

.tag-correct {
  color: #004b1e;
}

.analysis,
.user-note {
  margin-top: 16px;
  padding: 12px;
  background: var(--st-surface-container-low);
  border-radius: var(--st-radius-sm);
}

.analysis p,
.user-note p {
  margin: 6px 0 0;
  font-size: 13px;
  line-height: 1.6;
}

.actions {
  margin-top: 16px;
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.daily-done-tip {
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.drawer-body {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.drawer-tip {
  font-size: 13px;
  color: var(--st-on-surface-variant);
  line-height: 1.5;
  margin: 0;
}

.drawer-mode {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
}

.drawer-select,
.drawer-date {
  width: 100%;
}

.drawer-save {
  width: 100%;
}

.drawer-back {
  align-self: flex-start;
  margin-bottom: -8px;
}

.detail-subject {
  font-size: 12px;
  font-weight: 600;
  color: var(--st-secondary);
}

.record-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.record-card {
  list-style: none;
}

.record-item {
  width: 100%;
  text-align: left;
  border: 1px solid var(--st-outline-variant);
  border-radius: 14px;
  padding: 12px 14px;
  background: var(--st-surface);
  cursor: pointer;
  font: inherit;
  color: var(--st-on-surface);
  display: block;
  transition: border-color 0.15s, box-shadow 0.15s, transform 0.12s;
  box-shadow: 0 1px 2px rgb(15 23 42 / 4%);
}

.record-item:hover {
  border-color: rgb(34 197 94 / 45%);
  box-shadow: 0 4px 14px rgb(15 23 42 / 6%);
  transform: translateY(-1px);
}

.record-item-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 6px;
}

.record-delete-inline {
  flex-shrink: 0;
  font-size: 12px;
  font-weight: 600;
  color: #dc2626;
  padding: 4px 8px;
  border-radius: 8px;
  transition: background 0.15s;
}

.record-delete-inline:hover {
  background: rgb(220 38 38 / 10%);
}

.record-subject {
  font-size: 12px;
  font-weight: 700;
  color: #15803d;
  background: rgb(34 197 94 / 12%);
  padding: 2px 8px;
  border-radius: 999px;
}

.record-stem {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 6px;
}

.record-meta {
  display: block;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.record-note {
  display: block;
  font-size: 12px;
  color: var(--st-on-surface-variant);
  margin-bottom: 4px;
}

.exhausted-panel {
  text-align: center;
  padding: 24px 12px;
}

.exhausted-title {
  font-size: 15px;
  font-weight: 600;
  margin: 0 0 8px;
}

.exhausted-tip {
  font-size: 13px;
  color: var(--st-on-surface-variant);
  margin: 0 0 16px;
  line-height: 1.5;
}
</style>
