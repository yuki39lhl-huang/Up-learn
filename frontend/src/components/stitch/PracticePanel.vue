<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchDaily, fetchRandom, fetchStats, submitAnswer } from '../../api/practice'
import type { QuestionVO, StudyStatsVO, SubmitResultVO } from '../../types/api'
import { parseOption } from '../../utils/option'
import StitchIcon from './StitchIcon.vue'

type Mode = 'daily' | 'random'

const props = withDefaults(
  defineProps<{
    defaultMode?: Mode
  }>(),
  { defaultMode: 'daily' },
)

const loading = ref(false)
const submitting = ref(false)
const mode = ref<Mode>(props.defaultMode)
const question = ref<QuestionVO | null>(null)
const selected = ref('')
const result = ref<SubmitResultVO | null>(null)
const stats = ref<StudyStatsVO | null>(null)

const panelTitle = computed(() => (mode.value === 'daily' ? '每日一练' : '随机刷题'))

async function loadStats() {
  try {
    stats.value = await fetchStats()
  } catch {
    /* 统计失败不阻断 */
  }
}

async function loadQuestion(nextMode: Mode) {
  mode.value = nextMode
  selected.value = ''
  result.value = null
  loading.value = true
  try {
    question.value = nextMode === 'daily' ? await fetchDaily() : await fetchRandom()
  } catch (e) {
    question.value = null
    ElMessage.error(e instanceof Error ? e.message : '加载题目失败')
  } finally {
    loading.value = false
  }
}

async function handleSubmit() {
  if (!question.value || !selected.value) {
    ElMessage.warning('请先选择答案')
    return
  }
  submitting.value = true
  try {
    result.value = await submitAnswer(question.value.id, selected.value, mode.value)
    await loadStats()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '提交失败')
  } finally {
    submitting.value = false
  }
}

function optionClass(label: string) {
  if (!result.value) return ''
  if (label === result.value.answer) return 'option--correct'
  if (label === result.value.userAnswer && !result.value.correct) return 'option--wrong'
  return ''
}

onMounted(async () => {
  await loadStats()
  await loadQuestion(props.defaultMode)
})
</script>

<template>
  <section class="practice-panel st-card" v-loading="loading">
    <header class="st-card-header panel-title">{{ panelTitle }}</header>
    <div class="st-card-body">
      <div class="panel-meta">
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
            <span v-if="result && parseOption(opt).label === result.userAnswer && !result.correct" class="tag-wrong">
              你的答案
            </span>
            <span v-if="result && parseOption(opt).label === result.answer" class="tag-correct">正确答案</span>
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
          <template v-else>
            <el-button type="primary" plain @click="loadQuestion('daily')">下一题</el-button>
            <el-button @click="loadQuestion('random')">随机一题</el-button>
          </template>
        </div>
      </template>

      <el-empty v-else description="暂无题目" :image-size="64" />
    </div>
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
}

.streak {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-weight: 600;
  color: var(--st-tertiary);
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

.options {
  display: flex;
  flex-direction: column;
  gap: 8px;
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

.analysis {
  margin-top: 16px;
  padding: 12px;
  background: var(--st-surface-container-low);
  border-radius: var(--st-radius-sm);
}

.analysis p {
  margin: 6px 0 0;
  font-size: 13px;
  line-height: 1.6;
}

.actions {
  margin-top: 16px;
  display: flex;
  gap: 8px;
}
</style>
