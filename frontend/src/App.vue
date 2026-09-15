<script setup lang="ts">
import { computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElConfigProvider, ElMessage } from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import en from 'element-plus/es/locale/lang/en'
import { useAuthStore } from './stores/auth'
import { useUiPrefsStore } from './stores/uiPrefs'
import BrandLogo from './components/stitch/BrandLogo.vue'
import PaperPlaneTransit from './components/PaperPlaneTransit.vue'
import { markConsoleDashboardEntry, preloadConsole, pushConsole } from './utils/consoleNav'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const ui = useUiPrefsStore()

const elementLocale = computed(() => (ui.locale === 'en-US' ? en : zhCn))

const isLanding = computed(() => route.path === '/home' || route.path === '/')
const isConsole = computed(() => route.path.startsWith('/console'))
const isPaperExam = computed(() => route.path.startsWith('/paper/'))
/** 落地页 / 控制台 / 试卷作答页：隐藏全局顶栏 */
const hideAppChrome = computed(() => isLanding.value || isConsole.value || isPaperExam.value)
const showWorkbenchLink = computed(() => auth.isLoggedIn && !isConsole.value && !isPaperExam.value)

watch(
  () => auth.isLoggedIn,
  () => {
    void ui.loadRemote()
  },
  { immediate: true },
)

async function handleLogout() {
  await auth.signOut()
  ElMessage.success(ui.tr('common.logoutOk'))
  router.push('/home')
}
</script>

<template>
  <ElConfigProvider :locale="elementLocale">
    <div class="app-shell">
      <header v-if="!hideAppChrome" class="topbar">
        <div class="topbar-brand" @click="router.push('/home')">
          <BrandLogo variant="landing" :size="40" />
          <span v-if="!isLanding" class="brand-tag">招生查询与刷题平台</span>
        </div>
        <nav class="topbar-nav">
          <router-link to="/home" class="nav-link" active-class="nav-link--active">首页</router-link>
          <router-link
            v-if="auth.isLoggedIn"
            :to="{ path: '/console', hash: '#dashboard' }"
            class="nav-link"
            active-class="nav-link--active"
            @mouseenter="preloadConsole"
            @focus="preloadConsole"
          >
            工作台
          </router-link>
        </nav>
        <div class="topbar-actions">
          <template v-if="auth.isLoggedIn">
            <el-avatar :size="28" :src="auth.user?.avatarUrl" />
            <span class="user-name">{{ auth.user?.nickname }}</span>
            <el-button
              v-if="showWorkbenchLink"
              type="primary"
              size="small"
              @mouseenter="preloadConsole"
              @focus="preloadConsole"
              @click="markConsoleDashboardEntry(); pushConsole(router, 'dashboard')"
            >
              进入工作台
            </el-button>
            <el-button link @click="handleLogout">退出</el-button>
          </template>
          <el-button v-else type="primary" size="small" @click="router.push('/login')">登录</el-button>
        </div>
      </header>

      <main
        class="main"
        :class="{
          'main--wide': !isConsole && !isPaperExam && route.path !== '/home',
          'main--landing': isLanding,
          'main--console': isConsole || isPaperExam,
        }"
      >
        <router-view />
      </main>
      <PaperPlaneTransit />
    </div>
  </ElConfigProvider>
</template>

<style scoped>
.app-shell {
  min-height: 100vh;
  background: var(--st-bg);
}

.topbar {
  display: flex;
  align-items: center;
  gap: 24px;
  height: 56px;
  padding: 0 24px;
  background: var(--st-surface);
  border-bottom: 1px solid var(--st-outline-variant);
}

.topbar-brand {
  display: flex;
  align-items: baseline;
  gap: 8px;
  cursor: pointer;
  flex-shrink: 0;
}

.brand-tag {
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.topbar-nav {
  display: flex;
  gap: 16px;
  flex: 1;
}

.nav-link {
  font-size: 14px;
  color: var(--st-on-surface-variant);
  text-decoration: none;
}

.nav-link--active {
  color: var(--st-secondary);
  font-weight: 600;
}

.topbar-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-name {
  font-size: 13px;
  color: var(--st-on-surface);
}

.main {
  max-width: 1080px;
  margin: 0 auto;
  padding: 24px 16px 48px;
}

.main--wide {
  max-width: 1280px;
}

.main--landing {
  max-width: none;
  padding: 0;
}

.main--console {
  max-width: none;
  margin: 0;
  padding: 0;
}
</style>
