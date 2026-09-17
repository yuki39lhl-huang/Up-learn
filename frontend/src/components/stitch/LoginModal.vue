<script setup lang="ts">
/**
 * 落地页登录弹窗：验证码 / 密码 Tab，逻辑见 useLoginForm。
 * 视觉跟随官网 Agent Liftoff（非控制台 Stitch 绿）。
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
          <button type="button" class="login-modal__close" aria-label="关闭" @click="emit('close')">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" aria-hidden="true">
              <path d="M6 6l12 12M18 6L6 18" />
            </svg>
          </button>

          <div class="login-modal__brand">
            <BrandLogo variant="landing" :size="40" />
          </div>
          <h2 id="login-modal-title" class="login-modal__title">登录 / 注册</h2>
          <p class="login-modal__subtitle">进入控制台前，先确认身份</p>

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
/* Teleport 到 body：自带 Liftoff token，不依赖 .landing-page / Stitch 绿 */
.login-overlay {
  --lm-font: 'Figtree', 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif;
  --lm-ease: cubic-bezier(0.16, 1, 0.3, 1);
  --lm-bg: #ffffff;
  --lm-text: #121212;
  --lm-muted: #5c5c5c;
  --lm-border: rgb(0 0 0 / 12%);
  --lm-input-bg: #f4f4f5;
  --lm-input-focus: #ffffff;
  --lm-tab-track: #f4f4f5;
  --lm-cta-bg: #121212;
  --lm-cta-fg: #ffffff;
  --lm-cta-hover: #000000;
  --lm-ghost-hover: rgb(0 0 0 / 5%);
  --lm-focus: rgb(0 0 0 / 28%);
  --lm-overlay: rgb(0 0 0 / 48%);
  --lm-shadow: 0 24px 64px rgb(0 0 0 / 18%);
  --lm-radius: 12px;
  --lm-selection-bg: rgb(0 0 0 / 12%);
  --lm-selection-fg: #121212;

  position: fixed;
  inset: 0;
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  background: var(--lm-overlay);
  backdrop-filter: blur(16px) saturate(1.1);
  -webkit-backdrop-filter: blur(16px) saturate(1.1);
  font-family: var(--lm-font);
  color-scheme: light;
}

html[data-theme='dark'] .login-overlay {
  --lm-bg: #0a0a0a;
  --lm-text: #f3f3f3;
  --lm-muted: #a3a3a3;
  --lm-border: rgb(255 255 255 / 14%);
  --lm-input-bg: #141414;
  --lm-input-focus: #121212;
  --lm-tab-track: #141414;
  --lm-cta-bg: #f5f5f5;
  --lm-cta-fg: #0a0a0a;
  --lm-cta-hover: #ffffff;
  --lm-ghost-hover: rgb(255 255 255 / 8%);
  --lm-focus: rgb(255 255 255 / 45%);
  --lm-overlay: rgb(0 0 0 / 72%);
  --lm-shadow: 0 28px 72px rgb(0 0 0 / 65%);
  --lm-selection-bg: rgb(255 255 255 / 22%);
  --lm-selection-fg: #ffffff;
  color-scheme: dark;
}

.login-overlay ::selection {
  background: var(--lm-selection-bg);
  color: var(--lm-selection-fg);
}

.login-modal {
  position: relative;
  width: 100%;
  max-width: 26rem;
  padding: 2rem 1.75rem 1.75rem;
  border-radius: var(--lm-radius);
  border: 1px solid var(--lm-border);
  background: var(--lm-bg);
  box-shadow: var(--lm-shadow);
  color: var(--lm-text);
  overflow: hidden;
}

.login-modal__close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  z-index: 1;
  display: grid;
  place-items: center;
  width: 2rem;
  height: 2rem;
  border: 1px solid var(--lm-border);
  border-radius: 8px;
  background: transparent;
  color: var(--lm-muted);
  cursor: pointer;
  transition:
    background 0.18s var(--lm-ease),
    color 0.18s ease,
    border-color 0.18s ease;
}

.login-modal__close:hover {
  background: var(--lm-ghost-hover);
  color: var(--lm-text);
  border-color: color-mix(in srgb, var(--lm-text) 28%, var(--lm-border));
}

.login-modal__close:focus-visible {
  outline: 2px solid var(--lm-focus);
  outline-offset: 2px;
}

.login-modal__brand {
  display: flex;
  justify-content: center;
  margin-bottom: 1rem;
}

.login-modal__title {
  margin: 0 0 0.4rem;
  font-size: 1.5rem;
  font-weight: 600;
  letter-spacing: -0.035em;
  line-height: 1.2;
  color: var(--lm-text);
  text-align: center;
}

.login-modal__subtitle {
  margin: 0 0 1.5rem;
  font-size: 0.9rem;
  font-weight: 400;
  line-height: 1.45;
  color: var(--lm-muted);
  text-align: center;
}

.login-tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.25rem;
  margin-bottom: 1.35rem;
  padding: 0.25rem;
  border-radius: 10px;
  background: var(--lm-tab-track);
  border: 1px solid var(--lm-border);
}

.login-tabs__item {
  height: 2.25rem;
  border: none;
  border-radius: 8px;
  background: transparent;
  font: inherit;
  font-size: 0.8125rem;
  font-weight: 500;
  letter-spacing: -0.01em;
  color: var(--lm-muted);
  cursor: pointer;
  transition:
    background 0.18s var(--lm-ease),
    color 0.18s ease;
}

.login-tabs__item--active {
  background: var(--lm-bg);
  color: var(--lm-text);
  box-shadow: 0 1px 2px rgb(0 0 0 / 8%);
}

html[data-theme='dark'] .login-tabs__item--active {
  background: #1a1a1a;
  box-shadow: 0 1px 2px rgb(0 0 0 / 40%);
}

.login-tabs__item:focus-visible {
  outline: 2px solid var(--lm-focus);
  outline-offset: 1px;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
}

.login-field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.login-field__label {
  font-size: 0.8125rem;
  font-weight: 500;
  letter-spacing: -0.01em;
  color: var(--lm-text);
}

.login-field__hint {
  font-size: 0.75rem;
  line-height: 1.45;
  color: var(--lm-muted);
}

.login-field__input {
  width: 100%;
  height: 2.875rem;
  padding: 0 0.95rem;
  border: 1px solid var(--lm-border);
  border-radius: 10px;
  background: var(--lm-input-bg);
  font: inherit;
  font-size: 0.9375rem;
  color: var(--lm-text);
  outline: none;
  color-scheme: inherit;
  caret-color: var(--lm-text);
  transition:
    border-color 0.18s ease,
    box-shadow 0.18s ease,
    background 0.18s ease;
}

.login-field__input::placeholder {
  color: var(--lm-muted);
  opacity: 0.85;
}

.login-field__input:hover {
  border-color: color-mix(in srgb, var(--lm-text) 22%, var(--lm-border));
}

.login-field__input:focus {
  border-color: color-mix(in srgb, var(--lm-text) 45%, var(--lm-border));
  background: var(--lm-input-focus);
  box-shadow: 0 0 0 3px var(--lm-focus);
}

.login-code-row {
  display: flex;
  gap: 0.5rem;
}

.login-code-row .login-field__input {
  flex: 1;
  min-width: 0;
}

.login-code-btn {
  flex-shrink: 0;
  height: 2.875rem;
  padding: 0 0.9rem;
  border: 1px solid var(--lm-border);
  border-radius: 10px;
  background: transparent;
  font: inherit;
  font-size: 0.8125rem;
  font-weight: 500;
  color: var(--lm-text);
  cursor: pointer;
  white-space: nowrap;
  transition:
    background 0.18s ease,
    border-color 0.18s ease;
}

.login-code-btn:hover:not(:disabled) {
  background: var(--lm-ghost-hover);
  border-color: color-mix(in srgb, var(--lm-text) 28%, var(--lm-border));
}

.login-code-btn:focus-visible {
  outline: 2px solid var(--lm-focus);
  outline-offset: 2px;
}

.login-code-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.login-submit {
  margin-top: 0.35rem;
  height: 2.875rem;
  border: none;
  border-radius: 10px;
  background: var(--lm-cta-bg);
  color: var(--lm-cta-fg);
  font: inherit;
  font-size: 0.9375rem;
  font-weight: 600;
  letter-spacing: -0.02em;
  cursor: pointer;
  transition:
    background 0.18s var(--lm-ease),
    opacity 0.18s ease,
    transform 0.18s var(--lm-ease);
}

.login-submit:hover:not(:disabled) {
  background: var(--lm-cta-hover);
  transform: translateY(-1px);
}

.login-submit:active:not(:disabled) {
  transform: translateY(0);
}

.login-submit:focus-visible {
  outline: 2px solid var(--lm-focus);
  outline-offset: 2px;
}

.login-submit:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

html[data-theme='dark'] .login-field__input:-webkit-autofill,
html[data-theme='dark'] .login-field__input:-webkit-autofill:hover,
html[data-theme='dark'] .login-field__input:-webkit-autofill:focus {
  -webkit-text-fill-color: var(--lm-text);
  caret-color: var(--lm-text);
  box-shadow: 0 0 0 1000px var(--lm-input-bg) inset;
  transition: background-color 99999s ease-out;
}

.login-fade-enter-active,
.login-fade-leave-active {
  transition: opacity 0.28s var(--lm-ease);
}

.login-fade-enter-active .login-modal,
.login-fade-leave-active .login-modal {
  transition:
    transform 0.32s var(--lm-ease),
    opacity 0.28s ease;
}

.login-fade-enter-from,
.login-fade-leave-to {
  opacity: 0;
}

.login-fade-enter-from .login-modal,
.login-fade-leave-to .login-modal {
  transform: translateY(14px) scale(0.985);
  opacity: 0;
}

@media (prefers-reduced-motion: reduce) {
  .login-fade-enter-active,
  .login-fade-leave-active,
  .login-fade-enter-active .login-modal,
  .login-fade-leave-active .login-modal,
  .login-submit {
    transition: none !important;
  }

  .login-submit:hover:not(:disabled) {
    transform: none;
  }
}
</style>
