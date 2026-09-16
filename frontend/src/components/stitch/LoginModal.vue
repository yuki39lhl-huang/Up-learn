<script setup lang="ts">
/**
 * 落地页登录弹窗：验证码 / 密码 Tab，逻辑见 useLoginForm。
 * 不提供忘记密码入口。
 */
import { onUnmounted, watch } from 'vue'
import { useLoginForm } from '../../composables/useLoginForm'
import BrandLogo from './BrandLogo.vue'

const props = defineProps<{
  visible: boolean
}>()

const emit = defineEmits<{
  close: []
  success: []
}>()

const {
  mode,
  email,
  code,
  password,
  sending,
  logging,
  countdown,
  switchMode,
  resetForm,
  setCodeFromInput,
  onCodePaste,
  handleSendCode,
  handleLogin,
} = useLoginForm({
  onSuccess: async () => {
    emit('success')
  },
})

function lockScroll(lock: boolean) {
  document.body.style.overflow = lock ? 'hidden' : ''
}

watch(
  () => props.visible,
  (open) => {
    lockScroll(open)
    if (!open) resetForm()
  },
  { immediate: true },
)

onUnmounted(() => {
  lockScroll(false)
})

function handleBackdropClick(e: MouseEvent) {
  if (e.target === e.currentTarget) emit('close')
}

function onCodeInput(e: Event) {
  setCodeFromInput((e.target as HTMLInputElement).value)
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

          <div class="login-modal__brand">
            <BrandLogo :size="44" />
          </div>
          <h2 id="login-modal-title" class="login-modal__title">登录 / 注册</h2>
          <p class="login-modal__subtitle">欢迎使用升学通，登录以继续</p>

          <div class="login-tabs" role="tablist">
            <button
              type="button"
              role="tab"
              class="login-tabs__item"
              :class="{ 'login-tabs__item--active': mode === 'code' }"
              :aria-selected="mode === 'code'"
              @click="switchMode('code')"
            >
              验证码登录
            </button>
            <button
              type="button"
              role="tab"
              class="login-tabs__item"
              :class="{ 'login-tabs__item--active': mode === 'password' }"
              :aria-selected="mode === 'password'"
              @click="switchMode('password')"
            >
              密码登录
            </button>
          </div>

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

            <label v-if="mode === 'code'" class="login-field">
              <span class="login-field__label">验证码</span>
              <div class="login-code-row">
                <input
                  :value="code"
                  type="text"
                  class="login-field__input"
                  inputmode="numeric"
                  autocomplete="one-time-code"
                  placeholder="6 位数字"
                  @input="onCodeInput"
                  @paste="onCodePaste"
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

            <label v-else class="login-field">
              <span class="login-field__label">密码</span>
              <input
                v-model="password"
                type="password"
                class="login-field__input"
                placeholder="请输入密码"
                autocomplete="current-password"
              />
              <span class="login-field__hint">未设置密码请先用验证码登录，再在账号安全中设置</span>
            </label>

            <button type="submit" class="login-submit" :disabled="logging">
              {{ logging ? '登录中…' : mode === 'code' ? '继续' : '登录' }}
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
  border: 1px solid var(--st-outline-variant);
  background: var(--st-surface);
  box-shadow:
    0 24px 48px rgb(15 23 42 / 18%),
    inset 0 1px 0 var(--st-glass-inset);
  overflow: hidden;
  color: var(--st-on-surface);
}

.login-modal__glow {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 72px;
  background: linear-gradient(
    135deg,
    rgb(196 181 253 / 40%) 0%,
    rgb(251 207 232 / 35%) 45%,
    rgb(191 219 254 / 40%) 100%
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
  border: 1px solid var(--st-outline-variant);
  border-radius: 999px;
  background: var(--st-surface-container);
  color: var(--st-on-surface-variant);
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease;
}

.login-modal__close:hover {
  background: var(--st-surface-container-low);
  color: var(--st-on-surface);
}

.login-modal__brand {
  display: flex;
  justify-content: center;
  margin-bottom: 12px;
}

.login-modal__title {
  position: relative;
  margin: 8px 0 6px;
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--st-on-surface);
  text-align: center;
}

.login-modal__subtitle {
  position: relative;
  margin: 0 0 18px;
  font-size: 14px;
  color: var(--st-on-surface-variant);
  text-align: center;
}

.login-tabs {
  position: relative;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px;
  margin-bottom: 18px;
  padding: 4px;
  border-radius: 12px;
  background: var(--st-surface-container-low);
  border: 1px solid var(--st-outline-variant);
}

.login-tabs__item {
  height: 36px;
  border: none;
  border-radius: 9px;
  background: transparent;
  font-size: 13px;
  font-weight: 500;
  color: var(--st-on-surface-variant);
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease;
}

.login-tabs__item--active {
  background: var(--st-surface-container);
  color: var(--st-on-surface);
  box-shadow: var(--st-shadow-card);
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
  color: var(--st-on-surface);
}

.login-field__hint {
  font-size: 12px;
  color: var(--st-on-surface-variant);
  line-height: 1.4;
  opacity: 0.85;
}

.login-field__input {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  border: 1px solid var(--st-outline-variant);
  border-radius: 12px;
  background: var(--st-surface-container-low);
  font-size: 15px;
  color: var(--st-on-surface);
  outline: none;
  color-scheme: inherit;
  transition:
    border-color 0.15s ease,
    box-shadow 0.15s ease,
    background 0.15s ease;
}

.login-field__input::placeholder {
  color: var(--st-on-surface-variant);
  opacity: 0.75;
}

.login-field__input:focus {
  border-color: var(--st-primary);
  background: var(--st-surface);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--st-primary) 22%, transparent);
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
  border: 1px solid var(--st-outline-variant);
  border-radius: 12px;
  background: var(--st-surface-container);
  font-size: 13px;
  font-weight: 500;
  color: var(--st-on-surface);
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.15s ease, border-color 0.15s ease;
}

.login-code-btn:hover:not(:disabled) {
  background: var(--st-surface-container-low);
  border-color: var(--st-outline);
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
  background: var(--st-primary);
  color: var(--st-on-primary);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.15s ease, filter 0.15s ease;
}

.login-submit:hover:not(:disabled) {
  filter: brightness(1.06);
}

.login-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

html[data-theme='dark'] .login-overlay {
  background: rgb(0 0 0 / 62%);
}

html[data-theme='dark'] .login-modal {
  box-shadow: 0 24px 56px rgb(0 0 0 / 48%);
}

html[data-theme='dark'] .login-modal__glow {
  background: linear-gradient(
    135deg,
    rgb(74 222 128 / 14%) 0%,
    rgb(125 180 255 / 12%) 50%,
    rgb(74 222 128 / 8%) 100%
  );
  opacity: 0.85;
}

html[data-theme='dark'] .login-tabs__item--active {
  background: var(--st-surface);
}

html[data-theme='dark'] .login-field__input:-webkit-autofill,
html[data-theme='dark'] .login-field__input:-webkit-autofill:hover,
html[data-theme='dark'] .login-field__input:-webkit-autofill:focus {
  -webkit-text-fill-color: var(--st-on-surface);
  caret-color: var(--st-on-surface);
  box-shadow: 0 0 0 1000px var(--st-surface-container-low) inset;
  transition: background-color 99999s ease-out;
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
