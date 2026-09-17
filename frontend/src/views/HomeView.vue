<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { fetchMajorOptions, fetchSchoolList } from '../api/school'
import { fetchPaperList } from '../api/papers'
import { useAuthStore } from '../stores/auth'
import { useUiPrefsStore } from '../stores/uiPrefs'
import { useFeatureReveal } from '../composables/useFeatureReveal'
import { useHeroParticles } from '../composables/useHeroParticles'
import { useTypedHeadline } from '../composables/useTypedHeadline'
import LoginModal from '../components/stitch/LoginModal.vue'
import BrandLogo from '../components/stitch/BrandLogo.vue'
import StitchIcon from '../components/stitch/StitchIcon.vue'
import {
  consoleFullPath,
  isDashboardConsoleHref,
  markConsoleDashboardEntry,
  preloadConsole,
  pushConsole,
  pushConsoleHref,
  type ConsoleModule,
} from '../utils/consoleNav'
import type { MajorOptionVO, PaperListItemVO, SchoolVO } from '../types/api'

gsap.registerPlugin(ScrollTrigger)

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const ui = useUiPrefsStore()

const showLoginModal = ref(false)
const loginRedirect = ref(consoleFullPath('dashboard'))

const schools = ref<SchoolVO[]>([])
const loadingSchools = ref(false)
const featuredMajors = ref<MajorOptionVO[]>([])
const previewPapers = ref<PaperListItemVO[]>([])
const activeSubject = ref('计算机基础')

const subjects = ['政治', '大学英语', '高等数学', '计算机基础'] as const
const PAPER_SLOT_COUNT = 3

type PaperSlot =
  | { key: string; kind: 'paper'; paper: PaperListItemVO }
  | { key: string; kind: 'placeholder'; title: string; meta: string; action: 'login' | 'open' | null }

const HERO_TITLE = '查招生 · 对真题 · 刷题巩固'
const BRIDGE_TEXT =
  '升学通是面向专升本考生的招生查询与备考控制台。用真实接口把查招生、对真题与刷题放进同一工作台。'
const typedRoot = ref<HTMLElement | null>(null)
const bridgeTypedRoot = ref<HTMLElement | null>(null)
const particleCanvas = ref<HTMLCanvasElement | null>(null)
const { start: startTyping } = useTypedHeadline({
  root: typedRoot,
  text: HERO_TITLE,
  delay: 0.2,
  stagger: 0.04,
})
const { start: startBridgeTyping } = useTypedHeadline({
  root: bridgeTypedRoot,
  text: BRIDGE_TEXT,
  delay: 0.15,
  stagger: 0.018,
  cursorPersists: true,
})
const { start: startParticles, stop: stopParticles } = useHeroParticles({ canvas: particleCanvas })
const { bind: bindFeatureReveal, refresh: refreshFeatureReveal } = useFeatureReveal()

const bridgeIcons = [
  { id: 'terminal', label: '控制台', d: 'M4 8l4 4-4 4M12 16h8' },
  { id: 'check', label: '核对', d: 'M9 12l2.2 2.2L16 9.5M12 21a9 9 0 100-18 9 9 0 000 18z' },
  { id: 'spark', label: '洞察', d: 'M12 3l1.15 6.85L20 12l-6.85 1.15L12 20l-1.15-6.85L4 12l6.85-1.15L12 3z' },
  { id: 'arrow', label: '推进', d: 'M5 12h12m0 0l-4-4m4 4l-4 4' },
  { id: 'hub', label: '链路', d: 'M12 7v10M7 12h10M8.5 8.5l7 7M15.5 8.5l-7 7' },
  { id: 'grid', label: '矩阵', d: 'M5 5h6v6H5V5zm8 0h6v6h-6V5zM5 13h6v6H5v-6zm8 0h6v6h-6v-6z' },
  { id: 'cmd', label: '命令', d: 'M9 9V7a2 2 0 10-2 2h2zm6 0h2a2 2 0 10-2-2v2zM9 15v2a2 2 0 11-2-2h2zm6 0h2a2 2 0 11-2 2v-2zM9 9h6v6H9V9z' },
  { id: 'cube', label: '模块', d: 'M12 3l8 4.5v9L12 21l-8-4.5v-9L12 3zm0 18V12m8-4.5L12 12 4 7.5' },
  { id: 'enter', label: '回车', d: 'M19 8v5a2 2 0 01-2 2H7m0 0l3-3m-3 3l3 3' },
  { id: 'search', label: '检索', d: 'M11 17a6 6 0 100-12 6 6 0 000 12zm5.5 1.5L20 22' },
  { id: 'star', label: '重点', d: 'M12 3.5l2.1 5.3 5.7.5-4.3 3.7 1.4 5.5L12 15.8l-4.9 2.7 1.4-5.5-4.3-3.7 5.7-.5L12 3.5z' },
  { id: 'folder', label: '资料', d: 'M3 8a2 2 0 012-2h3.5l2 2H19a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V8z' },
  { id: 'refresh', label: '刷新', d: 'M4.5 12a7.5 7.5 0 0112.7-5.4M19.5 12a7.5 7.5 0 01-12.7 5.4M18 4.5V9h-4.5M6 19.5V15H10.5' },
  { id: 'pen', label: '编辑', d: 'M13.5 5.5l5 5L8 21H3v-5L13.5 5.5zm3.2 1.8l-5 5' },
  { id: 'code', label: '结构', d: 'M8 8l-4 4 4 4m8-8l4 4-4 4' },
] as const

const bridgeSection = ref<HTMLElement | null>(null)
const bridgeTrack = ref<HTMLElement | null>(null)
let bridgeObserver: IntersectionObserver | undefined
let bridgeTypedStarted = false
let bridgeParallax: ScrollTrigger | undefined

function bridgeOrbStyle(index: number) {
  const n = bridgeIcons.length
  const t = n <= 1 ? 0.5 : index / (n - 1)
  const lift = Math.sin(Math.PI * t)
  return {
    '--i': String(index),
    marginTop: `calc((1 - ${lift}) * var(--lp-bridge-arc-dip))`,
  }
}

const heroSchools = computed(() => schools.value.slice(0, 6))

const featuredMajorNames = computed(() => featuredMajors.value.slice(0, 5).map((m) => m.name))

const schoolPreviewLabel = computed(() =>
  schools.value.length ? `已加载 ${schools.value.length} 所广东院校` : '等待 school-service',
)

/** 固定 3 槽，避免切换科目时卡片高度跳动 */
const paperSlots = computed(() => {
  const slots: PaperSlot[] = []
  const papers = previewPapers.value
  for (let i = 0; i < PAPER_SLOT_COUNT; i++) {
    const paper = papers[i]
    if (paper) {
      slots.push({ key: `paper-${paper.id}`, kind: 'paper', paper })
      continue
    }
    if (!auth.isLoggedIn) {
      if (i === 0) {
        slots.push({
          key: `ph-login-${activeSubject.value}`,
          kind: 'placeholder',
          title: `${activeSubject.value} · 广东真题目录`,
          meta: '登录后加载年份 / 题量',
          action: 'login',
        })
      } else if (i === 1) {
        slots.push({
          key: 'ph-exam',
          kind: 'placeholder',
          title: '卷面作答与解析',
          meta: '在控制台完成 · 含公式渲染',
          action: null,
        })
      } else {
        slots.push({
          key: 'ph-review',
          kind: 'placeholder',
          title: '答案与错题复盘',
          meta: '登录后在控制台查看',
          action: null,
        })
      }
      continue
    }
    slots.push({
      key: `ph-more-${activeSubject.value}-${i}`,
      kind: 'placeholder',
      title: papers.length ? `${activeSubject.value} · 更多真题` : `${activeSubject.value} · 暂无更多卷面`,
      meta: '完整目录在控制台浏览',
      action: 'open',
    })
  }
  return slots
})

function goConsole(module: ConsoleModule = 'dashboard') {
  void preloadConsole()
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

async function onToggleTheme() {
  try {
    await ui.toggleTheme()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '主题切换失败')
  }
}

watch(
  () => ui.theme,
  async () => {
    await nextTick()
    stopParticles()
    startParticles()
    refreshFeatureReveal()
  },
)

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
      pageSize: 6,
    })
    featuredMajors.value = data.list
    if (featuredMajors.value.length < 3) {
      const more = await fetchMajorOptions({ pageNo: 1, pageSize: 6 })
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
    previewPapers.value = (list || []).slice(0, 3)
  } catch {
    previewPapers.value = []
  }
}

async function selectSubject(subject: (typeof subjects)[number]) {
  if (activeSubject.value === subject) return
  activeSubject.value = subject
  await loadPreviewPapers()
}

function paperMeta(p: PaperListItemVO) {
  const parts = [`${p.year} 年`, p.subject]
  if (p.questionCount) parts.push(`${p.questionCount} 题`)
  return parts.join(' · ')
}

onMounted(async () => {
  openLoginFromQuery()
  const schedule =
    typeof window !== 'undefined' && 'requestIdleCallback' in window
      ? (cb: () => void) => window.requestIdleCallback(cb, { timeout: 2500 })
      : (cb: () => void) => window.setTimeout(cb, 800)
  schedule(() => {
    void preloadConsole()
  })
  await nextTick()
  startTyping()
  startParticles()

  const revealBridge = () => {
    if (bridgeTypedStarted || !bridgeSection.value) return
    bridgeTypedStarted = true
    bridgeSection.value.classList.add('is-in')
    void startBridgeTyping()
    bridgeObserver?.disconnect()
    bridgeObserver = undefined
  }

  if (bridgeSection.value && typeof IntersectionObserver !== 'undefined') {
    bridgeObserver = new IntersectionObserver(
      (entries) => {
        if (entries.some((e) => e.isIntersecting)) revealBridge()
      },
      { threshold: 0.12, rootMargin: '0px 0px -8% 0px' },
    )
    bridgeObserver.observe(bridgeSection.value)
  } else {
    revealBridge()
  }

  if (
    bridgeSection.value &&
    bridgeTrack.value &&
    !window.matchMedia('(prefers-reduced-motion: reduce)').matches
  ) {
    const section = bridgeSection.value
    const track = bridgeTrack.value
    const travel = () => {
      const overflow = Math.max(0, track.scrollWidth - section.clientWidth)
      return Math.max(overflow * 0.72, section.clientWidth * 0.28)
    }
    const applyX = (progress: number) => {
      const max = travel()
      gsap.set(track, { x: gsap.utils.mapRange(0, 1, max * 0.5, -max * 0.5, progress) })
    }
    bridgeParallax = ScrollTrigger.create({
      trigger: section,
      start: 'top bottom',
      end: 'bottom top',
      scrub: 0.55,
      invalidateOnRefresh: true,
      onRefresh: (self) => applyX(self.progress),
      onUpdate: (self) => applyX(self.progress),
    })
  }

  await Promise.all([loadSchools(), loadFeaturedMajors(), loadPreviewPapers()])
  await nextTick()
  await bindFeatureReveal()
  ScrollTrigger.refresh()
})

onUnmounted(() => {
  stopParticles()
  bridgeObserver?.disconnect()
  bridgeObserver = undefined
  bridgeParallax?.kill()
  bridgeParallax = undefined
})
</script>

<template>
  <div class="landing-page">
    <header class="lp-nav">
      <div class="lp-container lp-nav__inner">
        <button type="button" class="lp-nav__brand" @click="router.push('/home')">
          <BrandLogo variant="landing" :size="40" />
        </button>
        <nav class="lp-nav__links" aria-label="页面导航">
          <a class="lp-nav__link" href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
          <a class="lp-nav__link" href="#papers-preview" @click.prevent="scrollTo('papers-preview')">历年真题</a>
          <a class="lp-nav__link" href="#random-practice" @click.prevent="scrollTo('random-practice')">刷题巩固</a>
        </nav>
        <div class="lp-nav__actions">
          <button
            type="button"
            class="lp-theme-btn"
            :aria-label="ui.theme === 'dark' ? ui.tr('topbar.themeToLight') : ui.tr('topbar.themeToDark')"
            :title="ui.theme === 'dark' ? ui.tr('topbar.themeToLight') : ui.tr('topbar.themeToDark')"
            @click="onToggleTheme"
          >
            <StitchIcon :name="ui.theme === 'dark' ? 'sun' : 'moon'" />
          </button>
          <button
            type="button"
            class="lp-btn lp-btn--primary lp-btn--sm"
            @mouseenter="preloadConsole"
            @focus="preloadConsole"
            @click="goConsole()"
          >
            进入控制台
          </button>
        </div>
      </div>
    </header>

    <section class="lp-hero" aria-label="升学通">
      <canvas ref="particleCanvas" class="lp-hero__particles" aria-hidden="true" />
      <div class="lp-hero__stage">
        <h1 class="lp-hero__title">
          <span ref="typedRoot" class="lp-typed" data-typed-root>
            <span class="lp-typed__sr">{{ HERO_TITLE }}</span>
            <span class="lp-typed__cursor" data-typed-cursor aria-hidden="true">
              <span class="lp-typed__cursor-bar" />
            </span>
            <span class="lp-typed__content" data-typed-content aria-hidden="true" />
          </span>
        </h1>
        <p class="lp-hero__tagline">面向专升本考生的招生查询与备考控制台</p>
        <div class="lp-hero__actions">
          <button
            type="button"
            class="lp-btn lp-btn--primary"
            @mouseenter="preloadConsole"
            @click="goConsole()"
          >
            进入控制台
          </button>
          <button type="button" class="lp-btn lp-btn--ghost" @click="scrollTo('school-query')">
            查看招生预览
          </button>
        </div>
      </div>
      <div class="lp-curve lp-curve--hero" aria-hidden="true">
        <svg class="lp-curve__svg" viewBox="0 0 1440 96" preserveAspectRatio="none">
          <path d="M0 0h1440v36C1180 78 900 96 720 96S260 78 0 36V0Z" />
        </svg>
      </div>
    </section>

    <!-- Antigravity 式过渡：弧形图标 + 打字叙事 -->
    <section
      ref="bridgeSection"
      class="lp-bridge"
      aria-label="产品过渡"
    >
      <div class="lp-bridge__arc" aria-hidden="true">
        <div ref="bridgeTrack" class="lp-bridge__track">
          <div
            v-for="(icon, i) in bridgeIcons"
            :key="icon.id"
            class="lp-bridge__orb"
            :style="bridgeOrbStyle(i)"
            :title="icon.label"
          >
            <span class="lp-bridge__orb-float">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                <path :d="icon.d" />
              </svg>
            </span>
          </div>
        </div>
      </div>
      <div class="lp-container lp-bridge__copy">
        <p class="lp-bridge__text">
          <span ref="bridgeTypedRoot" class="lp-typed lp-typed--bridge" data-typed-root>
            <span class="lp-typed__sr">{{ BRIDGE_TEXT }}</span>
            <span class="lp-typed__cursor" data-typed-cursor aria-hidden="true">
              <span class="lp-typed__cursor-bar" />
            </span>
            <span class="lp-typed__content" data-typed-content aria-hidden="true" />
          </span>
        </p>
      </div>
      <div class="lp-curve lp-curve--bridge" aria-hidden="true">
        <svg class="lp-curve__svg" viewBox="0 0 1440 96" preserveAspectRatio="none">
          <path d="M0 0h1440v36C1180 78 900 96 720 96S260 78 0 36V0Z" />
        </svg>
      </div>
    </section>

    <!-- 查招生：双栏 + 虹彩产品卡 -->
    <section id="school-query" class="lp-feature" data-feature-row aria-labelledby="feat-school-title">
      <div class="lp-container lp-feature__grid">
        <div class="lp-feature__copy" data-feature-copy>
          <h2 id="feat-school-title" class="lp-feature__title">招生库，按真实接口展开</h2>
          <p class="lp-feature__desc">
            广东 2026 公办优先预览直接来自 school-service。在控制台按省份、年份与专业继续筛，而不是看静态海报。
          </p>
          <ul class="lp-feature__bullets">
            <li>{{ schoolPreviewLabel }}</li>
            <li>院校性质与专业数随接口返回</li>
            <li>完整筛选与专业明细在控制台</li>
          </ul>
          <div class="lp-feature__actions">
            <button type="button" class="lp-btn lp-btn--primary" @click="goConsole('school')">
              打开招生查询
            </button>
          </div>
          <div v-if="featuredMajorNames.length" class="lp-feature__majors">
            <span
              v-for="name in featuredMajorNames"
              :key="name"
              class="lp-feature__major"
            >{{ name }}</span>
          </div>
        </div>

        <div class="lp-feature__stage" data-feature-stage>
          <div class="lp-glow">
            <div class="lp-glow__inner lp-console" aria-label="招生预览控制台">
              <div class="lp-console__bar">
                <div class="lp-console__bar-left">
                  <div class="lp-console__dots" aria-hidden="true"><span /><span /><span /></div>
                  <span class="lp-console__path">console / admission · 广东 2026</span>
                </div>
                <span class="lp-console__live">
                  <span class="lp-console__live-dot" aria-hidden="true" />
                  {{ loadingSchools ? '加载中' : '招录预览在线' }}
                </span>
              </div>
              <div class="lp-console__workspace">
                <aside class="lp-console__rail" aria-hidden="true">
                  <p class="lp-console__rail-label">模块</p>
                  <div class="lp-console__rail-item lp-console__rail-item--active">招生计划</div>
                  <div class="lp-console__rail-item">历年真题</div>
                  <div class="lp-console__rail-item">每日一练</div>
                  <div class="lp-console__rail-item">随机刷题</div>
                  <div class="lp-console__rail-foot">
                    <div class="lp-console__rail-foot-label">预览</div>
                    <div class="lp-console__rail-foot-main">广东省 · 公办优先</div>
                    <div class="lp-console__rail-foot-sub">只读 · 前 {{ heroSchools.length || 8 }} 所</div>
                  </div>
                </aside>
                <div class="lp-console__main">
                  <div class="lp-console__toolbar">
                    <span class="lp-console__search">搜索院校 / 专业…</span>
                    <span class="lp-console__chip">公办优先</span>
                    <span class="lp-console__chip">2026</span>
                  </div>
                  <table class="lp-console__table">
                    <thead>
                      <tr>
                        <th>院校</th>
                        <th>性质</th>
                        <th>专业</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="row in heroSchools" :key="row.id">
                        <td>
                          <div class="lp-console__school">{{ row.name }}</div>
                          <div class="lp-console__meta">{{ row.city || row.province }}</div>
                        </td>
                        <td><span class="lp-console__tag">{{ row.type || '—' }}</span></td>
                        <td class="lp-console__meta">{{ row.majorCount ?? '—' }}</td>
                      </tr>
                    </tbody>
                  </table>
                  <p v-if="!loadingSchools && !heroSchools.length" class="lp-console__empty">
                    暂无预览数据，请确认 school-service 已启动
                  </p>
                  <div class="lp-console__foot">
                    <span>只读预览</span>
                    <button type="button" class="lp-btn lp-btn--ghost lp-btn--sm" @click="goConsole('school')">
                      完整查询
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 对真题：反转双栏 + 暗底 -->
    <section
      id="papers-preview"
      class="lp-feature lp-feature--invert"
      data-feature-row
      aria-labelledby="feat-paper-title"
    >
      <div class="lp-container lp-feature__grid lp-feature__grid--flip">
        <div class="lp-feature__copy" data-feature-copy>
          <h2 id="feat-paper-title" class="lp-feature__title">真题目录，按科目进入卷面</h2>
          <p class="lp-feature__desc">
            登录后加载广东真题列表；官网只作科目预览与入口，完整作答与解析在控制台完成。
          </p>
          <div class="lp-feature__actions">
            <button type="button" class="lp-btn lp-btn--primary" @click="goConsole('papers')">
              进入真题中心
            </button>
          </div>
        </div>

        <div class="lp-feature__stage" data-feature-stage>
          <div class="lp-glow lp-glow--dark">
            <div class="lp-glow__inner lp-sheet" aria-label="真题科目预览">
              <div class="lp-sheet__bar">
                <span class="lp-sheet__path">papers / 广东</span>
                <span class="lp-sheet__hint">{{ auth.isLoggedIn ? '已登录 · 真实列表' : '未登录 · 科目入口' }}</span>
              </div>
              <div class="lp-sheet__tabs" role="tablist" aria-label="真题科目">
                <button
                  v-for="s in subjects"
                  :key="s"
                  type="button"
                  role="tab"
                  class="lp-sheet__tab"
                  :class="{ 'is-active': activeSubject === s }"
                  :aria-selected="activeSubject === s"
                  @click="selectSubject(s)"
                >
                  {{ s }}
                </button>
              </div>
              <div class="lp-sheet__list">
                <article
                  v-for="slot in paperSlots"
                  :key="slot.key"
                  class="lp-sheet__item"
                  :class="{ 'lp-sheet__item--muted': slot.kind === 'placeholder' && slot.action !== 'login' }"
                >
                  <div class="lp-sheet__item-body">
                    <h3 class="lp-sheet__item-title">
                      {{ slot.kind === 'paper' ? slot.paper.title : slot.title }}
                    </h3>
                    <p class="lp-sheet__item-meta">
                      {{ slot.kind === 'paper' ? paperMeta(slot.paper) : slot.meta }}
                    </p>
                  </div>
                  <button
                    v-if="slot.kind === 'paper'"
                    type="button"
                    class="lp-btn lp-btn--ghost lp-btn--sm"
                    @click="goConsole('papers')"
                  >
                    打开
                  </button>
                  <button
                    v-else-if="slot.action === 'login'"
                    type="button"
                    class="lp-btn lp-btn--primary lp-btn--sm"
                    @click="goConsole('papers')"
                  >
                    登录查看
                  </button>
                  <button
                    v-else-if="slot.action === 'open'"
                    type="button"
                    class="lp-btn lp-btn--ghost lp-btn--sm"
                    @click="goConsole('papers')"
                  >
                    打开
                  </button>
                  <span v-else class="lp-sheet__item-spacer" aria-hidden="true" />
                </article>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 刷题巩固 -->
    <section
      id="random-practice"
      class="lp-feature"
      data-feature-row
      aria-labelledby="feat-practice-title"
    >
      <div class="lp-container lp-feature__grid">
        <div class="lp-feature__copy" data-feature-copy>
          <h2 id="feat-practice-title" class="lp-feature__title">刷题巩固，进度留在控制台</h2>
          <p class="lp-feature__desc">
            每日一练打卡与随机抽题补弱项。官网展示题面形态；真正作答、记录与复盘在控制台。
          </p>
          <div class="lp-feature__actions">
            <button type="button" class="lp-btn lp-btn--primary" @click="goConsole('dashboard')">
              开始今日练习
            </button>
            <button type="button" class="lp-btn lp-btn--ghost" @click="goConsole('random')">
              去随机刷题
            </button>
          </div>
        </div>

        <div class="lp-feature__stage" data-feature-stage>
          <div class="lp-glow">
            <div class="lp-glow__inner lp-quiz" aria-label="随机刷题示意" aria-hidden="true">
              <p class="lp-quiz__label">随机刷题 · 示意不可作答</p>
              <h3 class="lp-quiz__q">以下关于操作系统的描述中，错误的是？</h3>
              <div class="lp-quiz__opts">
                <div class="lp-quiz__opt">A. 操作系统是管理硬件资源的软件</div>
                <div class="lp-quiz__opt lp-quiz__opt--picked">B. Linux 是典型的实时操作系统</div>
                <div class="lp-quiz__opt">C. 进程管理是操作系统的核心功能</div>
                <div class="lp-quiz__opt">D. Windows 支持多任务处理</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <footer class="lp-liftoff">
      <div class="lp-curve lp-curve--liftoff" aria-hidden="true">
        <svg class="lp-curve__svg" viewBox="0 0 1440 96" preserveAspectRatio="none">
          <path d="M0 96h1440V60C1180 18 900 0 720 0S260 18 0 60v36Z" />
        </svg>
      </div>
      <div class="lp-liftoff__main">
        <div class="lp-container lp-liftoff__grid">
          <p class="lp-liftoff__lead">Experience liftoff</p>
          <nav class="lp-liftoff__cols" aria-label="页脚导航">
            <div class="lp-liftoff__col">
              <h2 class="lp-liftoff__col-title">Product</h2>
              <a href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
              <a href="#papers-preview" @click.prevent="scrollTo('papers-preview')">历年真题</a>
              <a href="#random-practice" @click.prevent="scrollTo('random-practice')">刷题巩固</a>
              <button type="button" @mouseenter="preloadConsole" @click="goConsole()">进入控制台</button>
            </div>
            <div class="lp-liftoff__col">
              <h2 class="lp-liftoff__col-title">Resources</h2>
              <button type="button" @click="goConsole('school')">招生库</button>
              <button type="button" @click="goConsole('papers')">真题中心</button>
              <button type="button" @click="goConsole('dashboard')">每日一练</button>
            </div>
          </nav>
        </div>
        <p class="lp-liftoff__wordmark" aria-label="up-learn">up-learn</p>
      </div>
      <div class="lp-liftoff__bar">
        <div class="lp-container lp-liftoff__bar-inner">
          <button type="button" class="lp-liftoff__mark" @click="router.push('/home')">
            up-learn
          </button>
          <nav class="lp-liftoff__legal" aria-label="法律与关于">
            <span>© 2026 升学通</span>
            <a href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
            <a href="#papers-preview" @click.prevent="scrollTo('papers-preview')">历年真题</a>
            <button type="button" @mouseenter="preloadConsole" @click="goConsole()">进入控制台</button>
          </nav>
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
