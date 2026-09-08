<script setup lang="ts">
/**
 * 试卷预览弹层：只读卷面，可滚动；不含答案。
 */
import { computed, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import MathText from './MathText.vue'
import { fetchPaperDetail } from '../../api/papers'
import type { PaperDetailVO, PaperQuestionVO } from '../../types/api'
import { buildSheetSections, displayQuestionNo, sortBySeq } from '../../utils/paperSheet'

const props = defineProps<{
  open: boolean
  paperId: number | null
}>()

const emit = defineEmits<{
  close: []
  start: [paperId: number]
  download: [paperId: number]
}>()

const loading = ref(false)
const detail = ref<PaperDetailVO | null>(null)

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
  if (!props.paperId) {
    detail.value = null
    return
  }
  loading.value = true
  try {
    detail.value = await fetchPaperDetail(props.paperId)
  } catch (e) {
    detail.value = null
    ElMessage.error(e instanceof Error ? e.message : '预览加载失败')
  } finally {
    loading.value = false
  }
}

watch(
  () => [props.open, props.paperId] as const,
  ([open, id], prev) => {
    if (!open) return
    const prevOpen = prev?.[0]
    const prevId = prev?.[1]
    // 每次新开或换卷先清空，避免旧内容高度/标题闪一下再被替换
    if (!prevOpen || prevId !== id) {
      detail.value = null
    }
    void load()
  },
)

function onClose() {
  emit('close')
}

function onStart() {
  if (props.paperId != null) emit('start', props.paperId)
}

function onDownload() {
  if (props.paperId != null) emit('download', props.paperId)
}
</script>

<template>
  <Teleport to="body">
    <Transition name="preview-dlg">
      <div v-if="open" class="preview-dlg" role="dialog" aria-modal="true" aria-label="试卷预览">
        <div class="preview-dlg__mask" @click="onClose" />
        <div class="preview-dlg__panel">
          <header class="preview-dlg__head">
            <div class="preview-dlg__titles">
              <p class="preview-dlg__eyebrow">试卷预览</p>
              <h3>{{ detail?.title || '加载中…' }}</h3>
            </div>
            <div class="preview-dlg__actions">
              <button
                type="button"
                class="preview-btn"
                :disabled="!detail?.questions?.length"
                @click="onDownload"
              >
                下载 PDF
              </button>
              <button
                type="button"
                class="preview-btn preview-btn--primary"
                :disabled="!detail?.questions?.length"
                @click="onStart"
              >
                开始作答
              </button>
              <button type="button" class="preview-dlg__x" aria-label="关闭" @click="onClose">×</button>
            </div>
          </header>

          <div v-loading="loading" class="preview-dlg__scroll">
            <p v-if="!loading && !detail?.questions?.length" class="preview-empty">
              该卷尚无结构化题目，暂无法预览。
            </p>

            <article v-else-if="detail" class="preview-sheet">
              <header class="preview-sheet__head">
                <h1>《{{ detail.subject }}》</h1>
                <p>{{ detail.year }}年{{ detail.province }}专升本招生统一考试 · 升学通卷面</p>
                <p>（本试卷满分 {{ totalScore || '—' }} 分）</p>
              </header>

              <section v-for="sec in sections" :key="sec.key" class="preview-sec">
                <h2 v-if="sec.title">{{ sec.title }}</h2>
                <div
                  v-for="q in sec.items"
                  :key="q.id"
                  class="preview-q"
                  :class="{ 'preview-q--material': q.qType === 'material' }"
                >
                  <div class="preview-q__stem" :class="{ 'preview-q__stem--pre': q.qType === 'material' }">
                    <span v-if="questionNo(q) != null" class="preview-q__no">{{ questionNo(q) }}.</span>
                    <MathText :text="q.stem" />
                  </div>
                  <div v-if="q.qType === 'choice' && q.options?.length" class="preview-opts">
                    <div v-for="opt in q.options" :key="opt" class="preview-opt">
                      <span class="preview-opt__letter">{{ optionLetter(opt) }}.</span>
                      <MathText :text="optionBody(opt)" />
                    </div>
                  </div>
                  <p v-else-if="q.qType !== 'material'" class="preview-q__hint">
                    {{
                      detail?.subject === '高等数学' || detail?.subject?.includes('高等数学')
                        ? q.qType === 'fill'
                          ? '（填空，作答页交卷后显示参考答案；请用草稿纸作答）'
                          : '（请在草稿纸作答，交卷后显示参考答案）'
                        : q.qType === 'fill'
                          ? '（填空，作答页提供输入框）'
                          : '（写作/主观题，作答页提供输入框）'
                    }}
                  </p>
                </div>
              </section>

              <footer class="preview-sheet__foot">预览模式 · 不含参考答案</footer>
            </article>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.preview-dlg {
  position: fixed;
  inset: 0;
  z-index: 1200;
  display: grid;
  place-items: center;
  padding: 24px 16px;
}

.preview-dlg__mask {
  position: absolute;
  inset: 0;
  background: rgba(28, 25, 20, 0.48);
}

.preview-dlg__panel {
  position: relative;
  width: min(860px, 100%);
  /* 固定高度，避免首次加载内容时面板被撑开产生“拉伸”感 */
  height: min(88vh, 920px);
  max-height: min(88vh, 920px);
  display: flex;
  flex-direction: column;
  background: #f3f1ec;
  border-radius: 16px;
  box-shadow: 0 20px 48px rgba(0, 0, 0, 0.22);
  overflow: hidden;
}

.preview-dlg__head {
  flex-shrink: 0;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  background: #fff;
  border-bottom: 1px solid #e2ddd4;
}

.preview-dlg__eyebrow {
  margin: 0;
  font-size: 12px;
  color: #777;
}

.preview-dlg__titles h3 {
  margin: 2px 0 0;
  font-size: 16px;
  font-weight: 700;
}

.preview-dlg__actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.preview-btn {
  height: 34px;
  padding: 0 12px;
  border-radius: 8px;
  border: 1px solid #cfc9be;
  background: #fff;
  font: inherit;
  font-size: 13px;
  cursor: pointer;
}

.preview-btn--primary {
  border-color: transparent;
  background: #3d6b4f;
  color: #fff;
  font-weight: 600;
}

.preview-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.preview-dlg__x {
  width: 34px;
  height: 34px;
  border: none;
  border-radius: 8px;
  background: transparent;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  color: #666;
}

.preview-dlg__x:hover {
  background: #f0eee8;
}

.preview-dlg__scroll {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  padding: 16px;
  /* 给 loading 占位，避免空内容时视觉塌缩 */
  display: flex;
  flex-direction: column;
}

.preview-dlg__scroll :deep(.el-loading-mask) {
  border-radius: 0;
}

.preview-empty {
  margin: 48px 0;
  text-align: center;
  color: #666;
}

.preview-sheet {
  background: #fff;
  padding: 24px 28px 32px;
  border: 1px solid #ddd;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.preview-sheet__head {
  text-align: center;
  margin-bottom: 18px;
  padding-bottom: 12px;
  border-bottom: 1px solid #222;
}

.preview-sheet__head h1 {
  margin: 0;
  font-size: 20px;
  letter-spacing: 0.06em;
}

.preview-sheet__head p {
  margin: 6px 0 0;
  font-size: 13px;
  color: #444;
}

.preview-sec {
  margin-bottom: 16px;
}

.preview-sec h2 {
  margin: 0 0 10px;
  font-size: 14.5px;
  font-weight: 700;
}

.preview-q--material {
  margin-bottom: 16px;
  padding: 12px 14px;
  background: #faf9f6;
  border: 1px solid #e5e1d8;
  border-radius: 8px;
}

.preview-q__stem--pre {
  display: block;
  white-space: pre-wrap;
  line-height: 1.65;
  font-size: 13.5px;
}

.preview-q__stem {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 4px 6px;
  line-height: 1.7;
  font-size: 14px;
  margin-bottom: 6px;
}

.preview-q__no {
  font-weight: 600;
}

.preview-opts {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px 16px;
  padding-left: 1.3em;
}

@media (max-width: 640px) {
  .preview-opts {
    grid-template-columns: 1fr;
  }
}

.preview-opt {
  display: flex;
  align-items: baseline;
  gap: 6px;
  font-size: 13.5px;
  line-height: 1.55;
}

.preview-opt__letter {
  font-weight: 600;
  flex-shrink: 0;
}

.preview-q__hint {
  margin: 0 0 0 1.3em;
  font-size: 12px;
  color: #888;
}

.preview-sheet__foot {
  margin-top: 20px;
  padding-top: 10px;
  border-top: 1px dashed #ccc;
  text-align: center;
  font-size: 11px;
  color: #999;
}

.preview-dlg-enter-active,
.preview-dlg-leave-active {
  transition: opacity 0.2s ease;
}

.preview-dlg-enter-active .preview-dlg__panel,
.preview-dlg-leave-active .preview-dlg__panel {
  transition: transform 0.24s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.2s ease;
}

.preview-dlg-enter-from,
.preview-dlg-leave-to {
  opacity: 0;
}

.preview-dlg-enter-from .preview-dlg__panel,
.preview-dlg-leave-to .preview-dlg__panel {
  /* 仅位移淡入，避免 scale 叠加内容增长像拉伸 */
  transform: translateY(14px);
  opacity: 0;
}
</style>
