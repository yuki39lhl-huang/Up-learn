<script setup lang="ts">
/**
 * 简易公式渲染：支持 $...$ / $$...$$（KaTeX）；纯文本保留换行。
 */
import { computed } from 'vue'
import { renderMathHtml } from '../../utils/renderMath'

const props = defineProps<{ text: string }>()

const html = computed(() => renderMathHtml(props.text ?? '', { lineBreaks: true }))
</script>

<template>
  <span class="math-text" v-html="html" />
</template>

<style scoped>
.math-text {
  line-height: 1.65;
  word-break: break-word;
  color: inherit;
}
.math-text :deep(.katex),
.math-text :deep(.katex .mord) {
  color: inherit;
}
.math-text :deep(.katex-display) {
  margin: 0.6em 0;
  overflow-x: auto;
}
</style>
