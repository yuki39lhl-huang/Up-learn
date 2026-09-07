<script setup lang="ts">
/**
 * 考纲查询：省 + 最新年（只读）+ 科目 Chip 列表。
 */
import { computed, nextTick, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchSyllabusDetail, fetchSyllabusOptions } from '../../api/syllabus'
import { useExamPrefsStore } from '../../stores/examPrefs'
import SyllabusScopeTree from './SyllabusScopeTree.vue'
import type { SyllabusOptionItem, SyllabusVO } from '../../types/api'

type ContentTab = 'scope' | 'references'

const examPrefs = useExamPrefsStore()

const ready = ref(false)
const loadingOptions = ref(false)
const loadingDetail = ref(false)
const provinces = ref<string[]>(['广东', '山东'])
const items = ref<SyllabusOptionItem[]>([])

const province = ref('广东')
const year = ref<number | undefined>()
const subject = ref('')
const contentTab = ref<ContentTab>('scope')
const detail = ref<SyllabusVO | null>(null)
const docScrollRef = ref<HTMLElement | null>(null)
/** 科目标签展开；科目多时默认收起，省正文高度 */
const subjectsExpanded = ref(false)

function scrollDocToTop() {
  nextTick(() => {
    if (docScrollRef.value) docScrollRef.value.scrollTop = 0
  })
}

function syncSubjectsExpandDefault() {
  subjectsExpanded.value = subjects.value.length <= 6
}

/** 该省已有考纲中的最新年份 */
const latestYear = computed(() => {
  let max: number | undefined
  for (const it of items.value) {
    if (it.province !== province.value) continue
    if (max == null || it.year > max) max = it.year
  }
  return max
})

const subjects = computed(() => {
  if (year.value == null) return [] as string[]
  return items.value
    .filter((it) => it.province === province.value && it.year === year.value)
    .map((it) => it.subject)
})

const hasDesignatedWorks = computed(
  () => (detail.value?.designatedWorks?.length ?? 0) > 0,
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
  return list[0]
}

function syncLatestYearAndSubject() {
  year.value = latestYear.value
  const list = subjects.value
  if (!list.length) {
    subject.value = ''
    syncSubjectsExpandDefault()
    return
  }
  if (!list.includes(subject.value)) {
    subject.value = pickPreferredSubject(list)
  }
  syncSubjectsExpandDefault()
}

async function loadOptions() {
  loadingOptions.value = true
  try {
    const vo = await fetchSyllabusOptions()
    provinces.value = vo.provinces?.length ? vo.provinces : ['广东', '山东']
    items.value = vo.items ?? []
    const pref = examPrefs.prefs.province?.trim()
    if (pref && provinces.value.includes(pref)) {
      province.value = pref
    } else {
      province.value = provinces.value[0] ?? '广东'
    }
    syncLatestYearAndSubject()
    ready.value = true
    await loadDetail()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '考纲选项加载失败')
  } finally {
    loadingOptions.value = false
  }
}

async function loadDetail() {
  if (!ready.value) return
  if (!province.value || year.value == null || !subject.value) {
    detail.value = null
    return
  }
  loadingDetail.value = true
  contentTab.value = 'scope'
  try {
    detail.value = await fetchSyllabusDetail({
      province: province.value,
      year: year.value,
      subject: subject.value,
    })
  } catch (e) {
    detail.value = null
    ElMessage.error(e instanceof Error ? e.message : '考纲加载失败')
  } finally {
    loadingDetail.value = false
    scrollDocToTop()
  }
}

function onProvinceChange() {
  syncLatestYearAndSubject()
  void loadDetail()
}

function selectSubject(s: string) {
  if (subject.value === s) return
  subject.value = s
  void loadDetail()
}

onMounted(() => {
  void loadOptions()
})
</script>

<template>
  <!-- 顶栏标题 + 筛选/科目固定；仅正文区独立滚动 -->
  <div class="module-shell module-shell--fill">
    <section class="module-card module-card--fill">
      <header class="module-card__head">
        <div>
          <p class="module-card__eyebrow">升学通 · 考纲中心</p>
          <h2>考试要求</h2>
        </div>
      </header>

      <div class="syllabus-toolbar">
        <div class="syllabus-filters">
          <label class="syllabus-field">
            <span>省份</span>
            <el-select
              v-model="province"
              :disabled="loadingOptions"
              placeholder="选择省份"
              @change="onProvinceChange"
            >
              <el-option v-for="p in provinces" :key="p" :label="p" :value="p" />
            </el-select>
          </label>

          <div class="syllabus-field">
            <span>考纲年份</span>
            <div class="syllabus-year" aria-live="polite">
              <template v-if="year != null">
                <strong>{{ year }}</strong>
                <em>最新</em>
              </template>
              <span v-else class="syllabus-year__empty">暂无</span>
            </div>
          </div>

          <div class="syllabus-field syllabus-field--action">
            <span>科目标签</span>
            <button
              type="button"
              class="syllabus-subjects-toggle"
              :disabled="subjects.length === 0"
              :aria-expanded="subjectsExpanded"
              @click="subjectsExpanded = !subjectsExpanded"
            >
              {{ subjectsToggleLabel }}
              <span class="syllabus-subjects-toggle__chevron" :class="{ 'is-open': subjectsExpanded }"
                >▾</span
              >
            </button>
          </div>
        </div>

        <div
          class="syllabus-subjects-clip"
          :class="{ 'is-open': subjectsExpanded }"
          :aria-hidden="!subjectsExpanded"
        >
          <div class="syllabus-subjects-clip__inner">
            <div class="syllabus-subjects" aria-label="科目列表">
              <button
                v-for="s in subjects"
                :key="s"
                type="button"
                class="syllabus-subject-chip"
                :class="{ 'is-active': subject === s }"
                :tabindex="subjectsExpanded ? 0 : -1"
                @click="selectSubject(s)"
              >
                {{ s }}
              </button>
              <p v-if="subjects.length === 0" class="syllabus-subjects__hint">该省暂无考纲科目</p>
            </div>
          </div>
        </div>
      </div>

      <div v-loading="loadingDetail" class="syllabus-doc">
        <template v-if="detail">
          <header class="syllabus-doc__head">
            <div class="syllabus-doc__title-row">
              <span class="syllabus-doc__subject" aria-current="true">{{ detail.subject }}</span>
            </div>
            <p v-if="detail.sourceTitle" class="syllabus-doc__source">{{ detail.sourceTitle }}</p>
          </header>

          <nav class="syllabus-tabs" aria-label="考纲章节">
            <button
              type="button"
              class="syllabus-tab"
              :class="{ 'is-active': contentTab === 'scope' }"
              @click="contentTab = 'scope'"
            >
              考试范围
            </button>
            <button
              type="button"
              class="syllabus-tab"
              :class="{ 'is-active': contentTab === 'references' }"
              @click="contentTab = 'references'"
            >
              参考书目
            </button>
          </nav>

          <div ref="docScrollRef" class="syllabus-doc__scroll">
            <div v-show="contentTab === 'scope'" class="syllabus-scope">
              <SyllabusScopeTree :blocks="detail.scope?.blocks ?? []" />
            </div>

            <div v-show="contentTab === 'references'" class="syllabus-refs">
              <h3 class="syllabus-section-title">参考书目</h3>
              <ul v-if="detail.references?.length" class="syllabus-ref-list">
                <li v-for="(book, idx) in detail.references" :key="idx" class="syllabus-ref-item">
                  <div class="syllabus-ref-item__title">《{{ book.title }}》</div>
                  <div class="syllabus-ref-item__meta">
                    <span v-if="book.editors">{{ book.editors }}</span>
                    <span v-if="book.edition">{{ book.edition }}</span>
                    <span v-if="book.publisher">{{ book.publisher }}</span>
                    <span v-if="book.publishedAt">{{ book.publishedAt }}</span>
                  </div>
                  <p v-if="book.note" class="syllabus-ref-item__note">{{ book.note }}</p>
                </li>
              </ul>
              <p v-else class="syllabus-empty-inline">暂无参考书目</p>

              <template v-if="hasDesignatedWorks">
                <h3 class="syllabus-section-title">指定篇目</h3>
                <ol class="syllabus-works">
                  <li v-for="work in detail.designatedWorks" :key="work.seq" :value="work.seq">
                    <span class="syllabus-works__title">{{ work.title }}</span>
                    <span v-if="work.authorOrSource" class="syllabus-works__src"
                      >（{{ work.authorOrSource }}）</span
                    >
                  </li>
                </ol>
              </template>
            </div>
          </div>
        </template>

        <div v-else-if="!loadingDetail && ready" class="syllabus-empty">
          <p>暂无该省考纲</p>
          <small>一期已收录广东 2026（27 科）与山东 2025（英语/政治/计算机/大学语文/高等数学I/II）考纲。</small>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.syllabus-toolbar {
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(15, 23, 42, 0.08);
}

.syllabus-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 16px;
  align-items: flex-end;
}

.syllabus-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-size: 12px;
  color: #64748b;
}

.syllabus-field :deep(.el-select) {
  width: 140px;
}

.syllabus-year {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 32px;
  padding: 0 4px;
  color: #0f172a;
}

.syllabus-year strong {
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 0.02em;
}

.syllabus-year em {
  font-style: normal;
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 4px;
  background: rgba(15, 118, 110, 0.1);
  color: #0f766e;
}

.syllabus-year__empty {
  font-size: 13px;
  color: #94a3b8;
}

.syllabus-field--action {
  min-width: 0;
}

.syllabus-subjects-toggle {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 32px;
  padding: 0 12px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  border-radius: 8px;
  background: #fff;
  color: #0f766e;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s;
}

.syllabus-subjects-toggle:hover:not(:disabled) {
  border-color: rgba(15, 118, 110, 0.45);
  background: rgba(15, 118, 110, 0.06);
}

.syllabus-subjects-toggle:disabled {
  color: #94a3b8;
  cursor: not-allowed;
}

.syllabus-subjects-toggle__chevron {
  display: inline-block;
  font-size: 12px;
  line-height: 1;
  transition: transform 0.18s ease;
}

.syllabus-subjects-toggle__chevron.is-open {
  transform: rotate(180deg);
}

.syllabus-subjects-clip {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 0.28s ease;
}

.syllabus-subjects-clip.is-open {
  grid-template-rows: 1fr;
}

.syllabus-subjects-clip__inner {
  overflow: hidden;
  min-height: 0;
}

.syllabus-subjects {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 2px 0 0;
  opacity: 0;
  transform: translateY(-6px);
  transition:
    opacity 0.22s ease,
    transform 0.28s ease;
  pointer-events: none;
}

.syllabus-subjects-clip.is-open .syllabus-subjects {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
  transition-delay: 0.04s;
}

.syllabus-subject-chip {
  height: 32px;
  padding: 0 12px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  border-radius: 8px;
  background: #fff;
  color: #334155;
  font-size: 13px;
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s, color 0.15s;
}

.syllabus-subject-chip:hover {
  border-color: rgba(15, 118, 110, 0.45);
  color: #0f766e;
}

.syllabus-subject-chip.is-active {
  border-color: #0f766e;
  background: rgba(15, 118, 110, 0.08);
  color: #0f766e;
  font-weight: 600;
}

.syllabus-subjects__hint {
  margin: 0;
  font-size: 13px;
  color: #94a3b8;
  line-height: 32px;
}

.syllabus-doc {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  margin-top: 4px;
  padding-top: 16px;
}

.syllabus-doc__head {
  flex-shrink: 0;
}

.syllabus-doc__title-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px 14px;
}

.syllabus-doc__subject {
  display: inline-flex;
  align-items: center;
  height: 32px;
  padding: 0 14px;
  border: 1px solid #0f766e;
  border-radius: 999px;
  background: rgba(15, 118, 110, 0.08);
  color: #0f766e;
  font-size: 14px;
  font-weight: 650;
  line-height: 1;
}

.syllabus-doc__source {
  margin: 8px 0 0;
  font-size: 12px;
  color: #94a3b8;
}

.syllabus-tabs {
  flex-shrink: 0;
  display: flex;
  gap: 4px;
  margin: 12px 0 0;
  padding: 0;
  border-bottom: 1px solid rgba(15, 23, 42, 0.08);
}

.syllabus-tab {
  height: 36px;
  padding: 0 14px;
  border: none;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  background: transparent;
  color: #64748b;
  font-size: 14px;
  cursor: pointer;
}

.syllabus-tab.is-active {
  border-bottom-color: #0f766e;
  color: #0f766e;
  font-weight: 600;
}

.syllabus-doc__scroll {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  padding: 14px 8px 8px 4px;
}

.syllabus-section-title {
  margin: 8px 0 12px;
  font-size: 15px;
  font-weight: 650;
  color: #0f172a;
}

.syllabus-ref-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.syllabus-ref-item__title {
  font-size: 15px;
  font-weight: 650;
  color: #0f172a;
}

.syllabus-ref-item__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 6px 12px;
  margin-top: 4px;
  font-size: 13px;
  color: #64748b;
}

.syllabus-ref-item__note {
  margin: 6px 0 0;
  font-size: 12px;
  color: #94a3b8;
}

.syllabus-works {
  margin: 0;
  padding-left: 2.4em;
  list-style-position: outside;
  font-size: 14px;
  line-height: 1.7;
  color: #334155;
}

.syllabus-works li + li {
  margin-top: 4px;
}

.syllabus-works__title {
  font-weight: 550;
}

.syllabus-works__src {
  color: #64748b;
}

.syllabus-empty {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  min-height: 240px;
  color: #64748b;
}

.syllabus-empty p {
  margin: 0 0 6px;
  font-size: 15px;
  color: #334155;
}

.syllabus-empty small {
  font-size: 12px;
  color: #94a3b8;
}

.syllabus-empty-inline {
  margin: 0 0 16px;
  font-size: 13px;
  color: #94a3b8;
}
</style>
