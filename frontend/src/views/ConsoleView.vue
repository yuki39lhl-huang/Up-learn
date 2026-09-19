<script setup lang="ts">
import { computed, defineAsyncComponent, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import DashboardPanel from '../components/stitch/DashboardPanel.vue'
import BrandLogo from '../components/stitch/BrandLogo.vue'
import StitchIcon from '../components/stitch/StitchIcon.vue'
import { useAuthStore } from '../stores/auth'
import { useExamPrefsStore } from '../stores/examPrefs'
import { useUiPrefsStore } from '../stores/uiPrefs'
import {
  consumeConsoleDashboardEntry,
  consoleLocation,
  hashToConsoleModule,
  pushConsole,
  type ConsoleModule,
} from '../utils/consoleNav'
import { fetchCommunityNotifications } from '../api/community'
import { subscribeCommunitySync } from '../utils/communitySync'
import '../styles/console-workbench.css'

/** 非首屏模块异步分包，首次进入控制台只扛主页 */
const SchoolQueryPanel = defineAsyncComponent(() => import('../components/stitch/SchoolQueryPanel.vue'))
const SyllabusPanel = defineAsyncComponent(() => import('../components/stitch/SyllabusPanel.vue'))
const PracticePanel = defineAsyncComponent(() => import('../components/stitch/PracticePanel.vue'))
const PapersPanel = defineAsyncComponent(() => import('../components/stitch/PapersPanel.vue'))
const CommunityPanel = defineAsyncComponent(() => import('../components/stitch/CommunityPanel.vue'))
const AgentChatPanel = defineAsyncComponent(() => import('../components/stitch/AgentChatPanel.vue'))
const AccountSettingsPanel = defineAsyncComponent(
  () => import('../components/stitch/AccountSettingsPanel.vue'),
)
const SettingsPanel = defineAsyncComponent(() => import('../components/stitch/SettingsPanel.vue'))
const CommunityNotificationsPanel = defineAsyncComponent(
  () => import('../components/stitch/CommunityNotificationsPanel.vue'),
)

type ModuleKey = ConsoleModule
type SystemKey = 'ui-settings' | 'notifications' | 'account'
type ViewKey = ModuleKey | SystemKey

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const examPrefs = useExamPrefsStore()
const ui = useUiPrefsStore()

/** 按访问过的视图才挂载，之后 v-show 保活 */
const mountedViews = reactive<Record<ViewKey, boolean>>({
  dashboard: false,
  school: false,
  syllabus: false,
  random: false,
  papers: false,
  community: false,
  agent: false,
  'ui-settings': false,
  notifications: false,
  account: false,
})

function ensureMounted(view: ViewKey) {
  mountedViews[view] = true
}
function toggleSidebar() {
  void ui.persist({ sidebarCollapsed: !ui.state.sidebarCollapsed })
}

async function onToggleTheme() {
  try {
    await ui.toggleTheme()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '主题切换失败')
  }
}

const navItems = computed(() => [
  { key: 'dashboard' as const, label: ui.tr('nav.home'), icon: 'home' as const },
  { key: 'school' as const, label: ui.tr('nav.school'), icon: 'school' as const },
  { key: 'syllabus' as const, label: ui.tr('nav.syllabus'), icon: 'syllabus' as const },
  { key: 'random' as const, label: ui.tr('nav.random'), icon: 'practice' as const },
  { key: 'papers' as const, label: ui.tr('nav.papers'), icon: 'paper' as const },
  { key: 'community' as const, label: ui.tr('nav.community'), icon: 'community' as const },
  { key: 'agent' as const, label: ui.tr('nav.agent'), icon: 'agent' as const },
])

const notifyUnread = ref(0)
let unsubNotifySync: (() => void) | null = null

function onNotifyUnreadChange(n: number) {
  notifyUnread.value = n
}

async function refreshNotifyBadge() {
  if (!auth.isLoggedIn) {
    notifyUnread.value = 0
    return
  }
  try {
    const list = await fetchCommunityNotifications()
    notifyUnread.value = (list || []).filter((n) => !n.read).length
  } catch {
    // 静默：未起 community-service 时不打扰
  }
}

/** 系统视图 hash；模块 hash 交给 consoleNav 的单一映射 */
const SYSTEM_HASH: Record<string, SystemKey> = {
  '#ui-settings': 'ui-settings',
  '#settings': 'ui-settings',
  '#notifications': 'notifications',
  '#account': 'account',
}

function hashToView(hash: string): ViewKey {
  return SYSTEM_HASH[hash] ?? hashToConsoleModule(hash) ?? 'dashboard'
}

const activeView = ref<ViewKey>('dashboard')

/** 设置/通知/账号不播；其它模块切入主展示区时轻过渡，避免瞬间切换顿挫 */
const SYSTEM_VIEWS = new Set<ViewKey>(['ui-settings', 'notifications', 'account'])
const isModuleView = computed(() => !SYSTEM_VIEWS.has(activeView.value))
const moduleEnter = ref(false)
let moduleEnterTimer: ReturnType<typeof setTimeout> | null = null

async function playModuleEnter() {
  if (moduleEnterTimer) {
    clearTimeout(moduleEnterTimer)
    moduleEnterTimer = null
  }
  moduleEnter.value = false
  await nextTick()
  requestAnimationFrame(() => {
    moduleEnter.value = true
    // 动画结束后摘掉标记，恢复主区滚动，避免 overflow:hidden 常驻
    moduleEnterTimer = setTimeout(() => {
      moduleEnter.value = false
      moduleEnterTimer = null
    }, 360)
  })
}

watch(
  activeView,
  (view) => {
    ensureMounted(view)
    if (SYSTEM_VIEWS.has(view)) {
      if (moduleEnterTimer) {
        clearTimeout(moduleEnterTimer)
        moduleEnterTimer = null
      }
      moduleEnter.value = false
      return
    }
    // 院校查询自带下拉展开，避免与通用淡入叠加重卡顿感
    if (view === 'school') {
      if (moduleEnterTimer) {
        clearTimeout(moduleEnterTimer)
        moduleEnterTimer = null
      }
      moduleEnter.value = false
      return
    }
    void playModuleEnter()
  },
  { immediate: true },
)

const pageTitle = computed(() => {
  const map: Record<ViewKey, string> = {
    dashboard: ui.tr('nav.home'),
    school: ui.tr('nav.school'),
    syllabus: ui.tr('nav.syllabus'),
    random: ui.tr('nav.random'),
    papers: ui.tr('nav.papers'),
    community: ui.tr('nav.community'),
    agent: ui.tr('nav.agent'),
    'ui-settings': ui.tr('nav.settings'),
    notifications: ui.tr('nav.notifications'),
    account: ui.tr('nav.account'),
  }
  return map[activeView.value]
})

function selectModule(key: ModuleKey) {
  activeView.value = key
  pushConsole(router, key)
}

function selectSystem(key: SystemKey) {
  activeView.value = key
  router.replace({ path: '/console', hash: `#${key}` })
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

onMounted(() => {
  if (auth.isLoggedIn) {
    void auth.refreshProfile()
    void refreshNotifyBadge()
  }
  unsubNotifySync = subscribeCommunitySync((ev) => {
    if (
      ev.type === 'comment-changed' ||
      ev.type === 'post-updated' ||
      ev.type === 'favorite-changed' ||
      ev.type === 'follow-changed'
    ) {
      void refreshNotifyBadge()
    }
  })
  document.addEventListener('visibilitychange', onConsoleVisibility)
})

function onConsoleVisibility() {
  if (document.visibilityState === 'visible' && auth.isLoggedIn) {
    void refreshNotifyBadge()
  }
}

onBeforeUnmount(() => {
  unsubNotifySync?.()
  document.removeEventListener('visibilitychange', onConsoleVisibility)
})

async function handleLogout() {
  await auth.signOut()
  ElMessage.success(ui.tr('common.logoutOk'))
  router.push('/home')
}
</script>

<template>
  <div class="gmail-shell">
    <header class="gmail-topbar">
      <button
        type="button"
        class="gmail-menu-btn"
        :aria-label="ui.tr('topbar.toggleSidebar')"
        @click="toggleSidebar"
      >
        <StitchIcon name="menu" />
      </button>
      <button type="button" class="gmail-logo" @click="router.push('/home')">
        <BrandLogo :size="40" />
      </button>
      <div class="gmail-topbar__spacer" />
      <span class="gmail-topbar__meta">{{ seasonMeta }}</span>
      <div class="gmail-topbar__actions">
        <button
          type="button"
          class="gmail-icon-btn"
          :aria-label="ui.theme === 'dark' ? ui.tr('topbar.themeToLight') : ui.tr('topbar.themeToDark')"
          :title="ui.theme === 'dark' ? ui.tr('topbar.themeToLight') : ui.tr('topbar.themeToDark')"
          @click="onToggleTheme"
        >
          <StitchIcon :name="ui.theme === 'dark' ? 'sun' : 'moon'" />
        </button>
        <button
          type="button"
          class="gmail-icon-btn gmail-icon-btn--notify"
          :class="{ 'gmail-icon-btn--active': activeView === 'notifications' }"
          :aria-label="ui.tr('topbar.notifications')"
          :title="ui.tr('topbar.notifications')"
          @click="selectSystem('notifications')"
        >
          <StitchIcon name="bell" />
          <span v-if="notifyUnread > 0" class="gmail-notify-badge">
            {{ notifyUnread > 99 ? '99+' : notifyUnread }}
          </span>
        </button>
        <button
          type="button"
          class="gmail-avatar-btn"
          :class="{ 'gmail-avatar-btn--active': activeView === 'account' }"
          :aria-label="ui.tr('topbar.account')"
          :title="ui.tr('topbar.account')"
          @click="selectSystem('account')"
        >
          <el-avatar :size="32" :src="auth.user?.avatarUrl">
            {{ auth.user?.nickname?.slice(0, 1) ?? 'U' }}
          </el-avatar>
        </button>
      </div>
    </header>

    <div class="gmail-frame">
      <aside
        class="gmail-sidebar"
        :class="{ 'gmail-sidebar--collapsed': ui.sidebarCollapsed }"
        aria-label="主导航"
      >
        <nav class="gmail-nav">
          <button
            v-for="item in navItems"
            :key="item.key"
            type="button"
            class="gmail-nav__item"
            :class="{ 'gmail-nav__item--active': activeView === item.key }"
            :title="ui.sidebarCollapsed ? item.label : undefined"
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
            :title="ui.tr('nav.settings')"
            @click="selectSystem('ui-settings')"
          >
            <StitchIcon name="settings" />
            <span class="gmail-nav__label">{{ ui.tr('nav.settings') }}</span>
          </button>
          <div class="gmail-api">
            <i class="gmail-api__dot" />
            <span>API Online</span>
          </div>
        </div>
      </aside>

      <div class="gmail-panel-host">
        <section class="gmail-panel" aria-label="主内容">
          <header class="gmail-panel__bar">
            <h1>{{ pageTitle }}</h1>
          </header>

          <div
            class="gmail-panel__body"
            :class="{ 'gmail-panel__body--module-enter': moduleEnter }"
          >
            <!-- 系统页与业务模块并列；未访问过的视图不挂载（懒加载），访问后 v-show 保活 -->
            <div
              v-if="mountedViews['ui-settings']"
              v-show="activeView === 'ui-settings'"
              class="gmail-panel__content"
            >
              <SettingsPanel />
            </div>

            <div
              v-if="mountedViews.notifications"
              v-show="activeView === 'notifications'"
              class="gmail-panel__content gmail-panel__content--flush"
            >
              <CommunityNotificationsPanel
                :active="activeView === 'notifications'"
                @unread-change="onNotifyUnreadChange"
              />
            </div>

            <div
              v-if="mountedViews.account"
              v-show="activeView === 'account'"
              class="account-panel-host"
            >
              <AccountSettingsPanel @logout="handleLogout" />
            </div>

            <div
              v-show="isModuleView"
              class="gmail-panel__content gmail-panel__content--flush module-stage"
              :class="{ 'module-stage--enter': moduleEnter }"
            >
              <DashboardPanel
                v-if="mountedViews.dashboard"
                v-show="activeView === 'dashboard'"
              />
              <SchoolQueryPanel
                v-if="mountedViews.school"
                v-show="activeView === 'school'"
                :active="activeView === 'school'"
              />
              <SyllabusPanel
                v-if="mountedViews.syllabus"
                v-show="activeView === 'syllabus'"
              />
              <PracticePanel
                v-if="mountedViews.random"
                v-show="activeView === 'random'"
                key="random"
                default-mode="random"
              />
              <PapersPanel
                v-if="mountedViews.papers"
                v-show="activeView === 'papers'"
              />
              <CommunityPanel
                v-if="mountedViews.community"
                v-show="activeView === 'community'"
              />
              <AgentChatPanel
                v-if="mountedViews.agent"
                v-show="activeView === 'agent'"
              />
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<style scoped>
.workbench-placeholder :deep(svg) {
  width: 40px;
  height: 40px;
  color: var(--st-on-surface-variant);
  opacity: 0.6;
}

/*
 * 切入动效只做位移，不在祖先层做 opacity 渐变：
 * 祖先 opacity < 1 会把子元素的 backdrop-filter 限制在该合成组内，
 * 动画期间模块卡片会直接透到底层壁纸，结束瞬间毛玻璃才「弹」出来。
 */
.module-stage--enter {
  overflow: hidden !important;
  animation: module-stage-in 0.34s cubic-bezier(0.22, 1, 0.36, 1) both;
}

/* 动画期间锁住主区溢出，避免 translate 撑出瞬时滚动条导致内容横移 */
:deep(.gmail-panel__body--module-enter) {
  overflow: hidden !important;
}

@keyframes module-stage-in {
  from {
    transform: translate3d(0, 10px, 0);
  }
  to {
    transform: translate3d(0, 0, 0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .module-stage--enter {
    animation: none;
  }
}
</style>
