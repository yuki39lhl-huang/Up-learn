<script setup lang="ts">
/** 品牌标识：纯文字「升学通」（不再使用图片 Logo，避免裁切与突兀感） */
withDefaults(
  defineProps<{
    /** 兼容旧调用，文字模式下忽略 */
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
    <span class="brand-logo__text">升学通</span>
  </span>
</template>

<style scoped>
.brand-logo {
  display: inline-flex;
  align-items: center;
  user-select: none;
  line-height: 1;
}

.brand-logo__text {
  font-family:
    'PingFang SC',
    'Hiragino Sans GB',
    'Microsoft YaHei UI',
    'Microsoft YaHei',
    'Noto Sans SC',
    sans-serif;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: 0.14em;
  color: var(--st-on-surface, #151c27);
}

.brand-logo--landing .brand-logo__text {
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 0.12em;
  color: var(--apple-text, #1d1d1f);
}
</style>
