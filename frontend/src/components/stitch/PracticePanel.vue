<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchDaily, fetchRandom } from '../../api/practice'
import { usePracticeQuiz, type PracticeMode } from '../../composables/usePracticeQuiz'
import { parseOption } from '../../utils/option'
import StitchIcon from './StitchIcon.vue'

const props = withDefaults(
  defineProps<{
    defaultMode?: PracticeMode
  }>(),
  { defaultMode: 'daily' },
)

const mode = ref<PracticeMode>(props.defaultMode)

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

async function loadQuestion(nextMode: PracticeMode) {
  mode.value = nextMode
  resetAnswer()
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
  await submit(mode.value)
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
          <template v-else-if="mode === 'random'">
            <el-button @click="loadQuestion('random')">再来一题</el-button>
          </template>
          <p v-else class="daily-done-tip">今日每日一练请在主页完成</p>
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
