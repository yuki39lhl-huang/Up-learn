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
  <span class="brand-logo" :class="[`brand-logo--${variant}`]">
    <svg
      class="brand-logo__mark"
      :width="size"
      :height="size"
      viewBox="0 0 32 32"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      aria-hidden="true"
    >
      <!-- 三级阶梯：象征升学进阶 -->
      <rect x="3" y="21" width="9" height="8" rx="2.5" fill="#22C55E" />
      <rect x="11.5" y="13" width="9" height="16" rx="2.5" fill="#0071E3" />
      <rect x="20" y="5" width="9" height="24" rx="2.5" fill="#0058BE" />
      <!-- 上升轨迹 -->
      <path
        d="M7.5 19.5 16 11 24.5 7"
        stroke="#fff"
        stroke-width="1.75"
        stroke-linecap="round"
        stroke-linejoin="round"
        opacity="0.9"
      />
      <path
        d="M21.5 7 24.5 7 24.5 10"
        stroke="#fff"
        stroke-width="1.75"
        stroke-linecap="round"
        stroke-linejoin="round"
        opacity="0.9"
      />
    </svg>
    <span v-if="showText" class="brand-logo__text">
      <span class="brand-logo__name">升学</span><span class="brand-logo__accent">通</span>
    </span>
  </span>
</template>

<style scoped>
.brand-logo {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  user-select: none;
}

.brand-logo__mark {
  flex-shrink: 0;
  filter: drop-shadow(0 2px 6px rgb(0 88 190 / 22%));
}

.brand-logo__text {
  display: inline-flex;
  align-items: baseline;
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 1;
}

.brand-logo--default .brand-logo__text {
  font-size: 20px;
  color: var(--st-on-surface, #1d1d1f);
}

.brand-logo--landing .brand-logo__text {
  font-size: 17px;
  color: var(--apple-text, #1d1d1f);
}

.brand-logo__name {
  color: inherit;
}

.brand-logo__accent {
  color: #0058be;
}
</style>
