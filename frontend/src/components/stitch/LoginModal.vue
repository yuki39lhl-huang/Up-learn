<script setup lang="ts">
import { onUnmounted, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { sendLoginCode, loginByCode } from '../../api/user'
import { useAuthStore } from '../../stores/auth'

const props = defineProps<{
  visible: boolean
}>()

const emit = defineEmits<{
  close: []
  success: []
}>()

const auth = useAuthStore()

const email = ref('')
const code = ref('')
const sending = ref(false)
const logging = ref(false)
const countdown = ref(0)

let timer: ReturnType<typeof setInterval> | null = null

function lockScroll(lock: boolean) {
  document.body.style.overflow = lock ? 'hidden' : ''
}

watch(
  () => props.visible,
  (open) => {
    lockScroll(open)
    if (!open) {
      code.value = ''
    }
  },
  { immediate: true },
)

onUnmounted(() => {
  lockScroll(false)
  if (timer) clearInterval(timer)
})

function startCountdown() {
  countdown.value = 60
  if (timer) clearInterval(timer)
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
  if (!email.value.trim() || !code.value.trim()) {
    ElMessage.warning('请输入邮箱和验证码')
    return
  }
  logging.value = true
  try {
    const vo = await loginByCode(email.value.trim(), code.value.trim())
    auth.setSession(vo)
    ElMessage.success('登录成功')
    emit('success')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '登录失败')
  } finally {
    logging.value = false
  }
}

function handleBackdropClick(e: MouseEvent) {
  if (e.target === e.currentTarget) emit('close')
}
</script>

<template>
  <Teleport to="body">
    <Transition name="login-fade">
      <div
        v-if="visible"
        class="login-overlay"
        role="dialog"
        aria-modal="true"
        aria-labelledby="login-modal-title"
        @click="handleBackdropClick"
      >
        <div class="login-modal">
          <div class="login-modal__glow" aria-hidden="true" />
          <button type="button" class="login-modal__close" aria-label="关闭" @click="emit('close')">
            ×
          </button>

          <h2 id="login-modal-title" class="login-modal__title">登录 / 注册</h2>
          <p class="login-modal__subtitle">欢迎使用升学通，登录以继续</p>

          <form class="login-form" @submit.prevent="handleLogin">
            <label class="login-field">
              <span class="login-field__label">邮箱</span>
              <input
                v-model="email"
                type="email"
                class="login-field__input"
                placeholder="your@email.com"
                autocomplete="email"
              />
            </label>

            <label class="login-field">
              <span class="login-field__label">验证码</span>
              <div class="login-code-row">
                <input
                  v-model="code"
                  type="text"
                  class="login-field__input"
                  maxlength="6"
                  placeholder="6 位数字"
                  autocomplete="one-time-code"
                />
                <button
                  type="button"
                  class="login-code-btn"
                  :disabled="countdown > 0 || sending"
                  @click="handleSendCode"
                >
                  {{ sending ? '发送中…' : countdown > 0 ? `${countdown}s` : '获取验证码' }}
                </button>
              </div>
            </label>

            <button type="submit" class="login-submit" :disabled="logging">
              {{ logging ? '登录中…' : '继续' }}
            </button>
          </form>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.login-overlay {
  position: fixed;
  inset: 0;
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgb(15 23 42 / 42%);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
}

.login-modal {
  position: relative;
  width: 100%;
  max-width: 420px;
  padding: 32px 28px 28px;
  border-radius: 24px;
  background: #fff;
  box-shadow:
    0 24px 48px rgb(15 23 42 / 18%),
    0 0 0 1px rgb(255 255 255 / 60%) inset;
  overflow: hidden;
}

.login-modal__glow {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 72px;
  background: linear-gradient(
    135deg,
    rgb(196 181 253 / 55%) 0%,
    rgb(251 207 232 / 50%) 45%,
    rgb(191 219 254 / 55%) 100%
  );
  filter: blur(8px);
  pointer-events: none;
}

.login-modal__close {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 1;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 999px;
  background: rgb(255 255 255 / 70%);
  color: #64748b;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  transition: background 0.15s ease;
}

.login-modal__close:hover {
  background: rgb(241 245 249 / 95%);
  color: #334155;
}

.login-modal__title {
  position: relative;
  margin: 8px 0 6px;
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #0f172a;
  text-align: center;
}

.login-modal__subtitle {
  position: relative;
  margin: 0 0 24px;
  font-size: 14px;
  color: #64748b;
  text-align: center;
}

.login-form {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.login-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.login-field__label {
  font-size: 13px;
  font-weight: 500;
  color: #334155;
}

.login-field__input {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  background: #f8fafc;
  font-size: 15px;
  color: #0f172a;
  outline: none;
  transition:
    border-color 0.15s ease,
    box-shadow 0.15s ease,
    background 0.15s ease;
}

.login-field__input::placeholder {
  color: #94a3b8;
}

.login-field__input:focus {
  border-color: #cbd5e1;
  background: #fff;
  box-shadow: 0 0 0 3px rgb(148 163 184 / 18%);
}

.login-code-row {
  display: flex;
  gap: 8px;
}

.login-code-row .login-field__input {
  flex: 1;
  min-width: 0;
}

.login-code-btn {
  flex-shrink: 0;
  height: 48px;
  padding: 0 14px;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  background: #fff;
  font-size: 13px;
  font-weight: 500;
  color: #334155;
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.15s ease;
}

.login-code-btn:hover:not(:disabled) {
  background: #f8fafc;
}

.login-code-btn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.login-submit {
  margin-top: 4px;
  height: 48px;
  border: none;
  border-radius: 999px;
  background: #0f172a;
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.15s ease;
}

.login-submit:hover:not(:disabled) {
  opacity: 0.92;
}

.login-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-fade-enter-active,
.login-fade-leave-active {
  transition: opacity 0.22s ease;
}

.login-fade-enter-active .login-modal,
.login-fade-leave-active .login-modal {
  transition:
    transform 0.22s ease,
    opacity 0.22s ease;
}

.login-fade-enter-from,
.login-fade-leave-to {
  opacity: 0;
}

.login-fade-enter-from .login-modal,
.login-fade-leave-to .login-modal {
  transform: translateY(12px) scale(0.98);
  opacity: 0;
}
</style>
