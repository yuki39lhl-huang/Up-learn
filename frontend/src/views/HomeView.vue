<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { fetchMajorOptions, fetchSchoolList } from '../api/school'
import { fetchPaperList } from '../api/papers'
import { useAuthStore } from '../stores/auth'
import LoginModal from '../components/stitch/LoginModal.vue'
import BrandLogo from '../components/stitch/BrandLogo.vue'
import StitchIcon from '../components/stitch/StitchIcon.vue'
import {
  consoleFullPath,
  isDashboardConsoleHref,
  markConsoleDashboardEntry,
  pushConsole,
  pushConsoleHref,
  type ConsoleModule,
} from '../utils/consoleNav'
import type { MajorOptionVO, PaperListItemVO, SchoolVO } from '../types/api'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const showLoginModal = ref(false)
const loginRedirect = ref(consoleFullPath('dashboard'))

const schools = ref<SchoolVO[]>([])
const loadingSchools = ref(false)
const featuredMajors = ref<MajorOptionVO[]>([])
const previewPapers = ref<PaperListItemVO[]>([])
const activeSubject = ref('计算机基础')

const majorIconCycle = ['code', 'cpu', 'layers'] as const

const features = [
  {
    icon: 'filter' as const,
    title: '精准筛选',
    desc: '按省份、公办民办、专业类型多维筛选，快速定位目标院校。',
  },
  {
    icon: 'school' as const,
    title: '招生目录',
    desc: '对接当年招生专业明细，专业组、考试科目与校考统考一目了然。',
  },
  {
    icon: 'paper' as const,
    title: '历年真题',
    desc: '真题卷面在线作答，客观题机判，主观题可 AI 评分参考。',
  },
  {
    icon: 'practice' as const,
    title: '刷题打卡',
    desc: '每日一练与随机刷题，错题本与间隔复习帮你稳住题感。',
  },
]

const trustItems = computed(() => [
  { value: previewPapers.value.length ? `${previewPapers.value.length}+` : '真题', label: '历年试卷' },
  { value: schools.value.length ? `${schools.value.length}+` : '院校', label: '在招院校预览' },
  { value: 'AI', label: '智能批改' },
])

const featuredMajorCards = computed(() =>
  featuredMajors.value.map((m, i) => ({
    title: m.name,
    icon: majorIconCycle[i % majorIconCycle.length],
    category: m.majorCategory || m.discipline || '—',
    examTrack: m.examTrack || '—',
    discipline: m.discipline || '—',
  })),
)

function goConsole(module: ConsoleModule = 'dashboard') {
  const target = consoleFullPath(module)
  if (!auth.isLoggedIn) {
    loginRedirect.value = target
    showLoginModal.value = true
    return
  }
  if (module === 'dashboard') {
    markConsoleDashboardEntry()
  }
  pushConsole(router, module)
}

function closeLoginModal() {
  showLoginModal.value = false
}

function onLoginSuccess() {
  showLoginModal.value = false
  if (isDashboardConsoleHref(loginRedirect.value)) {
    markConsoleDashboardEntry()
  }
  pushConsoleHref(router, loginRedirect.value)
}

function openLoginFromQuery() {
  if (route.query.login !== '1') return
  const redirect = route.query.redirect
  loginRedirect.value = typeof redirect === 'string' ? redirect : consoleFullPath('dashboard')
  showLoginModal.value = true
  router.replace({ path: '/home' })
}

function scrollTo(id: string) {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

async function loadSchools() {
  loadingSchools.value = true
  try {
    const data = await fetchSchoolList({
      pageNo: 1,
      pageSize: 8,
      province: '广东',
      year: 2026,
      preferPublic: true,
    })
    schools.value = data.list
  } catch {
    schools.value = []
  } finally {
    loadingSchools.value = false
  }
}

async function loadFeaturedMajors() {
  try {
    const data = await fetchMajorOptions({
      majorCategory: '计算机类',
      pageNo: 1,
      pageSize: 3,
    })
    featuredMajors.value = data.list
    if (featuredMajors.value.length < 3) {
      const more = await fetchMajorOptions({ pageNo: 1, pageSize: 3 })
      featuredMajors.value = more.list
    }
  } catch {
    featuredMajors.value = []
  }
}

async function loadPreviewPapers() {
  if (!auth.isLoggedIn) {
    previewPapers.value = []
    return
  }
  try {
    const list = await fetchPaperList({ province: '广东', subject: activeSubject.value })
    previewPapers.value = (list || []).slice(0, 4)
  } catch {
    previewPapers.value = []
  }
}

function chipClass(row: SchoolVO) {
  return row.type === '公办' ? 'chip chip--public' : 'chip chip--private'
}

function paperMeta(p: PaperListItemVO) {
  const parts = [`${p.year} 年`, p.subject]
  if (p.questionCount) parts.push(`${p.questionCount} 题`)
  return parts.join(' · ')
}

onMounted(async () => {
  openLoginFromQuery()
  await Promise.all([loadSchools(), loadFeaturedMajors(), loadPreviewPapers()])
})
</script>

<template>
  <div class="landing-page">
    <header class="landing-nav">
      <div class="nav-inner">
        <button type="button" class="logo-wrap" @click="router.push('/home')">
          <BrandLogo variant="landing" :size="44" />
        </button>
        <nav class="nav-links">
          <a href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
          <a href="#papers-preview" @click.prevent="scrollTo('papers-preview')">历年真题</a>
          <a href="#daily-practice" @click.prevent="scrollTo('daily-practice')">每日一练</a>
          <a href="#random-practice" @click.prevent="scrollTo('random-practice')">随机刷题</a>
        </nav>
        <button type="button" class="nav-cta" @click="goConsole()">进入控制台 →</button>
      </div>
    </header>

    <section class="hero">
      <div class="hero-inner">
        <h1 class="hero-title">查院校，刷真题，一站完成。</h1>
        <p class="hero-sub">面向专升本备考的招生数据与在线练习平台，让升学之路更有确定性。</p>
        <div class="hero-btns">
          <button type="button" class="btn btn-primary" @click="goConsole('school')">开始查询</button>
          <button type="button" class="btn btn-outline" @click="goConsole('random')">体验刷题</button>
        </div>
        <ul class="trust-strip" aria-label="平台数据概览">
          <li v-for="t in trustItems" :key="t.label">
            <strong>{{ t.value }}</strong>
            <span>{{ t.label }}</span>
          </li>
        </ul>
        <div class="hero-visual">
          <div class="gradient-card">
            <div class="stats-float">
              <div class="stats-head">
                <div>
                  <span class="stats-region">广东省</span>
                  <span class="stats-year">2026 年招生目录预览</span>
                </div>
                <span class="stats-badge">登录后完整使用</span>
              </div>
              <div class="stats-metrics">
                <div class="metric">
                  <small>在招院校（预览）</small>
                  <strong>{{ schools.length || '—' }}</strong>
                </div>
                <div class="metric">
                  <small>热门专业类</small>
                  <strong>计算机类</strong>
                </div>
                <div class="metric">
                  <small>备考闭环</small>
                  <strong>真题+刷题</strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="features-section">
      <div class="section-inner">
        <h2 class="section-heading">全面了解，精准决策</h2>
        <div class="features-grid">
          <article v-for="f in features" :key="f.title" class="feature-card">
            <div class="feature-icon">
              <StitchIcon :name="f.icon" />
            </div>
            <h3>{{ f.title }}</h3>
            <p>{{ f.desc }}</p>
          </article>
        </div>
      </div>
    </section>

    <!-- 招生查询：真实数据只读预览 -->
    <section id="school-query" class="scroll-section muted">
      <div class="section-inner">
        <div class="section-head">
          <h2>招生库查询</h2>
          <p>广东 2026 在招院校预览（只读）；完整筛选与专业明细请进入控制台</p>
        </div>
        <div class="filter-bar filter-bar--readonly" aria-hidden="true">
          <span class="filter-chip">广东</span>
          <span class="filter-chip">公办优先</span>
          <span class="filter-chip muted">预览前 8 所</span>
          <button type="button" class="btn btn-primary btn-sm" @click="goConsole('school')">
            立即查询
          </button>
        </div>
        <div class="table-wrap" :class="{ 'is-loading': loadingSchools }">
          <table class="data-table data-table--readonly">
            <thead>
              <tr>
                <th>院校名称</th>
                <th>性质</th>
                <th>专业数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in schools" :key="row.id">
                <td>{{ row.name }}</td>
                <td><span :class="chipClass(row)">{{ row.type }}</span></td>
                <td>{{ row.majorCount ?? '—' }}</td>
              </tr>
              <tr v-if="!loadingSchools && schools.length === 0">
                <td colspan="3" class="empty">暂无数据，请确认 school-service 已启动</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- 重点专业：词典真实数据，只展示 -->
    <section class="scroll-section">
      <div class="section-inner">
        <h2 class="section-heading left">重点关注专业</h2>
        <p class="section-note">来自专业词典（计算机类等），仅供预览</p>
        <div class="major-grid">
          <article v-for="m in featuredMajorCards" :key="m.title" class="major-card major-card--readonly">
            <div class="major-top">
              <div class="major-icon-box">
                <StitchIcon :name="m.icon" />
              </div>
              <h3>{{ m.title }}</h3>
            </div>
            <ul class="major-meta">
              <li>
                <span class="label">门类</span>
                <span class="value">{{ m.discipline }}</span>
              </li>
              <li>
                <span class="label">专业类</span>
                <span class="value">{{ m.category }}</span>
              </li>
              <li>
                <span class="label">考试轨道</span>
                <span class="value">{{ m.examTrack }}</span>
              </li>
            </ul>
          </article>
          <p v-if="!featuredMajorCards.length" class="empty-block">暂无专业词典数据</p>
        </div>
        <div class="section-cta">
          <button type="button" class="btn btn-primary" @click="goConsole('school')">去控制台查看招生专业</button>
        </div>
      </div>
    </section>

    <!-- 历年真题预览 -->
    <section id="papers-preview" class="scroll-section muted">
      <div class="section-inner">
        <h2 class="section-heading left">历年真题</h2>
        <p class="section-note">登录后可加载真实试卷列表；此处仅展示，不作答</p>
        <div class="subject-tabs subject-tabs--readonly">
          <span
            v-for="s in ['政治', '大学英语', '高等数学', '计算机基础']"
            :key="s"
            class="pill"
            :class="{ active: activeSubject === s }"
          >
            {{ s }}
          </span>
        </div>
        <div class="paper-list paper-list--readonly">
          <div v-for="p in previewPapers" :key="p.id" class="paper-item">
            <div class="paper-icon">
              <StitchIcon name="paper" />
            </div>
            <div>
              <strong>{{ p.title }}</strong>
              <span>{{ paperMeta(p) }}</span>
            </div>
          </div>
          <div v-if="!previewPapers.length" class="paper-item paper-item--hint">
            <div class="paper-icon">
              <StitchIcon name="paper" />
            </div>
            <div>
              <strong>登录后查看广东真题目录</strong>
              <span>政治 / 英语 / 高数 / 计算机等科目卷面</span>
            </div>
          </div>
        </div>
        <div class="section-cta">
          <button type="button" class="btn btn-primary" @click="goConsole('papers')">进入真题中心</button>
        </div>
      </div>
    </section>

    <!-- 随机刷题预览 -->
    <section id="random-practice" class="scroll-section">
      <div class="section-inner">
        <h2 class="section-heading left">随机刷题</h2>
        <p class="section-note">题面示意，选项不可点选；完整刷题请进入控制台</p>
        <div class="quiz-panel quiz-panel--readonly">
          <div class="quiz-panel__head">
            <p class="quiz-label"><StitchIcon name="spark" /> 随机刷题预览</p>
          </div>
          <h3>以下关于操作系统的描述中，错误的是？</h3>
          <div class="quiz-options">
            <span>A. 操作系统是管理硬件资源的软件</span>
            <span class="selected">B. Linux 是典型的实时操作系统</span>
            <span>C. 进程管理是操作系统的核心功能</span>
            <span>D. Windows 支持多任务处理</span>
          </div>
          <button type="button" class="btn btn-primary" @click="goConsole('random')">去控制台刷题</button>
        </div>
      </div>
    </section>

    <!-- 每日一练预览 -->
    <section id="daily-practice" class="scroll-section muted">
      <div class="section-inner daily-wrap">
        <div class="daily-info">
          <h2>每日一练</h2>
          <p>每天一题打卡，保持题感。进度与连续签到在控制台查看。</p>
          <button type="button" class="btn btn-primary" @click="goConsole('dashboard')">开始今日练习</button>
        </div>
        <div class="daily-quiz daily-quiz--readonly">
          <div class="tags"><span>时态</span><span>固定搭配</span></div>
          <p class="q-stem">By the time he ______ his homework, his mother had already come back.</p>
          <div class="quiz-options compact">
            <span>A. finishes</span>
            <span>B. will finish</span>
            <span class="correct">C. finished ✓</span>
          </div>
          <div class="analysis">
            <strong>名师解析</strong>
            <p>考查过去完成时的对应关系。by the time 引导的时间状语从句通常用一般过去时，配合主句过去完成时。</p>
          </div>
        </div>
      </div>
    </section>

    <footer class="landing-footer">
      <div class="footer-inner">
        <BrandLogo variant="landing" :size="36" />
        <span class="copy">© 2026 升学通. All rights reserved.</span>
        <div class="dev-badges">
          <span><i class="dot" />数据实时同步</span>
          <span><i class="dot" />多端刷题体验</span>
          <span class="live">专升本一站式平台</span>
        </div>
      </div>
    </footer>

    <LoginModal
      :visible="showLoginModal"
      @close="closeLoginModal"
      @success="onLoginSuccess"
    />
  </div>
</template>

<style scoped>
.landing-page {
  background: var(--apple-bg);
  color: var(--apple-text);
  min-height: 100vh;
}

.landing-nav {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgb(255 255 255 / 82%);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid #ededf2;
}

.nav-inner {
  max-width: var(--apple-max);
  margin: 0 auto;
  padding: 0 24px;
  height: 60px;
  display: flex;
  align-items: center;
  gap: 32px;
}

.logo-wrap {
  display: inline-flex;
  align-items: center;
  border: none;
  background: none;
  padding: 0;
  cursor: pointer;
}

.nav-links {
  display: flex;
  gap: 24px;
  flex: 1;
}

.nav-links a {
  font-size: 13px;
  color: var(--apple-text-muted);
  text-decoration: none;
}

.nav-links a:hover {
  color: var(--apple-text);
}

.nav-cta {
  border: none;
  background: none;
  color: var(--apple-blue);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
}

.hero {
  padding: 64px 24px 48px;
  text-align: center;
  background: linear-gradient(180deg, #fff 0%, var(--apple-bg-soft) 100%);
}

.hero-inner {
  max-width: var(--apple-max);
  margin: 0 auto;
}

.hero-title {
  margin: 0 0 12px;
  font-size: clamp(32px, 5vw, 48px);
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.15;
}

.hero-sub {
  margin: 0 auto 28px;
  max-width: 560px;
  color: var(--apple-text-muted);
  font-size: 17px;
  line-height: 1.55;
}

.trust-strip {
  display: flex;
  justify-content: center;
  gap: 32px;
  list-style: none;
  margin: 0 0 40px;
  padding: 0;
}

.trust-strip li {
  text-align: center;
}

.trust-strip strong {
  display: block;
  font-size: 20px;
  font-weight: 700;
  color: var(--apple-blue);
  letter-spacing: -0.02em;
}

.trust-strip span {
  font-size: 12px;
  color: var(--apple-text-muted);
}

.hero-btns {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-bottom: 48px;
}

.btn {
  border-radius: 980px;
  padding: 10px 22px;
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  border: none;
}

.btn-primary {
  background: var(--apple-blue);
  color: #fff;
}

.btn-outline {
  background: #fff;
  color: var(--apple-blue);
  border: 1px solid var(--apple-blue);
}

.hero-visual {
  display: flex;
  justify-content: center;
}

.gradient-card {
  position: relative;
  width: min(760px, 100%);
  min-height: 300px;
  border-radius: var(--apple-radius-lg);
  background: linear-gradient(135deg, #c084fc 0%, #fb7185 42%, #60a5fa 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px 24px;
  box-shadow: var(--apple-shadow);
  overflow: hidden;
}

.gradient-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 30% 20%, rgb(255 255 255 / 35%), transparent 55%);
  pointer-events: none;
}

.stats-float {
  position: relative;
  width: min(480px, 100%);
  background: rgb(255 255 255 / 94%);
  backdrop-filter: blur(12px);
  border-radius: var(--apple-radius-md);
  padding: 22px 24px;
  text-align: left;
  border: 1px solid rgb(255 255 255 / 80%);
  box-shadow: var(--apple-shadow-sm);
}

.stats-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 18px;
}

.stats-badge {
  flex-shrink: 0;
  padding: 4px 10px;
  border-radius: 999px;
  background: var(--apple-blue-soft);
  color: var(--apple-blue);
  font-size: 11px;
  font-weight: 600;
}

.stats-region {
  font-weight: 700;
  font-size: 18px;
  display: block;
}

.stats-year {
  font-size: 13px;
  color: var(--apple-text-muted);
}

.stats-metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.metric {
  padding: 10px 12px;
  border-radius: var(--apple-radius-sm);
  background: rgb(245 245 247 / 80%);
}

.stats-metrics small {
  display: block;
  font-size: 11px;
  color: var(--apple-text-muted);
  margin-bottom: 4px;
}

.stats-metrics strong {
  font-size: 18px;
  font-weight: 700;
}

.features-section {
  padding: 48px 24px 64px;
}

.section-inner {
  max-width: var(--apple-max);
  margin: 0 auto;
}

.section-heading {
  text-align: center;
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 32px;
  letter-spacing: -0.01em;
}

.section-heading.left {
  text-align: left;
  margin-bottom: 8px;
}

.section-note {
  margin: 0 0 20px;
  font-size: 14px;
  color: var(--apple-text-muted);
}

.section-cta {
  margin-top: 20px;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.feature-card {
  background: #fff;
  border: 1px solid var(--apple-border);
  border-radius: var(--apple-radius-lg);
  padding: 24px 22px;
  box-shadow: var(--apple-shadow-sm);
}

.feature-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 14px;
  background: var(--apple-blue-soft);
  color: var(--apple-blue);
}

.feature-icon :deep(svg) {
  width: 22px;
  height: 22px;
}

.feature-card h3 {
  margin: 0 0 8px;
  font-size: 17px;
}

.feature-card p {
  margin: 0;
  font-size: 14px;
  color: var(--apple-text-muted);
}

.scroll-section {
  padding: 56px 24px;
}

.scroll-section.muted {
  background: var(--apple-bg-muted);
}

.section-head h2 {
  margin: 0 0 6px;
  font-size: 24px;
}

.section-head p {
  margin: 0 0 20px;
  color: var(--apple-text-muted);
  font-size: 14px;
}

.filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  margin-bottom: 16px;
}

.filter-chip {
  display: inline-flex;
  align-items: center;
  height: 36px;
  padding: 0 12px;
  border: 1px solid #d2d2d7;
  border-radius: 8px;
  background: #f5f5f7;
  font-size: 14px;
  color: var(--apple-text);
  user-select: none;
}

.filter-chip.muted {
  color: var(--apple-text-muted);
  border-style: dashed;
}

.btn-sm {
  padding: 8px 18px;
  font-size: 14px;
}

.table-wrap {
  background: #fff;
  border-radius: var(--apple-radius-md);
  border: 1px solid #ededf2;
  overflow: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.data-table--readonly tbody tr {
  cursor: default;
}

.data-table th,
.data-table td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #f0f0f5;
}

.data-table th {
  font-size: 12px;
  color: var(--apple-text-muted);
  font-weight: 600;
}

.chip {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.chip--public {
  background: rgb(52 199 89 / 12%);
  color: #1a7f37;
}

.chip--private {
  background: rgb(255 149 0 / 12%);
  color: #9a3412;
}

.empty,
.empty-block {
  text-align: center;
  color: var(--apple-text-muted);
  padding: 24px !important;
}

.major-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.major-card {
  background: #fff;
  border: 1px solid var(--apple-border);
  border-radius: var(--apple-radius-md);
  padding: 22px 20px;
  box-shadow: var(--apple-shadow-sm);
}

.major-card--readonly {
  pointer-events: none;
  user-select: none;
}

.major-top {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  padding-bottom: 14px;
  border-bottom: 1px solid #f0f0f5;
}

.major-icon-box {
  width: 40px;
  height: 40px;
  border-radius: 11px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--apple-blue-soft);
  color: var(--apple-blue);
  flex-shrink: 0;
}

.major-icon-box :deep(svg) {
  width: 20px;
  height: 20px;
}

.major-card h3 {
  margin: 0;
  font-size: 16px;
  line-height: 1.35;
}

.major-meta {
  list-style: none;
  margin: 0;
  padding: 0;
  font-size: 13px;
}

.major-meta li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f7;
}

.major-meta li:last-child {
  border-bottom: none;
}

.major-meta .label {
  color: var(--apple-text-muted);
  flex-shrink: 0;
}

.major-meta .value {
  color: var(--apple-text);
  text-align: right;
  font-weight: 500;
}

.subject-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 20px;
}

.subject-tabs--readonly {
  pointer-events: none;
  user-select: none;
}

.pill {
  border: 1px solid #ededf2;
  background: #fff;
  border-radius: 980px;
  padding: 6px 14px;
  font-size: 13px;
}

.pill.active {
  background: var(--apple-blue);
  color: #fff;
  border-color: var(--apple-blue);
}

.paper-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.paper-list--readonly {
  pointer-events: none;
  user-select: none;
}

.paper-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  background: #fff;
  border: 1px solid var(--apple-border);
  border-radius: var(--apple-radius-md);
  padding: 14px 16px;
}

.paper-item--hint {
  opacity: 0.9;
}

.paper-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--apple-bg-muted);
  color: var(--apple-blue);
  flex-shrink: 0;
}

.paper-icon :deep(svg) {
  width: 18px;
  height: 18px;
}

.paper-item strong {
  display: block;
  font-size: 14px;
  margin-bottom: 4px;
}

.paper-item span {
  font-size: 12px;
  color: var(--apple-text-muted);
}

.quiz-panel,
.daily-quiz {
  background: #fff;
  border: 1px solid var(--apple-border);
  border-radius: var(--apple-radius-md);
  padding: 20px;
  box-shadow: var(--apple-shadow-sm);
}

.quiz-panel--readonly .quiz-options,
.daily-quiz--readonly .quiz-options {
  pointer-events: none;
  user-select: none;
}

.quiz-panel__head {
  margin-bottom: 12px;
}

.quiz-label {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: var(--apple-blue);
  margin: 0 0 8px;
  font-weight: 600;
}

.quiz-label :deep(svg) {
  width: 14px;
  height: 14px;
}

.quiz-panel h3 {
  margin: 0 0 16px;
  font-size: 16px;
  line-height: 1.5;
}

.quiz-options {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 16px;
}

.quiz-options span {
  display: block;
  padding: 10px 12px;
  border: 1px solid #ededf2;
  border-radius: 8px;
  font-size: 14px;
}

.quiz-options span.selected {
  border-color: var(--apple-blue);
  background: rgb(0 113 227 / 6%);
}

.quiz-options span.correct {
  border-color: var(--apple-green);
  background: rgb(52 199 89 / 8%);
}

.daily-wrap {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 24px;
  align-items: start;
}

.daily-info h2 {
  margin: 0 0 8px;
  font-size: 24px;
}

.daily-info p {
  color: var(--apple-text-muted);
  margin: 0 0 20px;
}

.tags {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}

.tags span {
  font-size: 11px;
  padding: 2px 8px;
  background: #f5f5f7;
  border-radius: 4px;
  color: var(--apple-text-muted);
}

.q-stem {
  font-size: 15px;
  line-height: 1.6;
  margin: 0 0 12px;
}

.analysis {
  margin-top: 16px;
  padding: 12px;
  background: #f5f5f7;
  border-radius: 8px;
  font-size: 13px;
}

.analysis p {
  margin: 6px 0 0;
  color: var(--apple-text-muted);
  line-height: 1.6;
}

.landing-footer {
  border-top: 1px solid #ededf2;
  padding: 24px;
  margin-top: 24px;
}

.footer-inner {
  max-width: var(--apple-max);
  margin: 0 auto;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 16px;
  font-size: 12px;
  color: var(--apple-text-muted);
}

.copy {
  flex: 1;
}

.dev-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}

.dev-badges span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--apple-green);
  display: inline-block;
}

.live {
  color: var(--apple-green);
  font-weight: 600;
}

@media (max-width: 900px) {
  .nav-links {
    display: none;
  }

  .trust-strip {
    gap: 20px;
  }

  .features-grid,
  .major-grid,
  .daily-wrap {
    grid-template-columns: 1fr;
  }

  .stats-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
