<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { sendLoginCode, loginByCode } from '../api/user'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const email = ref('')
const code = ref('')
const sending = ref(false)
const logging = ref(false)
const countdown = ref(0)

let timer: ReturnType<typeof setInterval> | null = null

function startCountdown() {
  countdown.value = 60
  timer = setInterval(() => {
    countdown.value -= 1
    if (countdown.value <= 0 && timer) {
      clearInterval(timer)
      timer = null
    }
  }, 1000)
}

async function handleSendCode() {
  if (!email.value.trim()) {
    ElMessage.warning('请输入邮箱')
    return
  }
  sending.value = true
  try {
    await sendLoginCode(email.value.trim())
    ElMessage.success('验证码已发送')
    startCountdown()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '发送失败')
  } finally {
    sending.value = false
  }
}

async function handleLogin() {
  logging.value = true
  try {
    const vo = await loginByCode(email.value.trim(), code.value.trim())
    auth.setSession(vo)
    ElMessage.success('登录成功')
    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : '/console#dashboard'
    router.push(redirect)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '登录失败')
  } finally {
    logging.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card st-card">
      <p class="st-label-caps">升学通</p>
      <h1 class="st-headline">邮箱验证码登录</h1>
      <p class="hint">登录后进入 Stitch 定稿「工作台首屏」</p>

      <el-form label-position="top" @submit.prevent="handleLogin">
        <el-form-item label="邮箱">
          <el-input v-model="email" placeholder="your@email.com" size="large" />
        </el-form-item>
        <el-form-item label="验证码">
          <div class="code-row">
            <el-input v-model="code" maxlength="6" placeholder="6 位数字" size="large" />
            <el-button size="large" :disabled="countdown > 0" :loading="sending" @click="handleSendCode">
              {{ countdown > 0 ? `${countdown}s` : '获取验证码' }}
            </el-button>
          </div>
        </el-form-item>
        <el-button type="primary" size="large" class="submit" :loading="logging" @click="handleLogin">
          登录 / 注册
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
  margin: 0 0 20px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
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
