<script setup lang="ts">
/**
 * 历年真题：省 → 科目 → 年份试卷列表；下载 PDF / 作答（默认新标签页）。
 */
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchPaperList, fetchPaperOptions } from '../../api/papers'
import { useExamPrefsStore } from '../../stores/examPrefs'
import type { PaperListItemVO, PaperOptionItem } from '../../types/api'
import { downloadPaperAsPdf } from '../../utils/exportExamPdf'
import PaperPreviewDialog from './PaperPreviewDialog.vue'

const router = useRouter()
const examPrefs = useExamPrefsStore()

const ready = ref(false)
const loadingOptions = ref(false)
const loadingList = ref(false)
const provinces = ref<string[]>([])
const items = ref<PaperOptionItem[]>([])
const papers = ref<PaperListItemVO[]>([])

const province = ref('广东')
const subject = ref('')
const subjectsExpanded = ref(true)

const previewOpen = ref(false)
const previewPaperId = ref<number | null>(null)

const subjects = computed(() =>
  items.value.filter((it) => it.province === province.value).map((it) => it.subject),
)

const subjectsToggleLabel = computed(() => {
  const n = subjects.value.length
  if (n === 0) return '科目'
  return subjectsExpanded.value ? `收起科目（${n}）` : `展开科目（${n}）`
})

function pickPreferredSubject(list: string[]): string {
  if (!list.length) return ''
  const prefs = examPrefs.examSubjects ?? []
  for (const name of prefs) {
    if (list.includes(name)) return name
  }
  const aliases: Record<string, string[]> = {
    高等数学: ['高等数学', '高等数学I', '高等数学II'],
    英语: ['英语', '大学英语'],
    政治: ['政治', '政治理论'],
  }
  for (const pref of prefs) {
    for (const [k, vs] of Object.entries(aliases)) {
      if (pref.includes(k) || vs.includes(pref)) {
        for (const v of vs) {
          if (list.includes(v)) return v
        }
      }
    }
  }
  return list[0]
}

function syncSubject() {
  const list = subjects.value
  subjectsExpanded.value = list.length <= 8
  if (!list.length) {
    subject.value = ''
    return
  }
  if (!list.includes(subject.value)) {
    subject.value = pickPreferredSubject(list)
  }
}

async function loadOptions() {
  loadingOptions.value = true
  try {
    const vo = await fetchPaperOptions()
    provinces.value = vo.provinces?.length ? vo.provinces : []
    items.value = vo.items ?? []
    const pref = examPrefs.prefs.province?.trim()
    if (pref && provinces.value.includes(pref)) {
      province.value = pref
    } else {
      province.value = provinces.value[0] ?? ''
    }
    syncSubject()
    ready.value = true
    await loadList()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '真题选项加载失败')
  } finally {
    loadingOptions.value = false
  }
}

async function loadList() {
  if (!ready.value || !province.value || !subject.value) {
    papers.value = []
    return
  }
  loadingList.value = true
  try {
    papers.value = await fetchPaperList({ province: province.value, subject: subject.value })
  } catch (e) {
    papers.value = []
    ElMessage.error(e instanceof Error ? e.message : '试卷列表加载失败')
  } finally {
    loadingList.value = false
  }
}

function onProvince(p: string) {
  province.value = p
  syncSubject()
  void loadList()
}

function onSubject(s: string) {
  subject.value = s
  void loadList()
}

/** 作答默认新标签页；弹窗被拦时回退当前页 */
function openExam(paperId: number, query?: Record<string, string>) {
  const href = router.resolve({
    name: 'paper-exam',
    params: { id: String(paperId) },
    query,
  }).href
  const win = window.open(href, '_blank')
  if (!win) {
    void router.push({ name: 'paper-exam', params: { id: String(paperId) }, query })
  }
}

const downloadingId = ref<number | null>(null)

/** 当前页直接生成并下载 PDF，不跳转、不弹打印框 */
async function onDownload(row: PaperListItemVO) {
  if (row.questionCount <= 0) {
    ElMessage.warning('该卷尚无结构化题目，无法生成无水印卷面 PDF')
    return
  }
  if (downloadingId.value != null) return
  downloadingId.value = row.id
  const loading = ElMessage({ message: '正在生成 PDF…', type: 'info', duration: 0 })
  try {
    await downloadPaperAsPdf(row.id)
    ElMessage.success('PDF 已开始下载')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : 'PDF 生成失败')
  } finally {
    loading.close()
    downloadingId.value = null
  }
}

function onPreview(row: PaperListItemVO) {
  if (row.questionCount <= 0) {
    ElMessage.warning('该卷尚无结构化题目，暂无法预览')
    return
  }
  previewPaperId.value = row.id
  previewOpen.value = true
}

function closePreview() {
  previewOpen.value = false
}

function startFromPreview(paperId: number) {
  closePreview()
  openExam(paperId)
}

async function downloadFromPreview(paperId: number) {
  if (downloadingId.value != null) return
  downloadingId.value = paperId
  const loading = ElMessage({ message: '正在生成 PDF…', type: 'info', duration: 0 })
  try {
    await downloadPaperAsPdf(paperId)
    ElMessage.success('PDF 已开始下载')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : 'PDF 生成失败')
  } finally {
    loading.close()
    downloadingId.value = null
  }
}

watch(
  () => examPrefs.prefs.province,
  (p) => {
    if (!ready.value || !p) return
    if (provinces.value.includes(p) && province.value !== p) {
      onProvince(p)
    }
  },
)

onMounted(() => {
  void loadOptions()
})
</script>

<template>
  <div class="module-shell">
    <section class="module-card papers-card">
      <header class="module-card__head papers-card__head">
        <div>
          <p class="module-card__eyebrow">升学通 · 真题中心</p>
          <h2>历年真题</h2>
        </div>
        <div class="papers-filters">
          <div class="papers-provinces" role="tablist">
            <button
              v-for="p in provinces"
              :key="p"
              type="button"
              class="papers-chip"
              :class="{ 'papers-chip--on': province === p }"
              @click="onProvince(p)"
            >
              {{ p }}
            </button>
          </div>
        </div>
      </header>

      <div v-loading="loadingOptions || loadingList" class="papers-body">
        <div v-if="subjects.length" class="papers-subjects-bar">
          <button type="button" class="papers-subjects-toggle" @click="subjectsExpanded = !subjectsExpanded">
            {{ subjectsToggleLabel }}
          </button>
          <div class="papers-subjects-grid" :class="{ 'papers-subjects-grid--open': subjectsExpanded }">
            <div class="papers-subjects-grid__inner">
              <button
                v-for="s in subjects"
                :key="s"
                type="button"
                class="papers-chip papers-chip--subject"
                :class="{ 'papers-chip--on': subject === s }"
                @click="onSubject(s)"
              >
                {{ s }}
              </button>
            </div>
          </div>
        </div>

        <p v-if="!loadingOptions && !subjects.length" class="papers-empty">该省暂无已入库真题</p>

        <ul v-else class="papers-list">
          <li v-for="row in papers" :key="row.id" class="papers-row">
            <div class="papers-row__main">
              <span class="papers-row__year">{{ row.year }}</span>
              <div>
                <h3 class="papers-row__title">{{ row.title }}</h3>
                <p class="papers-row__meta">
                  <span v-if="row.questionCount > 0">可在线作答 · {{ row.questionCount }} 题</span>
                  <span v-else>在线题目待录入</span>
                  <span v-if="row.questionCount > 0 && row.hasAnswer"> · 含参考答案（主观题自批）</span>
                  <span v-else-if="row.questionCount > 0"> · 参考答案陆续补充</span>
                </p>
              </div>
            </div>
            <div class="papers-row__actions">
              <el-button
                :disabled="row.questionCount <= 0"
                @click="onPreview(row)"
              >
                预览试卷
              </el-button>
              <el-button
                :disabled="row.questionCount <= 0 || downloadingId === row.id"
                :loading="downloadingId === row.id"
                @click="onDownload(row)"
              >
                下载 PDF
              </el-button>
            </div>
          </li>
          <li v-if="!loadingList && papers.length === 0" class="papers-empty">该科目暂无试卷</li>
        </ul>
      </div>
    </section>

    <PaperPreviewDialog
      :open="previewOpen"
      :paper-id="previewPaperId"
      @close="closePreview"
      @start="startFromPreview"
      @download="downloadFromPreview"
    />
  </div>
</template>

<style scoped>
.papers-card__head {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
}

.papers-provinces,
.papers-subjects-grid__inner {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.papers-chip {
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 70%, transparent);
  background: transparent;
  color: var(--st-on-surface-variant);
  border-radius: 999px;
  padding: 6px 14px;
  font: inherit;
  font-size: 13px;
  cursor: pointer;
}

.papers-chip--on {
  background: var(--st-secondary-container);
  color: var(--st-on-secondary-container);
  border-color: transparent;
  font-weight: 600;
}

.papers-subjects-bar {
  margin-bottom: 16px;
}

.papers-subjects-toggle {
  border: none;
  background: none;
  color: var(--st-primary);
  font: inherit;
  font-size: 13px;
  cursor: pointer;
  padding: 0 0 8px;
}

.papers-subjects-grid {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 0.22s ease;
}

.papers-subjects-grid--open {
  grid-template-rows: 1fr;
}

.papers-subjects-grid__inner {
  overflow: hidden;
}

.papers-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.papers-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 12px;
  background: color-mix(in srgb, var(--st-surface-container-low) 80%, transparent);
}

.papers-row__main {
  display: flex;
  gap: 14px;
  align-items: flex-start;
  min-width: 0;
}

.papers-row__year {
  flex-shrink: 0;
  font-size: 22px;
  font-weight: 700;
  color: var(--st-primary);
  line-height: 1.2;
  min-width: 3.2em;
}

.papers-row__title {
  margin: 0 0 4px;
  font-size: 15px;
  font-weight: 600;
}

.papers-row__meta {
  margin: 0;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.papers-row__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.papers-empty {
  margin: 24px 0;
  text-align: center;
  color: var(--st-on-surface-variant);
  font-size: 14px;
}

.papers-body {
  min-height: 200px;
}
</style>
