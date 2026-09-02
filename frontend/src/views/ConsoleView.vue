<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import SchoolQueryPanel from '../components/stitch/SchoolQueryPanel.vue'
import DashboardPanel from '../components/stitch/DashboardPanel.vue'
import PracticePanel from '../components/stitch/PracticePanel.vue'
import AgentChatPanel from '../components/stitch/AgentChatPanel.vue'
import AccountSettingsPanel from '../components/stitch/AccountSettingsPanel.vue'
import BrandLogo from '../components/stitch/BrandLogo.vue'
import StitchIcon from '../components/stitch/StitchIcon.vue'
import { useAuthStore } from '../stores/auth'
import { useExamPrefsStore } from '../stores/examPrefs'
import { logout } from '../api/user'
import { consumeConsoleDashboardEntry, consoleLocation, pushConsole } from '../utils/consoleNav'
import '../styles/console-workbench.css'

type ModuleKey = 'dashboard' | 'school' | 'syllabus' | 'random' | 'papers' | 'community' | 'agent'
type SystemKey = 'ui-settings' | 'notifications' | 'account'
type ViewKey = ModuleKey | SystemKey

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const examPrefs = useExamPrefsStore()

const SIDEBAR_COLLAPSED_KEY = 'ul_console_sidebar_collapsed'
const sidebarCollapsed = ref(localStorage.getItem(SIDEBAR_COLLAPSED_KEY) === '1')

function toggleSidebar() {
  sidebarCollapsed.value = !sidebarCollapsed.value
  localStorage.setItem(SIDEBAR_COLLAPSED_KEY, sidebarCollapsed.value ? '1' : '0')
}

const uiSettingsTab = ref('appearance')

const navItems: {
  key: ModuleKey
  label: string
  icon: 'home' | 'school' | 'syllabus' | 'practice' | 'paper' | 'community' | 'agent'
}[] = [
  { key: 'dashboard', label: '主页', icon: 'home' },
  { key: 'school', label: '院校查询', icon: 'school' },
  { key: 'syllabus', label: '考纲查询', icon: 'syllabus' },
  { key: 'random', label: '随机刷题', icon: 'practice' },
  { key: 'papers', label: '历年真题', icon: 'paper' },
  { key: 'community', label: '社区', icon: 'community' },
  { key: 'agent', label: '一点通', icon: 'agent' },
]

const uiSettingsNav = [
  { key: 'appearance', label: '外观' },
  { key: 'layout', label: '布局' },
  { key: 'locale', label: '语言与地区' },
]

const mockNotifications = [
  { id: 1, title: '每日一练提醒', desc: '今天还有 1 道题未完成', time: '2 小时前', unread: true },
  { id: 2, title: '院校数据更新', desc: '广东省 2025 招生计划已同步', time: '昨天', unread: false },
]

function hashToView(hash: string): ViewKey {
  const h = hash.replace('#', '')
  if (h === 'daily' || h === 'home' || h === '' || h === 'dashboard') return 'dashboard'
  if (h === 'school') return 'school'
  if (h === 'syllabus') return 'syllabus'
  if (h === 'practice' || h === 'random') return 'random'
  if (h === 'papers') return 'papers'
  if (h === 'community') return 'community'
  if (h === 'agent') return 'agent'
  if (h === 'ui-settings' || h === 'settings') return 'ui-settings'
  if (h === 'notifications') return 'notifications'
  if (h === 'account') return 'account'
  return 'dashboard'
}

const activeView = ref<ViewKey>('dashboard')

const pageTitle = computed(() => {
  const map: Record<ViewKey, string> = {
    dashboard: '主页',
    school: '院校查询',
    syllabus: '考纲查询',
    random: '随机刷题',
    papers: '历年真题',
    community: '社区',
    agent: '一点通',
    'ui-settings': '界面设置',
    notifications: '通知',
    account: '账号',
  }
  return map[activeView.value]
})

function viewHash(key: ViewKey) {
  if (key === 'random') return '#practice'
  return `#${key}`
}

function selectModule(key: ModuleKey) {
  activeView.value = key
  pushConsole(router, key)
}

function selectSystem(key: SystemKey) {
  activeView.value = key
  router.replace({ path: '/console', hash: viewHash(key) })
}

const seasonMeta = computed(() => {
  const year = new Date().getFullYear()
  const province = examPrefs.prefs.province.trim()
  return province ? `${year} 招考季 · ${province}` : `${year} 招考季 · 待选省份`
})

function syncFromRoute() {
  if (consumeConsoleDashboardEntry()) {
    activeView.value = 'dashboard'
    router.replace(consoleLocation('dashboard'))
    return
  }
  const hash = route.hash
  if (!hash || hash === '#') {
    activeView.value = 'dashboard'
    router.replace(consoleLocation('dashboard'))
    return
  }
  activeView.value = hashToView(hash)
}

watch(
  () => route.fullPath,
  () => syncFromRoute(),
  { immediate: true },
)

async function handleLogout() {
  try {
    if (auth.refreshToken) await logout(auth.refreshToken)
  } catch {
    /* ignore */
  } finally {
    auth.clearSession()
    ElMessage.success('已退出')
    router.push('/home')
  }
}
</script>

<template>
  <div class="gmail-shell">
    <!-- 顶层：汉堡 + Logo + 通知/用户（Gmail 同层） -->
    <header class="gmail-topbar">
      <button type="button" class="gmail-menu-btn" aria-label="展开或收起侧边栏" @click="toggleSidebar">
        <StitchIcon name="menu" />
      </button>
      <button type="button" class="gmail-logo" @click="router.push('/home')">
        <BrandLogo />
      </button>
      <div class="gmail-topbar__spacer" />
      <span class="gmail-topbar__meta">{{ seasonMeta }}</span>
      <div class="gmail-topbar__actions">
        <button
          type="button"
          class="gmail-icon-btn"
          :class="{ 'gmail-icon-btn--active': activeView === 'notifications' }"
          aria-label="通知"
          title="通知"
          @click="selectSystem('notifications')"
        >
          <StitchIcon name="bell" />
        </button>
        <button
          type="button"
          class="gmail-avatar-btn"
          :class="{ 'gmail-avatar-btn--active': activeView === 'account' }"
          aria-label="账号"
          title="账号"
          @click="selectSystem('account')"
        >
          <el-avatar :size="32" :src="auth.user?.avatarUrl">
            {{ auth.user?.nickname?.slice(0, 1) ?? 'U' }}
          </el-avatar>
        </button>
      </div>
    </header>

    <div class="gmail-frame">
      <!-- 底层：可收缩侧栏 -->
      <aside
        class="gmail-sidebar"
        :class="{ 'gmail-sidebar--collapsed': sidebarCollapsed }"
        aria-label="主导航"
      >
        <nav class="gmail-nav">
          <button
            v-for="item in navItems"
            :key="item.key"
            type="button"
            class="gmail-nav__item"
            :class="{ 'gmail-nav__item--active': activeView === item.key }"
            :title="sidebarCollapsed ? item.label : undefined"
            @click="selectModule(item.key)"
          >
            <StitchIcon :name="item.icon" />
            <span class="gmail-nav__label">{{ item.label }}</span>
          </button>
        </nav>

        <div class="gmail-sidebar__foot">
          <button
            type="button"
            class="gmail-nav__item"
            :class="{ 'gmail-nav__item--active': activeView === 'ui-settings' }"
            title="界面设置"
            @click="selectSystem('ui-settings')"
          >
            <StitchIcon name="settings" />
            <span class="gmail-nav__label">界面设置</span>
          </button>
          <div class="gmail-api">
            <i class="gmail-api__dot" />
            <span>API Online</span>
          </div>
        </div>
      </aside>

      <!-- 上层：白色浮动主面板 -->
      <div class="gmail-panel-host">
        <section class="gmail-panel" aria-label="主内容">
          <header class="gmail-panel__bar">
            <h1>{{ pageTitle }}</h1>
          </header>

          <div class="gmail-panel__body">
            <!-- 界面设置 -->
            <div v-if="activeView === 'ui-settings'" class="gmail-panel__split">
              <nav class="gmail-panel__aside" aria-label="设置分类">
                <p class="gmail-panel__aside-title">设置</p>
                <button
                  v-for="item in uiSettingsNav"
                  :key="item.key"
                  type="button"
                  class="gmail-panel__link"
                  :class="{ 'gmail-panel__link--active': uiSettingsTab === item.key }"
                  @click="uiSettingsTab = item.key"
                >
                  {{ item.label }}
                </button>
              </nav>
              <div class="gmail-panel__content">
                <div class="gmail-panel__empty">
                  <StitchIcon name="settings" />
                  <h2>{{ uiSettingsNav.find((i) => i.key === uiSettingsTab)?.label }}</h2>
                  <p>界面设置内容预留，后续可配置主题、侧栏默认状态、默认省份等。</p>
                </div>
              </div>
            </div>

            <!-- 通知 -->
            <div v-else-if="activeView === 'notifications'" class="gmail-panel__content gmail-panel__content--flush">
              <div class="notify-toolbar">
                {{ mockNotifications.filter((n) => n.unread).length }} 条未读
              </div>
              <ul class="notify-list">
                <li
                  v-for="n in mockNotifications"
                  :key="n.id"
                  class="notify-item"
                  :class="{ 'notify-item--unread': n.unread }"
                >
                  <div class="notify-item__dot" />
                  <div class="notify-item__body">
                    <strong>{{ n.title }}</strong>
                    <p>{{ n.desc }}</p>
                    <small>{{ n.time }}</small>
                  </div>
                </li>
              </ul>
            </div>

            <!-- 账号 -->
            <AccountSettingsPanel v-else-if="activeView === 'account'" @logout="handleLogout" />

            <!-- 业务模块：v-show 保留各面板状态，避免切回主页丢失每日一练作答/解析 -->
            <div v-else class="gmail-panel__content gmail-panel__content--flush">
              <DashboardPanel v-show="activeView === 'dashboard'" />

              <div v-show="activeView === 'school'" style="padding: 16px">
                <SchoolQueryPanel />
              </div>

              <section
                v-show="activeView === 'syllabus'"
                class="st-card"
                style="margin: 16px"
              >
                <header class="st-card-header">考纲查询</header>
                <div class="st-card-body" />
              </section>

              <div v-show="activeView === 'random'" style="padding: 16px">
                <PracticePanel key="random" default-mode="random" />
              </div>

              <section
                v-show="activeView === 'papers'"
                class="st-card"
                style="margin: 16px"
              >
                <header class="st-card-header">历年试卷与在线作答</header>
                <div class="st-card-body workbench-placeholder">
                  <StitchIcon name="paper" />
                  <h3>历年真题 · 即将上线</h3>
                  <p>按科目筛选试卷、在线作答与 AI 判分，二期开发。</p>
                </div>
              </section>

              <section
                v-show="activeView === 'community'"
                class="st-card"
                style="margin: 16px"
              >
                <header class="st-card-header">升学社区</header>
                <div class="st-card-body workbench-placeholder">
                  <StitchIcon name="community" />
                  <h3>社区交流 · 规划中</h3>
                  <p>院校经验分享、备考答疑，后续版本开放。</p>
                </div>
              </section>

              <AgentChatPanel v-show="activeView === 'agent'" />
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<style scoped>
.account-head {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}

.gmail-panel__empty--left {
  align-items: flex-start;
  text-align: left;
  min-height: 120px;
}

.account-head h2 {
  margin: 0 0 4px;
  font-size: 20px;
}

.account-head p {
  margin: 0;
  font-size: 14px;
  color: var(--st-on-surface-variant);
}

.account-dl {
  margin: 0;
}

.account-dl dt {
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.account-dl dd {
  margin: 4px 0 0;
  font-weight: 600;
}

.account-actions {
  margin-top: 32px;
  padding-top: 20px;
  border-top: 1px solid var(--st-outline-variant);
}

.workbench-placeholder :deep(svg) {
  width: 40px;
  height: 40px;
  color: var(--st-on-surface-variant);
  opacity: 0.6;
}
</style>
