<script setup lang="ts">
/**
 * 品牌标识：透明底图标 + 网页字标「升学通」。
 * 图标：/brand/logo-mark.png；字标后续可换字体。
 */
import { computed } from 'vue'

const props = withDefaults(
  defineProps<{
    /** 图标高度（px） */
    size?: number
    showText?: boolean
    /** default 控制台；landing 官网顶栏 */
    variant?: 'default' | 'landing'
  }>(),
  {
    size: 40,
    showText: true,
    variant: 'default',
  },
)

/** 字标随图标放大，避免图标大字却小 */
const textSize = computed(() => Math.round(props.size * (props.variant === 'landing' ? 0.42 : 0.45)))
</script>

<template>
  <span class="brand-logo" :class="[`brand-logo--${variant}`]" role="img" aria-label="升学通">
    <img
      class="brand-logo__mark"
      src="/brand/logo-mark.png?v=5"
      alt=""
      :style="{ height: `${size}px`, width: `${size}px` }"
      draggable="false"
    />
    <span
      v-if="showText"
      class="brand-logo__text"
      :style="{ fontSize: `${textSize}px` }"
    >升学通</span>
  </span>
</template>

<style scoped>
.brand-logo {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  user-select: none;
  line-height: 1;
}

.brand-logo__mark {
  display: block;
  flex-shrink: 0;
  object-fit: contain;
  /* 去掉贴图感：不设底色、不设圆角底板 */
  background: transparent;
}

.brand-logo__text {
  font-family:
    'PingFang SC',
    'Hiragino Sans GB',
    'Microsoft YaHei UI',
    'Microsoft YaHei',
    'Noto Sans SC',
    sans-serif;
  font-weight: 650;
  letter-spacing: 0.1em;
  color: var(--st-on-surface, #151c27);
  white-space: nowrap;
}

.brand-logo--landing .brand-logo__text {
  letter-spacing: 0.08em;
  color: var(--apple-text, #1d1d1f);
}
</style>
