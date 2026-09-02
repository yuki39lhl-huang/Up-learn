<script setup lang="ts">
import { onUnmounted, watch } from 'vue'

const open = defineModel<boolean>({ default: false })

const props = withDefaults(
  defineProps<{
    title: string
    subtitle?: string
    confirmText?: string
    cancelText?: string
    loading?: boolean
    danger?: boolean
    width?: string
    nested?: boolean
  }>(),
  {
    confirmText: '确定',
    cancelText: '取消',
    loading: false,
    danger: false,
    width: '420px',
    nested: false,
  },
)

const emit = defineEmits<{
  confirm: []
  cancel: []
}>()

function lockScroll(lock: boolean) {
  document.body.style.overflow = lock ? 'hidden' : ''
}

watch(
  open,
  (visible) => lockScroll(visible),
  { immediate: true },
)

onUnmounted(() => lockScroll(false))

function onBackdrop(e: MouseEvent) {
  if (e.target === e.currentTarget) {
    emit('cancel')
    open.value = false
  }
}

function onCancel() {
  emit('cancel')
  open.value = false
}

function onConfirm() {
  emit('confirm')
}
</script>

<template>
  <Teleport to="body">
    <Transition name="stitch-dialog">
      <div
        v-if="open"
        class="stitch-dialog"
        :class="{ 'stitch-dialog--nested': nested }"
        role="dialog"
        aria-modal="true"
        @click="onBackdrop"
      >
        <div class="stitch-dialog__panel" :style="{ maxWidth: width }" @click.stop>
          <div class="stitch-dialog__glow" aria-hidden="true" />
          <header class="stitch-dialog__head">
            <div>
              <h3 class="stitch-dialog__title">{{ title }}</h3>
              <p v-if="subtitle" class="stitch-dialog__subtitle">{{ subtitle }}</p>
            </div>
            <button type="button" class="stitch-dialog__close" aria-label="关闭" @click="onCancel">
              ×
            </button>
          </header>

          <div v-if="$slots.default" class="stitch-dialog__body">
            <slot />
          </div>

          <footer v-if="$slots.footer || confirmText" class="stitch-dialog__foot">
            <slot name="footer">
              <button type="button" class="stitch-dialog__btn stitch-dialog__btn--ghost" @click="onCancel">
                {{ cancelText }}
              </button>
              <button
                type="button"
                class="stitch-dialog__btn"
                :class="danger ? 'stitch-dialog__btn--danger' : 'stitch-dialog__btn--primary'"
                :disabled="loading"
                @click="onConfirm"
              >
                <span v-if="loading" class="stitch-dialog__spinner" aria-hidden="true" />
                {{ confirmText }}
              </button>
            </slot>
          </footer>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.stitch-dialog {
  position: fixed;
  inset: 0;
  z-index: 3000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgb(15 23 42 / 36%);
  backdrop-filter: blur(6px);
}

.stitch-dialog__panel {
  position: relative;
  width: 100%;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(20px) saturate(1.4);
  -webkit-backdrop-filter: blur(20px) saturate(1.4);
  border: 1px solid rgba(255, 255, 255, 0.55);
  box-shadow:
    0 24px 48px rgb(15 23 42 / 14%),
    inset 0 1px 0 rgba(255, 255, 255, 0.7);
  overflow: visible;
}

.stitch-dialog__glow {
  position: absolute;
  inset: 0 0 auto;
  height: 120px;
  background: linear-gradient(135deg, rgb(34 197 94 / 10%), rgb(59 130 246 / 8%));
  pointer-events: none;
}

.stitch-dialog__head {
  position: relative;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding: 22px 22px 0;
}

.stitch-dialog__title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: var(--st-on-surface);
}

.stitch-dialog__subtitle {
  margin: 6px 0 0;
  font-size: 13px;
  line-height: 1.55;
  color: var(--st-on-surface-variant);
}

.stitch-dialog__close {
  flex-shrink: 0;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 10px;
  background: var(--st-surface-container-low);
  color: var(--st-on-surface-variant);
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  transition: background 0.15s, color 0.15s;
}

.stitch-dialog__close:hover {
  background: var(--st-surface-container);
  color: var(--st-on-surface);
}

.stitch-dialog__body {
  position: relative;
  padding: 16px 22px 4px;
}

.stitch-dialog__foot {
  position: relative;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 22px 22px;
}

.stitch-dialog__btn {
  min-width: 96px;
  height: 40px;
  padding: 0 18px;
  border-radius: 12px;
  border: none;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.12s, box-shadow 0.15s, background 0.15s;
}

.stitch-dialog__btn:active:not(:disabled) {
  transform: scale(0.98);
}

.stitch-dialog__btn:disabled {
  opacity: 0.65;
  cursor: not-allowed;
}

.stitch-dialog__btn--ghost {
  background: var(--st-surface-container-low);
  color: var(--st-on-surface-variant);
}

.stitch-dialog__btn--ghost:hover:not(:disabled) {
  background: var(--st-surface-container);
  color: var(--st-on-surface);
}

.stitch-dialog__btn--primary {
  background: linear-gradient(135deg, #22c55e, #16a34a);
  color: #fff;
  box-shadow: 0 8px 20px rgb(34 197 94 / 28%);
}

.stitch-dialog__btn--primary:hover:not(:disabled) {
  box-shadow: 0 10px 24px rgb(34 197 94 / 34%);
}

.stitch-dialog__btn--danger {
  background: linear-gradient(135deg, #f87171, #dc2626);
  color: #fff;
  box-shadow: 0 8px 20px rgb(220 38 38 / 22%);
}

.stitch-dialog__spinner {
  display: inline-block;
  width: 14px;
  height: 14px;
  margin-right: 6px;
  border: 2px solid rgb(255 255 255 / 35%);
  border-top-color: #fff;
  border-radius: 50%;
  vertical-align: -2px;
  animation: stitch-dialog-spin 0.7s linear infinite;
}

@keyframes stitch-dialog-spin {
  to {
    transform: rotate(360deg);
  }
}

.stitch-dialog-enter-active,
.stitch-dialog-leave-active {
  transition: opacity 0.2s ease;
}

.stitch-dialog-enter-active .stitch-dialog__panel,
.stitch-dialog-leave-active .stitch-dialog__panel {
  transition: transform 0.22s ease, opacity 0.22s ease;
}

.stitch-dialog-enter-from,
.stitch-dialog-leave-to {
  opacity: 0;
}

.stitch-dialog-enter-from .stitch-dialog__panel,
.stitch-dialog-leave-to .stitch-dialog__panel {
  transform: translateY(12px) scale(0.98);
  opacity: 0;
}
</style>
