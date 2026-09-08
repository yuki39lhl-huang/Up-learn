<script setup lang="ts">
/**
 * 简易公式渲染：支持 $...$ / $$...$$（KaTeX）；纯文本保留换行。
 */
import { computed } from 'vue'
import katex from 'katex'
import 'katex/dist/katex.min.css'

const props = defineProps<{ text: string }>()

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}

const html = computed(() => {
  const raw = props.text ?? ''
  if (!raw) return ''
  try {
    const chunks: { type: 'text' | 'html'; value: string }[] = []
    const re = /\$\$([\s\S]+?)\$\$|\$([^$\n]+?)\$/g
    let last = 0
    let m: RegExpExecArray | null
    while ((m = re.exec(raw))) {
      if (m.index > last) chunks.push({ type: 'text', value: raw.slice(last, m.index) })
      const expr = (m[1] ?? m[2] ?? '').trim()
      const display = Boolean(m[1])
      try {
        chunks.push({
          type: 'html',
          value: katex.renderToString(expr, { throwOnError: false, displayMode: display }),
        })
      } catch {
        chunks.push({ type: 'text', value: expr })
      }
      last = m.index + m[0].length
    }
    if (last < raw.length) chunks.push({ type: 'text', value: raw.slice(last) })
    return chunks
      .map((c) => (c.type === 'html' ? c.value : escapeHtml(c.value).replace(/\n/g, '<br/>')))
      .join('')
  } catch {
    return escapeHtml(raw).replace(/\n/g, '<br/>')
  }
})
</script>

<template>
  <span class="math-text" v-html="html" />
</template>

<style scoped>
.math-text {
  line-height: 1.65;
  word-break: break-word;
}
.math-text :deep(.katex-display) {
  margin: 0.6em 0;
  overflow-x: auto;
}
</style>
