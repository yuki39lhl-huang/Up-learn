<script setup lang="ts">
/**
 * 独立登录页 `/login`：与 LoginModal 共用 useLoginForm；
 * 成功后按 redirect 或默认进入控制台。
 */
import { useRoute, useRouter } from 'vue-router'
import { useLoginForm } from '../composables/useLoginForm'
import {
  consoleFullPath,
  isDashboardConsoleHref,
  markConsoleDashboardEntry,
  pushConsoleHref,
} from '../utils/consoleNav'

const route = useRoute()
const router = useRouter()

const {
  mode,
  email,
  code,
  password,
  sending,
  logging,
  countdown,
  switchMode,
  setCodeFromInput,
  handleSendCode,
  handleLogin,
} = useLoginForm({
  onSuccess: async () => {
    const redirect =
      typeof route.query.redirect === 'string' ? route.query.redirect : consoleFullPath('dashboard')
    if (isDashboardConsoleHref(redirect)) {
      markConsoleDashboardEntry()
    }
    pushConsoleHref(router, redirect)
  },
})
</script>

<template>
  <div class="login-page">
    <div class="login-card st-card">
      <p class="st-label-caps">升学通</p>
      <h1 class="st-headline">登录</h1>
      <p class="hint">验证码可自动注册；密码登录需先在账号安全中设置密码</p>

      <div class="login-tabs">
        <button
          type="button"
          class="login-tabs__item"
          :class="{ 'login-tabs__item--active': mode === 'code' }"
          @click="switchMode('code')"
        >
          验证码
        </button>
        <button
          type="button"
          class="login-tabs__item"
          :class="{ 'login-tabs__item--active': mode === 'password' }"
          @click="switchMode('password')"
        >
          密码
        </button>
      </div>

      <el-form label-position="top" @submit.prevent="handleLogin">
        <el-form-item label="邮箱">
          <el-input v-model="email" placeholder="your@email.com" size="large" />
        </el-form-item>
        <el-form-item v-if="mode === 'code'" label="验证码">
          <div class="code-row">
            <el-input
              :model-value="code"
              placeholder="6 位数字"
              size="large"
              inputmode="numeric"
              autocomplete="one-time-code"
              @update:model-value="setCodeFromInput"
            />
            <el-button size="large" :disabled="countdown > 0" :loading="sending" @click="handleSendCode">
              {{ countdown > 0 ? `${countdown}s` : '获取验证码' }}
            </el-button>
          </div>
        </el-form-item>
        <el-form-item v-else label="密码">
          <el-input
            v-model="password"
            type="password"
            show-password
            placeholder="请输入密码"
            size="large"
          />
        </el-form-item>
        <el-button type="primary" size="large" class="submit" :loading="logging" @click="handleLogin">
          {{ mode === 'code' ? '登录 / 注册' : '登录' }}
        </el-button>
      </el-form>

      <el-button link type="primary" @click="router.push('/home')">返回首页</el-button>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  display: flex;
  justify-content: center;
  padding-top: 48px;
}

.login-card {
  width: 100%;
  max-width: 420px;
  padding: 28px 24px 20px;
}

.login-card h1 {
  margin: 4px 0 8px;
}

.hint {
  margin: 0 0 16px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.login-tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px;
  margin-bottom: 16px;
  padding: 4px;
  border-radius: 10px;
  background: var(--st-surface-container-low, #f0f3ff);
}

.login-tabs__item {
  height: 34px;
  border: none;
  border-radius: 8px;
  background: transparent;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  cursor: pointer;
}

.login-tabs__item--active {
  background: #fff;
  color: var(--st-on-surface);
  font-weight: 600;
  box-shadow: 0 1px 2px rgb(21 28 39 / 8%);
}

.code-row {
  display: flex;
  gap: 8px;
  width: 100%;
}

.submit {
  width: 100%;
  margin-bottom: 8px;
}
</style>
