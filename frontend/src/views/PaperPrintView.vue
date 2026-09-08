<script setup lang="ts">
/**
 * 打印专用卷面：浏览器「另存为 PDF」，公式由 KaTeX CSS 正常渲染，避免 html2canvas 糊乱。
 */
import { computed, nextTick, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import MathText from '../components/stitch/MathText.vue'
import { fetchPaperDetail } from '../api/papers'
import type { PaperDetailVO, PaperQuestionVO } from '../types/api'
import { buildSheetSections, displayQuestionNo, sortBySeq } from '../utils/paperSheet'
import 'katex/dist/katex.min.css'

const route = useRoute()
const loading = ref(true)
const detail = ref<PaperDetailVO | null>(null)
const errorMsg = ref('')

const paperId = computed(() => Number(route.params.id))
const autoPrint = computed(() => route.query.autoprint !== '0')

const totalScore = computed(() =>
  (detail.value?.questions ?? []).reduce((s, q) => s + (q.score || 0), 0),
)

const orderedQuestions = computed(() => sortBySeq(detail.value?.questions ?? []))
const sections = computed(() => buildSheetSections(detail.value?.questions ?? []))

function questionNo(q: PaperQuestionVO) {
  return displayQuestionNo(q, orderedQuestions.value)
}

function optionLetter(opt: string): string {
  const m = opt.trim().match(/^([A-Da-d])[.、．\s]/)
  return m ? m[1].toUpperCase() : opt.trim().charAt(0).toUpperCase()
}

function optionBody(opt: string): string {
  return opt.replace(/^[A-Da-d][.、．\s]+/, '').trim()
}

async function load() {
  if (!Number.isFinite(paperId.value) || paperId.value <= 0) {
    errorMsg.value = '无效试卷'
    loading.value = false
    return
  }
  loading.value = true
  try {
    detail.value = await fetchPaperDetail(paperId.value)
    document.title = `${detail.value?.title || '试卷'}-升学通卷面`
    if (!detail.value?.questions?.length) {
      errorMsg.value = '该卷尚无结构化题目'
      return
    }
    if (autoPrint.value) {
      await nextTick()
      // 等待 KaTeX / 字体
      await new Promise((r) => setTimeout(r, 400))
      window.print()
    }
  } catch (e) {
    errorMsg.value = e instanceof Error ? e.message : '加载失败'
    ElMessage.error(errorMsg.value)
  } finally {
    loading.value = false
  }
}

function doPrint() {
  window.print()
}

function doClose() {
  window.close()
}

onMounted(() => {
  void load()
})
</script>

<template>
  <div class="print-page">
    <div class="print-toolbar no-print">
      <p v-if="loading">正在生成卷面…</p>
      <p v-else-if="errorMsg" class="err">{{ errorMsg }}</p>
      <template v-else>
        <p>请在打印对话框中选择「另存为 PDF」或「Microsoft Print to PDF」。</p>
        <button type="button" class="btn" @click="doPrint">重新打印 / 另存 PDF</button>
        <button type="button" class="btn btn--ghost" @click="doClose">关闭</button>
      </template>
    </div>

    <article v-if="detail?.questions?.length" class="sheet">
      <header class="sheet__head">
        <h1>《{{ detail.subject }}》</h1>
        <p class="sheet__sub">
          {{ detail.year }}年{{ detail.province }}专升本招生统一考试 · 升学通卷面
        </p>
        <p class="sheet__meta">（本试卷满分 {{ totalScore }} 分。）</p>
      </header>

      <section v-for="sec in sections" :key="sec.key" class="sec">
        <h2 v-if="sec.title">{{ sec.title }}</h2>
        <div
          v-for="q in sec.items"
          :key="q.id"
          class="q"
          :class="{ 'q--material': q.qType === 'material' }"
        >
          <div class="q__stem" :class="{ 'q__stem--pre': q.qType === 'material' }">
            <span v-if="questionNo(q) != null" class="q__no">{{ questionNo(q) }}.</span>
            <MathText :text="q.stem" />
          </div>
          <div v-if="q.qType === 'choice' && q.options?.length" class="opts">
            <div v-for="opt in q.options" :key="opt" class="opt">
              <span class="opt__letter">{{ optionLetter(opt) }}.</span>
              <MathText :text="optionBody(opt)" />
            </div>
          </div>
        </div>
      </section>

      <footer class="sheet__foot">升学通 · 无水印练习卷面（非招生考试原件扫描）</footer>
    </article>
  </div>
</template>

<style scoped>
.print-page {
  min-height: 100vh;
  background: #e8e6e1;
  padding: 16px;
}

.print-toolbar {
  max-width: 800px;
  margin: 0 auto 16px;
  padding: 12px 14px;
  background: #fff;
  border-radius: 10px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.print-toolbar p {
  margin: 0;
  flex: 1;
  font-size: 13px;
  color: #444;
}

.print-toolbar .err {
  color: #b42318;
}

.btn {
  height: 34px;
  padding: 0 12px;
  border-radius: 8px;
  border: 1px solid #cfc9be;
  background: #3d6b4f;
  color: #fff;
  font: inherit;
  font-size: 13px;
  cursor: pointer;
}

.btn--ghost {
  background: #fff;
  color: #333;
}

.sheet {
  max-width: 800px;
  margin: 0 auto;
  background: #fff;
  padding: 28px 36px 40px;
  border: 1px solid #ddd;
  color: #1a1a1a;
  font-family: 'SimSun', 'Songti SC', 'Noto Serif SC', serif;
  font-size: 14px;
  line-height: 1.75;
}

.sheet__head {
  text-align: center;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #222;
}

.sheet__head h1 {
  margin: 0;
  font-size: 22px;
  letter-spacing: 0.08em;
}

.sheet__sub,
.sheet__meta {
  margin: 6px 0 0;
  font-size: 13px;
}

.sec {
  margin-bottom: 16px;
  break-inside: avoid;
}

.sec h2 {
  margin: 0 0 10px;
  font-size: 15px;
}

.q {
  margin-bottom: 12px;
  break-inside: avoid;
}

.q--material {
  margin: 10px 0 14px;
  padding: 10px 12px;
  background: #faf9f6;
  border: 1px solid #e5e1d8;
}

.q__stem {
  margin-bottom: 6px;
}

.q__stem--pre {
  white-space: pre-wrap;
  line-height: 1.65;
  font-size: 13.5px;
}

.q__no {
  font-weight: 700;
  margin-right: 4px;
}

.opts {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px 18px;
  padding-left: 1.3em;
}

.opt {
  display: flex;
  align-items: baseline;
  gap: 6px;
}

.opt__letter {
  font-weight: 600;
  flex-shrink: 0;
}

.sheet__foot {
  margin-top: 24px;
  padding-top: 10px;
  border-top: 1px dashed #ccc;
  text-align: center;
  font-size: 11px;
  color: #888;
}

@media print {
  .no-print {
    display: none !important;
  }
  .print-page {
    background: #fff;
    padding: 0;
  }
  .sheet {
    max-width: none;
    border: none;
    box-shadow: none;
    padding: 12mm 14mm;
  }
}
</style>
