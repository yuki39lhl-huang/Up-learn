import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchStats, submitAnswer } from '../api/practice'
import type { QuestionVO, StudyStatsVO, SubmitResultVO } from '../types/api'

export type PracticeMode = 'daily' | 'random'

/** 刷题面板共用：题目状态、统计、选项高亮、提交 */
export function usePracticeQuiz() {
  const loading = ref(false)
  const submitting = ref(false)
  const question = ref<QuestionVO | null>(null)
  const selected = ref('')
  const result = ref<SubmitResultVO | null>(null)
  const stats = ref<StudyStatsVO | null>(null)

  async function loadStats() {
    try {
      stats.value = await fetchStats()
    } catch {
      /* 统计失败不阻断 */
    }
  }

  function resetAnswer() {
    selected.value = ''
    result.value = null
  }

  function optionClass(label: string) {
    if (!result.value) return ''
    if (label === result.value.answer) return 'option--correct'
    if (label === result.value.userAnswer && !result.value.correct) return 'option--wrong'
    return ''
  }

  async function submit(
    mode: PracticeMode,
    options?: { skipSelectCheck?: boolean; onSuccess?: () => void | Promise<void> },
  ) {
    if (!question.value || !selected.value) {
      if (!options?.skipSelectCheck) ElMessage.warning('请先选择答案')
      return false
    }
    submitting.value = true
    try {
      result.value = await submitAnswer(question.value.id, selected.value, mode)
      await loadStats()
      await options?.onSuccess?.()
      return true
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '提交失败')
      return false
    } finally {
      submitting.value = false
    }
  }

  return {
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
  }
}
