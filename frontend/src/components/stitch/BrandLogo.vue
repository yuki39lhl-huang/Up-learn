<script setup lang="ts">
withDefaults(
  defineProps<{
    /** 图标边长 px */
    size?: number
    showText?: boolean
    /** default 控制台；landing 官网顶栏 */
    variant?: 'default' | 'landing'
  }>(),
  {
    size: 28,
    showText: true,
    variant: 'default',
  },
)
</script>

<template>
  <span class="brand-logo" :class="[`brand-logo--${variant}`]" role="img" aria-label="升学通">
    <svg
      class="brand-logo__mark"
      :width="size"
      :height="size"
      viewBox="0 0 32 32"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      aria-hidden="true"
    >
      <rect width="32" height="32" rx="9" fill="currentColor" />
      <!-- 上升箭头：单色、线型，呼应「升」 -->
      <path
        d="M16 9.5v13"
        stroke="#fff"
        stroke-width="2"
        stroke-linecap="round"
      />
      <path
        d="M10.5 15 16 9.5 21.5 15"
        stroke="#fff"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
      <!-- 底部轻基线，稳住构图 -->
      <path
        d="M11 23.5h10"
        stroke="#fff"
        stroke-width="2"
        stroke-linecap="round"
        opacity="0.4"
      />
    </svg>
    <span v-if="showText" class="brand-logo__text">升学通</span>
  </span>
</template>

<style scoped>
.brand-logo {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: #3b82f6;
  user-select: none;
}

.brand-logo__mark {
  flex-shrink: 0;
  display: block;
}

.brand-logo__text {
  font-size: 17px;
  font-weight: 600;
  letter-spacing: 0.12em;
  line-height: 1;
  color: #334155;
}

.brand-logo--landing {
  color: #2563eb;
}

.brand-logo--landing .brand-logo__text {
  font-size: 16px;
  letter-spacing: 0.14em;
  color: var(--apple-text, #1d1d1f);
}
</style>
