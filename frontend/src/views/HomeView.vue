<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { fetchSchoolList } from '../api/school'
import { useAuthStore } from '../stores/auth'
import LoginModal from '../components/stitch/LoginModal.vue'
import BrandLogo from '../components/stitch/BrandLogo.vue'
import StitchIcon from '../components/stitch/StitchIcon.vue'
import type { SchoolVO } from '../types/api'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const showLoginModal = ref(false)
const loginRedirect = ref('/console#dashboard')

const schools = ref<SchoolVO[]>([])
const loadingSchools = ref(false)
const province = ref('广东')
const preferPublic = ref(true)
const activeSubject = ref('计算机基础')

const majorCards = [
  {
    title: '软件工程',
    icon: 'code' as const,
    exam: '政治 + 大学英语 + 高等数学 + 计算机基础',
    minScore: 360,
    enrollment: 280,
    tuition: '¥5,500/年起',
  },
  {
    title: '计算机科学与技术',
    icon: 'cpu' as const,
    exam: '政治 + 大学英语 + 高等数学 + 计算机基础',
    minScore: 380,
    enrollment: 200,
    tuition: '¥5,500/年起',
  },
  {
    title: '计算机基础',
    icon: 'layers' as const,
    exam: '政治 + 大学英语 + 高等数学 + 计算机基础',
    minScore: 340,
    enrollment: 150,
    tuition: '¥5,000/年起',
  },
]

const features = [
  {
    icon: 'filter' as const,
    title: '精准筛选',
    desc: '按省份、年份、专业大类多维筛选，快速定位目标院校。',
  },
  {
    icon: 'school' as const,
    title: '权威分类',
    desc: '公办、民办、独立学院标签清晰，学费信息一目了然。',
  },
  {
    icon: 'trend' as const,
    title: '分数趋势',
    desc: '历年最低投档线图表化展示，辅助报考决策。',
  },
  {
    icon: 'practice' as const,
    title: '沉浸练习',
    desc: '海量真题与模拟卷，AI 智能批改与解析推荐。',
  },
]

const trustItems = [
  { value: '24+', label: '套历年真题' },
  { value: '15', label: '省招生数据' },
  { value: 'AI', label: '智能批改' },
]

const papers = [
  { title: '2024 计算机基础全真真题', meta: '耗时 120min · 难度中等', locked: false },
  { title: '2023 高等数学（专升本）', meta: '已作答 · 得分 132', locked: true },
]

const subjects = ['政治', '大学英语', '高等数学', '计算机基础']

function goConsole(hash?: string) {
  const target = hash ? `/console${hash}` : '/console#dashboard'
  if (!auth.isLoggedIn) {
    loginRedirect.value = target
    showLoginModal.value = true
    return
  }
  router.push(target)
}

function closeLoginModal() {
  showLoginModal.value = false
}

function onLoginSuccess() {
  showLoginModal.value = false
  router.push(loginRedirect.value)
}

function openLoginFromQuery() {
  if (route.query.login !== '1') return
  const redirect = route.query.redirect
  loginRedirect.value = typeof redirect === 'string' ? redirect : '/console#dashboard'
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
      pageSize: 5,
      province: province.value,
      preferPublic: preferPublic.value || undefined,
    })
    schools.value = data.list
  } catch {
    schools.value = []
  } finally {
    loadingSchools.value = false
  }
}

function chipClass(row: SchoolVO) {
  return row.type === '公办' ? 'chip chip--public' : 'chip chip--private'
}

onMounted(() => {
  loadSchools()
  openLoginFromQuery()
})
</script>

<template>
  <div class="landing-page">
    <!-- 图一：Apple-like 顶栏 -->
    <header class="landing-nav">
      <div class="nav-inner">
        <button type="button" class="logo-wrap" @click="router.push('/home')">
          <BrandLogo variant="landing" :size="22" />
        </button>
        <nav class="nav-links">
          <a href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
          <a href="#school-query" @click.prevent="scrollTo('school-query')">分数线</a>
          <a href="#practice-center" @click.prevent="scrollTo('practice-center')">历年试卷</a>
          <a href="#daily-practice" @click.prevent="scrollTo('daily-practice')">每日一练</a>
          <a href="#daily-practice" @click.prevent="scrollTo('daily-practice')">学习分析</a>
        </nav>
        <button class="nav-cta" @click="goConsole()">进入控制台 →</button>
      </div>
    </header>

    <!-- 图一：Hero -->
    <section class="hero">
      <div class="hero-inner">
        <h1 class="hero-title">查院校，刷真题，一站完成。</h1>
        <p class="hero-sub">面向专升本备考的招生数据与在线练习平台，让升学之路更有确定性。</p>
        <div class="hero-btns">
          <button class="btn btn-primary" @click="goConsole('#school')">开始查询</button>
          <button class="btn btn-outline" @click="goConsole('#practice')">体验刷题</button>
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
                  <span class="stats-year">2025 年数据</span>
                </div>
                <span class="stats-badge">志愿填报参考</span>
              </div>
              <div class="stats-metrics">
                <div class="metric">
                  <small>公办院校录取率</small>
                  <strong>28.5%</strong>
                </div>
                <div class="metric">
                  <small>平均分数线</small>
                  <strong>186<em>分</em></strong>
                </div>
                <div class="metric">
                  <small>总招生人数</small>
                  <strong>8.4<em>万</em></strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 图一：四宫格特性（2×2） -->
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

    <!-- 图二向下：招生库查询 -->
    <section id="school-query" class="scroll-section muted">
      <div class="section-inner">
        <div class="section-head">
          <h2>招生库查询</h2>
          <p>实时同步最新广东省招生计划</p>
        </div>
        <div class="filter-bar">
          <select v-model="province" class="native-select" @change="loadSchools">
            <option value="广东">广东</option>
          </select>
          <select class="native-select" disabled>
            <option>全部专业</option>
          </select>
          <label class="native-check">
            <input v-model="preferPublic" type="checkbox" @change="loadSchools" />
            公办优先
          </label>
          <button class="btn btn-primary btn-sm" :disabled="loadingSchools" @click="loadSchools">
            {{ loadingSchools ? '查询中…' : '立即查询' }}
          </button>
        </div>
        <div class="table-wrap">
          <table class="data-table">
            <thead>
              <tr>
                <th>院校名称</th>
                <th>性质</th>
                <th>专业数</th>
                <th>最低分</th>
                <th>计划人数</th>
                <th>学费</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in schools" :key="row.id">
                <td>{{ row.name }}</td>
                <td><span :class="chipClass(row)">{{ row.type }}</span></td>
                <td>{{ row.majorCount ?? '—' }}</td>
                <td>{{ row.minScore ?? '—' }}</td>
                <td>{{ row.enrollment ?? '—' }}</td>
                <td>{{ row.tuition ? `¥${row.tuition}` : '—' }}</td>
              </tr>
              <tr v-if="!loadingSchools && schools.length === 0">
                <td colspan="6" class="empty">暂无数据，请确认 school-service 已启动</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- 图二：重点关注专业 -->
    <section class="scroll-section">
      <div class="section-inner">
        <h2 class="section-heading left">重点关注专业</h2>
        <div class="major-grid">
          <article v-for="m in majorCards" :key="m.title" class="major-card">
            <div class="major-top">
              <div class="major-icon-box">
                <StitchIcon :name="m.icon" />
              </div>
              <h3>{{ m.title }}</h3>
            </div>
            <ul class="major-meta">
              <li class="major-meta__stack">
                <span class="label">考试科目</span>
                <p class="value">{{ m.exam }}</p>
              </li>
              <li>
                <span class="label">最低录取分</span>
                <span class="value value--accent">{{ m.minScore }}</span>
              </li>
              <li>
                <span class="label">招生总数</span>
                <span class="value">{{ m.enrollment }} 人</span>
              </li>
              <li>
                <span class="label">学费基数</span>
                <span class="value">{{ m.tuition }}</span>
              </li>
            </ul>
          </article>
        </div>
      </div>
    </section>

    <!-- 图二：在线刷题中心 -->
    <section id="practice-center" class="scroll-section muted">
      <div class="section-inner">
        <h2 class="section-heading left">在线刷题中心</h2>
        <div class="subject-tabs">
          <button
            v-for="s in subjects"
            :key="s"
            type="button"
            class="pill"
            :class="{ active: activeSubject === s }"
            @click="activeSubject = s"
          >
            {{ s }}
          </button>
        </div>
        <div class="practice-split">
          <div class="paper-list">
            <div
              v-for="p in papers"
              :key="p.title"
              class="paper-item"
              :class="{ locked: p.locked }"
            >
              <div class="paper-icon">
                <StitchIcon name="paper" />
              </div>
              <div>
                <strong>{{ p.title }}</strong>
                <span>{{ p.meta }}</span>
              </div>
            </div>
          </div>
          <div class="quiz-panel">
            <div class="quiz-panel__head">
              <p class="quiz-label"><StitchIcon name="spark" /> Q12 / 150 · AI 实时评分</p>
              <div class="progress-bar"><i style="width: 8%" /></div>
            </div>
            <h3>以下关于操作系统的描述中，错误的是？</h3>
            <div class="quiz-options">
              <label>A. 操作系统是管理硬件资源的软件</label>
              <label class="selected">B. Linux 是典型的实时操作系统</label>
              <label>C. 进程管理是操作系统的核心功能</label>
              <label>D. Windows 支持多任务处理</label>
            </div>
            <button class="btn btn-primary" @click="goConsole('#practice')">提交并解析</button>
          </div>
        </div>
      </div>
    </section>

    <!-- 图二：每日一练 -->
    <section id="daily-practice" class="scroll-section">
      <div class="section-inner daily-wrap">
        <div class="daily-info">
          <h2>每日一练</h2>
          <p>每天 10 道题，保持题感，离本科更近一步。</p>
          <div class="daily-stats">
            <div><small>今日进度</small><strong>7 / 10</strong></div>
            <div><small>准确率</small><strong>92%</strong></div>
            <div><small>连续打卡</small><strong><span class="streak-val"><StitchIcon name="flame" />14 天</span></strong></div>
          </div>
          <button class="btn btn-primary" @click="goConsole('#practice')">开始今日练习</button>
        </div>
        <div class="daily-quiz">
          <div class="tags"><span>时态</span><span>固定搭配</span></div>
          <p class="q-stem">By the time he ______ his homework, his mother had already come back.</p>
          <div class="quiz-options compact">
            <label>A. finishes</label>
            <label>B. will finish</label>
            <label class="correct">C. finished ✓</label>
          </div>
          <div class="analysis">
            <strong>名师解析</strong>
            <p>考查过去完成时的对应关系。by the time 引导的时间状语从句通常用一般过去时，配合主句过去完成时。</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 图一 Footer -->
    <footer class="landing-footer">
      <div class="footer-inner">
        <BrandLogo variant="landing" :size="20" />
        <span class="copy">© 2024 升学通. All rights reserved.</span>
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
  height: 52px;
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
  font-size: 22px;
  font-weight: 700;
}

.stats-metrics em {
  font-style: normal;
  font-size: 14px;
  font-weight: 500;
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
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.feature-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--apple-shadow);
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

.native-select {
  height: 36px;
  padding: 0 12px;
  border: 1px solid #d2d2d7;
  border-radius: 8px;
  background: #fff;
  font-size: 14px;
  color: var(--apple-text);
}

.native-check {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: var(--apple-text-muted);
  cursor: pointer;
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

.data-table tbody tr:hover {
  background: rgb(0 113 227 / 3%);
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

.empty {
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
  transition: box-shadow 0.2s ease;
}

.major-card:hover {
  box-shadow: var(--apple-shadow);
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

.major-meta__stack {
  flex-direction: column;
  align-items: stretch !important;
  gap: 6px !important;
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

.major-meta__stack .value {
  text-align: left;
  line-height: 1.55;
  margin: 0;
  font-weight: 400;
}

.value--accent {
  color: var(--apple-blue) !important;
  font-weight: 700 !important;
  font-size: 15px;
}

.subject-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 20px;
}

.pill {
  border: 1px solid #ededf2;
  background: #fff;
  border-radius: 980px;
  padding: 6px 14px;
  font-size: 13px;
  cursor: pointer;
}

.pill.active {
  background: var(--apple-blue);
  color: #fff;
  border-color: var(--apple-blue);
}

.practice-split {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 16px;
}

.paper-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
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

.progress-bar {
  height: 4px;
  border-radius: 999px;
  background: #ececf1;
  overflow: hidden;
}

.progress-bar i {
  display: block;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, var(--apple-blue), #5ac8fa);
}

.streak-val {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.streak-val :deep(svg) {
  width: 16px;
  height: 16px;
  color: #ff9500;
}

.daily-stats strong {
  font-size: 20px;
}

.paper-item.locked {
  opacity: 0.65;
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

.quiz-options label {
  padding: 10px 12px;
  border: 1px solid #ededf2;
  border-radius: 8px;
  font-size: 14px;
}

.quiz-options label.selected {
  border-color: var(--apple-blue);
  background: rgb(0 113 227 / 6%);
}

.quiz-options label.correct {
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

.daily-stats {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
}

.daily-stats small {
  display: block;
  font-size: 12px;
  color: var(--apple-text-muted);
}

.daily-stats strong {
  font-size: 20px;
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
  .practice-split,
  .daily-wrap {
    grid-template-columns: 1fr;
  }

  .stats-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
