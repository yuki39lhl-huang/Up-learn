<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchDaily, fetchDailyStatus } from '../../api/practice'
import { usePracticeQuiz } from '../../composables/usePracticeQuiz'
import { useExamPrefsStore } from '../../stores/examPrefs'
import { calcExamCountdown } from '../../utils/examCountdown'
import { isSelfExamComprehensive } from '../../utils/examSubjects'
import { parseOption } from '../../utils/option'
import ExamSettingsDialog from './ExamSettingsDialog.vue'
import StitchIcon from './StitchIcon.vue'

const examPrefs = useExamPrefsStore()
const settingsOpen = ref(false)
const completedToday = ref(false)

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

const countdown = computed(() => {
  const p = examPrefs.prefs.province
  const c = examPrefs.prefs.cohortYear
  return p && c != null ? calcExamCountdown(c, p) : null
})

const dailySubjectLabel = computed(() => {
  if (examPrefs.prefs.dailySubjectMode === 'random') return '随机（备考设置）'
  return examPrefs.prefs.dailySubject || '未设置'
})

async function loadDaily() {
  if (!examPrefs.isConfigured) {
    question.value = null
    return
  }
  loading.value = true
  resetAnswer()
  try {
    const status = await fetchDailyStatus()
    completedToday.value = status.completedToday
    const subject = status.subject ?? examPrefs.pickDailyPracticeSubject()
    question.value = await fetchDaily(subject)
  } catch (e) {
    question.value = null
    ElMessage.error(e instanceof Error ? e.message : '加载每日一练失败')
  } finally {
    loading.value = false
  }
}

async function handleSubmit() {
  if (!question.value || !selected.value || completedToday.value) return
  await submit('daily', {
    skipSelectCheck: true,
    onSuccess: () => {
      completedToday.value = true
      ElMessage.success('今日签到 +1')
    },
  })
}

function onSettingsReset() {
  question.value = null
  completedToday.value = false
}

onMounted(async () => {
  await loadStats()
  await loadDaily()
})
</script>

<template>
  <div class="dashboard">
    <div class="dashboard__grid">
      <section class="dash-card dash-card--exam">
        <header class="dash-card__head">
          <div>
            <p class="dash-card__eyebrow">升学通 · 备考中心</p>
            <h2>考试倒计时</h2>
          </div>
          <el-button type="primary" plain size="small" @click="settingsOpen = true">备考设置</el-button>
        </header>

        <div v-if="countdown" class="countdown-block">
          <div class="countdown-block__nums">
            <div class="countdown-block__unit">
              <strong>{{ countdown.days }}</strong>
              <span>天</span>
            </div>
            <div class="countdown-block__sep">:</div>
            <div class="countdown-block__unit">
              <strong>{{ String(countdown.hours).padStart(2, '0') }}</strong>
              <span>时</span>
            </div>
            <div class="countdown-block__sep">:</div>
            <div class="countdown-block__unit">
              <strong>{{ String(countdown.minutes).padStart(2, '0') }}</strong>
              <span>分</span>
            </div>
          </div>
          <p class="countdown-block__date">{{ countdown.examDateLabel }}</p>
        </div>
        <div v-else class="dash-empty">
          <p>设置省份与届别后显示倒计时</p>
        </div>

        <dl class="profile-list">
          <div class="profile-list__item">
            <dt>省份</dt>
            <dd :class="{ 'is-muted': !examPrefs.hasProvince }">
              {{ examPrefs.prefs.province || '待选择' }}
            </dd>
          </div>
          <div class="profile-list__item">
            <dt>届别</dt>
            <dd>{{ examPrefs.prefs.cohortYear ? `${examPrefs.prefs.cohortYear} 届` : '待选择' }}</dd>
          </div>
          <div class="profile-list__item profile-list__item--full">
            <dt>专业类型</dt>
            <dd :class="{ 'is-muted': !examPrefs.hasMajorCategory }">
              {{ examPrefs.prefs.majorCategory || '待选择' }}
            </dd>
          </div>
          <div class="profile-list__item profile-list__item--full">
            <dt>考试科目</dt>
            <dd>
              <div v-if="examPrefs.prefs.subjectSelection" class="subject-display">
                <div class="subject-display__row">
                  <span class="subject-display__label">公共课</span>
                  <div v-if="examPrefs.prefs.subjectSelection.public.length" class="chip-row">
                    <span
                      v-for="s in examPrefs.prefs.subjectSelection.public"
                      :key="`req-${s}`"
                      class="chip chip--required"
                    >
                      {{ s }}
                    </span>
                  </div>
                  <span v-else class="is-muted">暂不选择</span>
                </div>
                <div class="subject-display__row">
                  <span class="subject-display__label">专业基础</span>
                  <div v-if="examPrefs.prefs.subjectSelection.foundation.length" class="chip-row">
                    <span
                      v-for="s in examPrefs.prefs.subjectSelection.foundation"
                      :key="`f-${s}`"
                      class="chip chip--foundation"
                    >
                      {{ s }}
                    </span>
                  </div>
                  <span v-else class="is-muted">暂不选择</span>
                </div>
                <div class="subject-display__row">
                  <span class="subject-display__label">专业综合</span>
                  <div v-if="examPrefs.prefs.subjectSelection.comprehensive.length" class="chip-row">
                    <span
                      v-for="s in examPrefs.prefs.subjectSelection.comprehensive"
                      :key="`c-${s}`"
                      class="chip chip--comprehensive"
                      :class="{ 'chip--muted': isSelfExamComprehensive(s) }"
                    >
                      {{ s }}
                    </span>
                  </div>
                  <span v-else class="is-muted">暂不选择</span>
                </div>
              </div>
              <span v-else class="is-muted">请先完成备考设置</span>
            </dd>
          </div>
        </dl>
      </section>

      <section class="dash-card dash-card--daily" v-loading="loading">
        <header class="dash-card__head dash-card__head--daily">
          <div class="daily-title-block">
            <p class="dash-card__eyebrow">坚持打卡</p>
            <div class="daily-title-row">
              <h2>每日一练</h2>
              <span v-if="examPrefs.isConfigured" class="daily-subject-inline">
                每日科目 · {{ dailySubjectLabel }}
              </span>
            </div>
          </div>
          <div class="checkin-stats">
            <span class="checkin-stats__item">
              累计 <strong>{{ stats?.totalCheckInDays ?? 0 }}</strong> 天
            </span>
            <span class="checkin-stats__sep" />
            <span class="checkin-stats__item checkin-stats__item--streak">
              <StitchIcon name="flame" class="checkin-stats__icon" />
              连续 <strong>{{ stats?.streak ?? 0 }}</strong> 天
            </span>
          </div>
        </header>

        <p class="daily-tip">每天 1 题 · 完成提交即签到 +1</p>

        <div v-if="!examPrefs.isConfigured" class="dash-empty dash-empty--action">
          <p>请先完成备考设置（省份、届别、专业类型、科目）</p>
          <el-button type="primary" @click="settingsOpen = true">去设置</el-button>
        </div>

        <template v-else>
          <div v-if="completedToday" class="daily-done-banner">
            <el-tag type="success" effect="dark" round>今日已完成</el-tag>
            <span>明日 0 点刷新</span>
          </div>

          <template v-if="question">
            <article class="quiz">
              <p class="quiz__stem">{{ question.stem }}</p>
              <div class="quiz__options">
                <button
                  v-for="opt in question.options"
                  :key="opt"
                  type="button"
                  class="quiz__option"
                  :class="[
                    optionClass(parseOption(opt).label),
                    { 'quiz__option--active': selected === parseOption(opt).label && !result },
                  ]"
                  :disabled="!!result || completedToday"
                  @click="selected = parseOption(opt).label"
                >
                  <span class="quiz__key">{{ parseOption(opt).label }}</span>
                  <span class="quiz__text">{{ parseOption(opt).text }}</span>
                </button>
              </div>
              <div v-if="result?.analysis" class="quiz__analysis">
                <span class="st-label-caps">解析</span>
                <p>{{ result.analysis }}</p>
              </div>
              <footer class="quiz__foot">
                <el-button
                  v-if="!result && !completedToday"
                  type="primary"
                  size="large"
                  :loading="submitting"
                  :disabled="!selected"
                  @click="handleSubmit"
                >
                  提交并签到
                </el-button>
              </footer>
            </article>
          </template>
          <el-empty v-else-if="!loading" description="暂无题目" :image-size="56" />
        </template>
      </section>
    </div>

    <ExamSettingsDialog v-model="settingsOpen" @saved="loadDaily" @reset="onSettingsReset" />
  </div>
</template>

<style scoped>
.dashboard {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.dashboard__grid {
  display: grid;
  grid-template-columns: minmax(280px, 1fr) minmax(320px, 1.15fr);
  gap: 20px;
  align-items: stretch;
}

@media (max-width: 900px) {
  .dashboard__grid {
    grid-template-columns: 1fr;
  }
}

.dash-card {
  background: var(--st-surface);
  border: 1px solid var(--st-outline-variant);
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 1px 2px rgb(0 0 0 / 4%);
}

.dash-card--daily {
  display: flex;
  flex-direction: column;
  min-height: 420px;
}

.dash-card__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 20px;
}

.dash-card__eyebrow {
  margin: 0 0 4px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.04em;
  color: var(--st-secondary);
}

.dash-card__head h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 700;
}

.countdown-block {
  text-align: center;
  padding: 20px 12px 24px;
  margin-bottom: 20px;
  border-radius: 16px;
  background: linear-gradient(135deg, rgb(34 197 94 / 8%), rgb(59 130 246 / 6%));
}

.countdown-block__nums {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.countdown-block__unit {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 56px;
}

.countdown-block__unit strong {
  font-size: 36px;
  font-weight: 800;
  line-height: 1;
  color: var(--st-on-surface);
}

.countdown-block__unit span {
  margin-top: 4px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.countdown-block__sep {
  font-size: 28px;
  font-weight: 300;
  color: var(--st-on-surface-variant);
  opacity: 0.5;
  padding-bottom: 16px;
}

.countdown-block__date {
  margin: 12px 0 0;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.profile-list {
  margin: 0;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px 16px;
}

.profile-list__item {
  margin: 0;
}

.profile-list__item--full {
  grid-column: 1 / -1;
}

.profile-list dt {
  margin: 0 0 4px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.profile-list dd {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
}

.profile-list .is-muted {
  color: var(--st-on-surface-variant);
  font-weight: 500;
}

.chip-row {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.chip {
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  background: var(--st-surface-container);
  color: var(--st-secondary);
}

.chip--required {
  background: rgb(34 197 94 / 12%);
  color: #15803d;
}

.chip--foundation {
  background: rgb(59 130 246 / 12%);
  color: #1d4ed8;
}

.chip--comprehensive {
  background: rgb(168 85 247 / 12%);
  color: #7e22ce;
}

.chip--muted {
  background: var(--st-surface-container);
  color: var(--st-on-surface-variant);
}

.subject-display {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.subject-display__row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
}

.subject-display__label {
  flex-shrink: 0;
  min-width: 56px;
  font-size: 12px;
  font-weight: 600;
  color: var(--st-on-surface-variant);
}

.dash-card__head--daily {
  flex-wrap: wrap;
  align-items: center;
}

.daily-title-block {
  flex: 1;
  min-width: 180px;
}

.daily-title-row {
  display: flex;
  align-items: baseline;
  flex-wrap: wrap;
  gap: 10px;
}

.daily-subject-inline {
  font-size: 13px;
  font-weight: 600;
  color: var(--st-secondary);
  padding: 2px 10px;
  border-radius: 999px;
  background: var(--st-surface-container);
}

.checkin-stats {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 8px 14px;
  border-radius: 12px;
  background: var(--st-surface-container-low);
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.checkin-stats__item strong {
  font-size: 16px;
  color: var(--st-on-surface);
  margin: 0 2px;
}

.checkin-stats__item--streak strong {
  color: #c2410c;
}

.checkin-stats__icon {
  width: 14px;
  height: 14px;
  vertical-align: -2px;
  margin-right: 2px;
}

.checkin-stats__sep {
  width: 1px;
  height: 16px;
  background: var(--st-outline-variant);
}

.daily-tip {
  margin: 0 0 16px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  line-height: 1.5;
}

.dash-empty {
  text-align: center;
  padding: 32px 16px;
  color: var(--st-on-surface-variant);
  font-size: 14px;
}

.dash-empty--action {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.daily-done-banner {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
  padding: 12px 14px;
  border-radius: 12px;
  background: rgb(34 197 94 / 10%);
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.quiz {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.quiz__stem {
  margin: 0 0 16px;
  font-size: 16px;
  line-height: 1.65;
  font-weight: 500;
}

.quiz__options {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.quiz__option {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  width: 100%;
  text-align: left;
  padding: 14px 16px;
  border: 1.5px solid var(--st-outline-variant);
  border-radius: 12px;
  background: var(--st-surface);
  cursor: pointer;
  font: inherit;
  transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
}

.quiz__option:hover:not(:disabled) {
  border-color: var(--st-secondary);
  background: var(--st-surface-container-low);
}

.quiz__option--active {
  border-color: var(--st-secondary);
  background: rgb(34 197 94 / 6%);
  box-shadow: 0 0 0 1px rgb(34 197 94 / 15%);
}

.quiz__option:disabled {
  cursor: default;
}

.quiz__key {
  font-weight: 700;
  min-width: 20px;
}

.quiz__text {
  flex: 1;
  line-height: 1.5;
}

.option--correct {
  border-color: #16a34a;
  background: rgb(34 197 94 / 10%);
}

.option--wrong {
  border-color: #dc2626;
  background: rgb(220 38 38 / 8%);
}

.quiz__analysis {
  margin-top: 16px;
  padding: 14px;
  border-radius: 12px;
  background: var(--st-surface-container-low);
  font-size: 13px;
  line-height: 1.6;
}

.quiz__foot {
  margin-top: auto;
  padding-top: 20px;
}
</style>
