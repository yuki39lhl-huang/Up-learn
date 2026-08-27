<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAuthStore } from './stores/auth'
import { logout } from './api/user'
import BrandLogo from './components/stitch/BrandLogo.vue'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const isLanding = computed(() => route.path === '/home' || route.path === '/')
const isConsole = computed(() => route.path.startsWith('/console'))
const hideAppChrome = computed(() => isLanding.value || isConsole.value)
const showWorkbenchLink = computed(() => auth.isLoggedIn && !isConsole.value)

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
  <div class="app-shell">
    <header v-if="!hideAppChrome" class="topbar">
      <div class="topbar-brand" @click="router.push('/home')">
        <BrandLogo variant="landing" :size="22" />
        <span v-if="!isLanding" class="brand-tag">招生查询与刷题平台</span>
      </div>
      <nav class="topbar-nav">
        <router-link to="/home" class="nav-link" active-class="nav-link--active">首页</router-link>
        <router-link
          v-if="auth.isLoggedIn"
          to="/console#dashboard"
          class="nav-link"
          active-class="nav-link--active"
        >
          工作台
        </router-link>
      </nav>
      <div class="topbar-actions">
        <template v-if="auth.isLoggedIn">
          <el-avatar :size="28" :src="auth.user?.avatarUrl" />
          <span class="user-name">{{ auth.user?.nickname }}</span>
          <el-button v-if="showWorkbenchLink" type="primary" size="small" @click="router.push('/console#dashboard')">
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
        'main--wide': !isConsole && route.path !== '/home',
        'main--landing': isLanding,
        'main--console': isConsole,
      }"
    >
      <router-view />
    </main>
  </div>
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

.brand-logo {
  font-weight: 700;
  font-size: 18px;
  color: var(--st-primary);
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
