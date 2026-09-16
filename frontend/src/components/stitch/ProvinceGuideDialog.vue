<script setup lang="ts">
/**
 * 省份报考前言弹框：只读 Markdown（复用试卷预览遮罩交互）。
 */
import { computed, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { renderGuideMarkdown } from '../../utils/renderGuideMarkdown'

type GuideTab = 'guide' | 'schools' | 'majors'

const props = defineProps<{
  open: boolean
  /** 目前仅广东有内容 */
  province?: string
}>()

const emit = defineEmits<{
  close: []
}>()

const loading = ref(false)
const activeTab = ref<GuideTab>('guide')
/** 预渲染 HTML，切换 Tab 时不先清空，避免闪一下 */
const htmlByTab = ref<Partial<Record<GuideTab, string>>>({})

const tabs: { id: GuideTab; label: string; file: string }[] = [
  { id: 'guide', label: '报考指南', file: 'guide.md' },
  { id: 'schools', label: '在招院校', file: 'schools.md' },
  { id: 'majors', label: '统考对照', file: 'majors.md' },
]

const supported = computed(() => (props.province || '广东') === '广东')

const displayHtml = computed(() => htmlByTab.value[activeTab.value] ?? '')

async function loadTab(tab: GuideTab) {
  if (htmlByTab.value[tab]) return
  const meta = tabs.find((t) => t.id === tab)
  if (!meta) return
  try {
    const res = await fetch(`/guides/guangdong/${meta.file}`)
    if (!res.ok) throw new Error(`加载失败（${res.status}）`)
    const raw = await res.text()
    htmlByTab.value = { ...htmlByTab.value, [tab]: renderGuideMarkdown(raw) }
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '前言加载失败')
  }
}

async function preloadAllTabs() {
  if (!supported.value) return
  loading.value = true
  try {
    await Promise.all(tabs.map((t) => loadTab(t.id)))
  } finally {
    loading.value = false
  }
}

watch(
  () => props.open,
  (open) => {
    if (!open) return
    activeTab.value = 'guide'
    void preloadAllTabs()
  },
)

function onClose() {
  emit('close')
}
</script>

<template>
  <Teleport to="body">
    <Transition name="preview-dlg">
      <div v-if="open" class="preview-dlg" role="dialog" aria-modal="true" aria-label="报考前言">
        <div class="preview-dlg__mask" @click="onClose" />
        <div class="preview-dlg__panel">
          <header class="preview-dlg__head">
            <div class="preview-dlg__titles">
              <p class="preview-dlg__eyebrow">{{ province || '广东' }} · 报考前言</p>
              <h3>普通专升本说明</h3>
            </div>
            <button type="button" class="preview-dlg__close" aria-label="关闭" @click="onClose">×</button>
          </header>

          <div v-if="supported" class="guide-tabs">
            <button
              v-for="t in tabs"
              :key="t.id"
              type="button"
              class="guide-tabs__btn"
              :class="{ 'guide-tabs__btn--active': activeTab === t.id }"
              @click="activeTab = t.id"
            >
              {{ t.label }}
            </button>
          </div>

          <div
            v-loading="loading && !displayHtml"
            class="preview-dlg__body guide-body"
            element-loading-background="rgba(247, 245, 240, 0.85)"
          >
            <p v-if="!supported" class="guide-empty">当前省份前言内容尚未录入，敬请期待。</p>
            <div v-else-if="displayHtml" class="guide-md" v-html="displayHtml" />
            <p v-else-if="!loading" class="guide-empty">暂无内容</p>
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
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px 16px;
}

.preview-dlg__mask {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
}

.preview-dlg__panel {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  width: min(920px, 100%);
  max-height: min(88vh, 900px);
  border-radius: 16px;
  background: var(--ul-doc-dlg-bg);
  box-shadow: 0 24px 64px rgba(15, 23, 42, 0.28);
  overflow: hidden;
}

.preview-dlg__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding: 16px 20px 12px;
  border-bottom: 1px solid rgba(15, 23, 42, 0.08);
  background: var(--st-surface);
}

.preview-dlg__eyebrow {
  margin: 0 0 4px;
  font-size: 12px;
  color: #64748b;
}

.preview-dlg__titles h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: var(--st-on-surface);
}

.preview-dlg__close {
  border: none;
  background: transparent;
  font-size: 28px;
  line-height: 1;
  color: #64748b;
  cursor: pointer;
  padding: 0 4px;
}

.guide-tabs {
  display: flex;
  gap: 6px;
  padding: 10px 16px 0;
  background: var(--st-surface);
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}

.guide-tabs__btn {
  border: none;
  background: transparent;
  padding: 8px 14px;
  font: inherit;
  font-size: 13px;
  color: #64748b;
  border-radius: 8px 8px 0 0;
  cursor: pointer;
}

.guide-tabs__btn--active {
  color: #2f5a3f;
  font-weight: 650;
  background: #f7f5f0;
  box-shadow: inset 0 -2px 0 #3d6b4f;
}

.preview-dlg__body {
  flex: 1;
  overflow: auto;
  padding: 16px 20px 28px;
  min-height: 200px;
}

.guide-empty {
  margin: 24px 0;
  text-align: center;
  color: #64748b;
}

.guide-md :deep(h1) {
  margin: 0 0 12px;
  font-size: 22px;
  color: var(--st-on-surface);
}

.guide-md :deep(h2) {
  margin: 20px 0 10px;
  font-size: 17px;
  color: #1e293b;
}

.guide-md :deep(h3) {
  margin: 16px 0 8px;
  font-size: 15px;
}

.guide-md :deep(p) {
  margin: 0 0 10px;
  line-height: 1.65;
  color: #334155;
  font-size: 14px;
}

.guide-md :deep(blockquote) {
  margin: 12px 0;
  padding: 10px 14px;
  border-left: 3px solid #3d6b4f;
  background: rgba(61, 107, 79, 0.08);
  border-radius: 0 8px 8px 0;
}

.guide-md :deep(blockquote p) {
  margin: 0 0 6px;
}

.guide-md :deep(ul),
.guide-md :deep(ul),
.guide-md :deep(ol) {
  margin: 0 0 12px;
  padding-left: 1.35em;
  color: var(--ul-doc-md-fg);
  font-size: 14px;
  line-height: 1.6;
}

.guide-md :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 12px 0 16px;
  font-size: 13px;
  background: var(--st-surface);
}

.guide-md :deep(th),
.guide-md :deep(td) {
  border: 1px solid var(--ul-doc-md-table-border);
  padding: 8px 10px;
  text-align: left;
  vertical-align: top;
}

.guide-md :deep(th) {
  background: var(--ul-doc-md-table-head);
  font-weight: 650;
  color: var(--ul-doc-md-heading);
}

.guide-md :deep(hr) {
  border: none;
  border-top: 1px solid var(--ul-doc-md-table-border);
  margin: 16px 0;
}

.guide-md :deep(strong) {
  color: var(--ul-doc-blockquote-strong);}
</style>