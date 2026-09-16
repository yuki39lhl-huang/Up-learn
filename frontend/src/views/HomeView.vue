<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchMajorOptions, fetchSchoolList } from '../api/school'
import { fetchPaperList } from '../api/papers'
import { useAuthStore } from '../stores/auth'
import { useUiPrefsStore } from '../stores/uiPrefs'
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

const journey = [
  {
    num: '01',
    title: '查招生',
    text: '按省份与年份筛选院校与专业，对照公办优先与计划名额。',
    anchor: 'school-query',
  },
  {
    num: '02',
    title: '对真题',
    text: '历年卷面按科目归档，登录后可进入真题中心作答与复盘。',
    anchor: 'papers-preview',
  },
  {
    num: '03',
    title: '刷题巩固',
    text: '每日一练打卡，随机刷题补弱项，进度集中在控制台。',
    anchor: 'random-practice',
  },
] as const

const schoolPreviewCount = computed(() =>
  schools.value.length ? String(schools.value.length) : '—',
)

const heroSchools = computed(() => schools.value.slice(0, 5))

const featuredMajorCards = computed(() =>
  featuredMajors.value.map((m) => ({
    title: m.name,
    category: m.majorCategory || m.discipline || '—',
    examTrack: m.examTrack || '—',
    discipline: m.discipline || '—',
  })),
)

let revealObserver: IntersectionObserver | undefined

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
    previewPapers.value = (list || []).slice(0, 2)
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

function bindReveal() {
  const nodes = document.querySelectorAll('.lp-reveal')
  if (!nodes.length) return
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    nodes.forEach((el) => el.classList.add('is-in'))
    return
  }
  const revealNow = (el: Element) => {
    el.classList.add('is-in')
  }
  revealObserver = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          revealNow(entry.target)
          revealObserver?.unobserve(entry.target)
        }
      }
    },
    { rootMargin: '0px 0px -4% 0px', threshold: 0.02 },
  )
  const vh = window.innerHeight || 800
  nodes.forEach((el) => {
    const top = el.getBoundingClientRect().top
    if (top < vh * 0.92) {
      revealNow(el)
      return
    }
    revealObserver?.observe(el)
  })
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
  await Promise.all([loadSchools(), loadFeaturedMajors(), loadPreviewPapers()])
  await nextTick()
  bindReveal()
})

onUnmounted(() => {
  revealObserver?.disconnect()
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
          <a class="lp-nav__link" href="#daily-practice" @click.prevent="scrollTo('daily-practice')">每日一练</a>
          <a class="lp-nav__link" href="#random-practice" @click.prevent="scrollTo('random-practice')">随机刷题</a>
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
      <div class="lp-container lp-hero__grid">
        <div class="lp-hero__copy">
          <div class="lp-hero__brandline">
            <span class="lp-hero__name">升学通</span>
            <span class="lp-hero__divider" aria-hidden="true" />
            <span class="lp-hero__console-label">Academic Utility Console</span>
          </div>
          <h1 class="lp-hero__title">查招生 · 对真题 · 刷题巩固</h1>
          <p class="lp-hero__tagline">面向专升本考生的招生查询与备考控制台</p>
          <p class="lp-hero__lead">
            广东招录预览、历年真题与刷题进度集中在同一工作台。用真实接口推进备考，而不是堆功能清单。
          </p>
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
          <ul class="lp-hero__facts">
            <li>广东专升本招录预览</li>
            <li>当前预览院校 {{ schoolPreviewCount }} 所</li>
            <li>真题与刷题登录后可用</li>
          </ul>
        </div>

        <div class="lp-hero__visual">
          <div class="lp-console" aria-label="招生预览控制台示意">
            <div class="lp-console__bar">
              <div class="lp-console__bar-left">
                <div class="lp-console__dots" aria-hidden="true">
                  <span /><span /><span />
                </div>
                <span class="lp-console__path">console / admission · 广东 2026</span>
              </div>
              <span class="lp-console__live">
                <span class="lp-console__live-dot" aria-hidden="true" />
                招录预览在线
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
                  <div class="lp-console__rail-foot-sub">只读 · 前 8 所</div>
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
    </section>

    <section class="lp-section">
      <div class="lp-container">
        <div class="lp-section__head lp-reveal">
          <h2 class="lp-section__title">一条清晰的备考路径</h2>
          <p class="lp-section__desc">从招生决策到卷面练习，三步进入控制台完成闭环。</p>
        </div>
        <div class="lp-journey lp-reveal-stagger">
          <button
            v-for="step in journey"
            :key="step.num"
            type="button"
            class="lp-step lp-reveal"
            @click="scrollTo(step.anchor)"
          >
            <span class="lp-step__num">{{ step.num }}</span>
            <h3 class="lp-step__title">{{ step.title }}</h3>
            <p class="lp-step__text">{{ step.text }}</p>
          </button>
        </div>
      </div>
    </section>

    <section id="school-query" class="lp-section lp-section--muted">
      <div class="lp-container">
        <div class="lp-section__head lp-reveal">
          <h2 class="lp-section__title">招生库查询</h2>
          <p class="lp-section__desc">广东 2026 在招院校预览（只读）。完整筛选与专业明细请进入控制台。</p>
        </div>
        <div class="lp-filters lp-reveal">
          <span class="lp-chip">广东</span>
          <span class="lp-chip">公办优先</span>
          <span class="lp-chip">预览前 8 所</span>
          <button type="button" class="lp-btn lp-btn--primary lp-btn--sm" @click="goConsole('school')">
            立即查询
          </button>
        </div>
        <div class="lp-table-wrap lp-reveal">
          <table class="lp-table">
            <thead>
              <tr>
                <th>院校名称</th>
                <th>性质</th>
                <th>专业数</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in schools" :key="row.id">
                <td>
                  <div class="lp-table__name">{{ row.name }}</div>
                  <div class="lp-table__muted">{{ row.city || row.province }}</div>
                </td>
                <td>{{ row.type }}</td>
                <td>{{ row.majorCount ?? '—' }}</td>
                <td>
                  <button
                    type="button"
                    class="lp-table__link"
                    :aria-label="`查看 ${row.name}`"
                    @click="goConsole('school')"
                  >
                    查看
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
          <p v-if="loadingSchools" class="lp-empty">加载中…</p>
          <p v-else-if="!schools.length" class="lp-empty">暂无数据，请确认 school-service 已启动</p>
        </div>
      </div>
    </section>

    <section class="lp-section">
      <div class="lp-container">
        <div class="lp-section__head lp-reveal">
          <h2 class="lp-section__title">重点关注专业</h2>
          <p class="lp-section__desc">来自专业词典预览，完整招生专业请在控制台查询。</p>
        </div>
        <div class="lp-major-grid lp-reveal-stagger">
          <a
            v-for="m in featuredMajorCards"
            :key="m.title"
            class="lp-major lp-reveal"
            href="#school-query"
            @click.prevent="goConsole('school')"
          >
            <span class="lp-major__name">{{ m.title }}</span>
            <span class="lp-major__meta">{{ m.discipline }} · {{ m.category }}</span>
            <span class="lp-major__meta">考试轨道 {{ m.examTrack }}</span>
          </a>
        </div>
        <p v-if="!featuredMajorCards.length" class="lp-empty lp-reveal">暂无专业词典数据</p>
        <div class="lp-section__actions lp-reveal">
          <button type="button" class="lp-btn lp-btn--primary" @click="goConsole('school')">
            去控制台查看招生专业
          </button>
        </div>
      </div>
    </section>

    <section id="papers-preview" class="lp-section lp-section--muted">
      <div class="lp-container">
        <div class="lp-section__head">
          <h2 class="lp-section__title">历年真题</h2>
          <p class="lp-section__desc">登录后可加载真实试卷列表；未登录时展示科目目录入口，不作答。</p>
        </div>
        <div class="lp-filters" role="tablist" aria-label="真题科目">
          <button
            v-for="s in subjects"
            :key="s"
            type="button"
            role="tab"
            class="lp-chip lp-chip--btn"
            :class="{ 'lp-chip--active': activeSubject === s }"
            :aria-selected="activeSubject === s"
            @click="selectSubject(s)"
          >
            {{ s }}
          </button>
        </div>
        <div class="lp-paper-list">
          <article v-for="p in previewPapers" :key="p.id" class="lp-paper">
            <div>
              <h3 class="lp-paper__title">{{ p.title }}</h3>
              <p class="lp-paper__meta">{{ paperMeta(p) }}</p>
            </div>
            <div class="lp-paper__actions">
              <button type="button" class="lp-btn lp-btn--ghost lp-btn--sm" @click="goConsole('papers')">
                进入真题
              </button>
            </div>
          </article>
          <template v-if="!previewPapers.length">
            <article class="lp-paper">
              <div>
                <h3 class="lp-paper__title">{{ activeSubject }} · 广东真题目录</h3>
                <p class="lp-paper__meta">登录后加载真实卷面列表（年份 / 题量随服务返回）</p>
              </div>
              <div class="lp-paper__actions">
                <button type="button" class="lp-btn lp-btn--primary lp-btn--sm" @click="goConsole('papers')">
                  进入真题中心
                </button>
              </div>
            </article>
            <article class="lp-paper lp-paper--muted">
              <div>
                <h3 class="lp-paper__title">{{ activeSubject }} · 近年卷面预览</h3>
                <p class="lp-paper__meta">示意入口 · 完整作答与解析在控制台</p>
              </div>
              <div class="lp-paper__actions">
                <button type="button" class="lp-btn lp-btn--ghost lp-btn--sm" @click="goConsole('papers')">
                  去控制台
                </button>
              </div>
            </article>
          </template>
          <div v-else class="lp-paper-more">
            <p class="lp-paper-more__text">官网仅预览 2 套 · 完整目录在真题中心</p>
            <button type="button" class="lp-btn lp-btn--primary lp-btn--sm" @click="goConsole('papers')">
              查看全部真题
            </button>
          </div>
        </div>
      </div>
    </section>

    <section id="random-practice" class="lp-section">
      <div class="lp-container">
        <div class="lp-section__head">
          <h2 class="lp-section__title">刷题巩固</h2>
          <p class="lp-section__desc">题面示意不可作答；每日一练与随机刷题在控制台完成。</p>
        </div>
        <div id="daily-practice" class="lp-practice">
          <div class="lp-practice__panel">
            <p class="lp-practice__label">随机刷题预览</p>
            <h3 class="lp-practice__q">以下关于操作系统的描述中，错误的是？</h3>
            <div class="lp-practice__opts" aria-hidden="true">
              <div class="lp-practice__opt">A. 操作系统是管理硬件资源的软件</div>
              <div class="lp-practice__opt lp-practice__opt--picked">B. Linux 是典型的实时操作系统</div>
              <div class="lp-practice__opt">C. 进程管理是操作系统的核心功能</div>
              <div class="lp-practice__opt">D. Windows 支持多任务处理</div>
            </div>
          </div>
          <div class="lp-practice__side">
            <div class="lp-practice__card">
              <h3>每日一练</h3>
              <p>每天一题打卡，保持题感。进度与连续签到在控制台查看。</p>
              <button type="button" class="lp-btn lp-btn--primary lp-btn--sm" @click="goConsole('dashboard')">
                开始今日练习
              </button>
            </div>
            <div class="lp-practice__card">
              <h3>随机刷题</h3>
              <p>按科目抽题补弱项，完整作答与解析请进入控制台。</p>
              <button type="button" class="lp-btn lp-btn--ghost lp-btn--sm" @click="goConsole('random')">
                去控制台刷题
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <footer class="lp-footer">
      <div class="lp-container lp-footer__inner">
        <button type="button" class="lp-footer__brand" @click="router.push('/home')">
          <BrandLogo variant="landing" :size="36" />
        </button>
        <p class="lp-footer__meta">© 2026 升学通 · 招生与真题数据随服务更新</p>
        <nav class="lp-footer__links" aria-label="页脚">
          <a href="#school-query" @click.prevent="scrollTo('school-query')">招生查询</a>
          <a href="#papers-preview" @click.prevent="scrollTo('papers-preview')">历年真题</a>
          <button type="button" @mouseenter="preloadConsole" @click="goConsole()">进入控制台</button>
        </nav>
      </div>
    </footer>

    <LoginModal
      :visible="showLoginModal"
      @close="closeLoginModal"
      @success="onLoginSuccess"
    />
  </div>
</template>
