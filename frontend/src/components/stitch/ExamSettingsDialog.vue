<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  fetchExamSubjectOptions,
  fetchMajorCategories,
  type ExamSubjectOptions,
} from '../../api/school'
import { useExamPrefsStore } from '../../stores/examPrefs'
import { getCohortOptions, isCohortInRange } from '../../utils/examCountdown'
import {
  hasSelfExamComprehensive,
  isSelfExamComprehensive,
  practiceNoteForSelection,
  selectionToAllSubjects,
  toPracticeSubjects,
  type ExamSubjectSelection,
  type SubjectSlot,
} from '../../utils/examSubjects'

const SUBJECT_NONE = '暂不选择'
const SETTINGS_MAIN_W = 500 // 主内容区宽度
const SETTINGS_PANEL_W = 290 // 侧边栏宽度
const SETTINGS_PANEL_GAP = 20 // 主表单与侧边栏间隔（.subject-panel margin-left）
const SETTINGS_BODY_PAD_X = 36 // 内容区左右内边距

const open = defineModel<boolean>({ default: false })

const emit = defineEmits<{
  saved: []
  reset: []
}>()

const examPrefs = useExamPrefsStore()
const majorCategories = ref<string[]>([])
const categoriesLoading = ref(false)
const subjectOptions = ref<ExamSubjectOptions | null>(null)
const subjectsLoading = ref(false)
let subjectOptionsRequestId = 0

const formProvince = ref('')
const formCohort = ref<number | null>(null)
const formMajorCategory = ref('')
const formDailySubject = ref('')
const formDailyMode = ref(examPrefs.prefs.dailySubjectMode)
const formSubjectSelection = ref<ExamSubjectSelection>({
  public: [],
  foundation: [],
  comprehensive: [],
})

const subjectPanelOpen = ref(false)
const subjectPanelSlot = ref<SubjectSlot>('public')
const panelDraft = ref<string[]>([])
const settingsFrameExpanded = ref(false)
const settingsFrameRef = ref<HTMLElement | null>(null)
const settingsFrameHeight = ref<string>()

const cohortOptions = computed(() => getCohortOptions())
const formSelectedSubjects = computed(() => selectionToAllSubjects(formSubjectSelection.value))
const formPracticeSubjects = computed(() => toPracticeSubjects(formSubjectSelection.value))
const formPracticeNote = computed(() => practiceNoteForSelection(formSubjectSelection.value))
const showSubjectSection = computed(() => !!(formProvince.value && formMajorCategory.value))
const showDailySection = computed(() => showSubjectSection.value && formSelectedSubjects.value.length > 0)

const settingsDialogWidth = computed(() => {
  const contentW = settingsFrameExpanded.value
    ? SETTINGS_MAIN_W + SETTINGS_PANEL_GAP + SETTINGS_PANEL_W
    : SETTINGS_MAIN_W
  return `${contentW + SETTINGS_BODY_PAD_X}px`
})

const subjectPanelTitle = computed(() => {
  const map: Record<SubjectSlot, string> = {
    public: '选择公共课',
    foundation: '选择专业基础课',
    comprehensive: '选择专业综合课',
  }
  return map[subjectPanelSlot.value]
})

const subjectPanelCandidates = computed(() =>
  subjectOptions.value?.[subjectPanelSlot.value].options ?? [],
)

function cloneSelection(sel: ExamSubjectSelection): ExamSubjectSelection {
  return {
    public: [...sel.public],
    foundation: [...sel.foundation],
    comprehensive: [...sel.comprehensive],
  }
}

function resetPanelUi() {
  subjectPanelOpen.value = false
  settingsFrameExpanded.value = false
  panelDraft.value = []
  settingsFrameHeight.value = undefined
}

function animateSettingsFrame(expanding: boolean) {
  const frame = settingsFrameRef.value
  if (!frame) return

  const currentHeight = frame.getBoundingClientRect().height
  settingsFrameHeight.value = `${currentHeight}px`

  requestAnimationFrame(() => {
    if (expanding) {
      settingsFrameHeight.value = `${Math.min(900, window.innerHeight - 150)}px`
      return
    }

    nextTick(() => {
      if (settingsFrameRef.value) {
        settingsFrameHeight.value = `${settingsFrameRef.value.scrollHeight}px`
      }
    })
  })
}

function onSettingsFrameTransitionEnd(event: TransitionEvent) {
  if (event.propertyName === 'height') {
    settingsFrameHeight.value = undefined
  }
}

function syncFormFromPrefs() {
  formProvince.value = examPrefs.prefs.province
  formCohort.value = examPrefs.prefs.cohortYear
  formMajorCategory.value = examPrefs.prefs.majorCategory
  formSubjectSelection.value = examPrefs.prefs.subjectSelection
    ? cloneSelection(examPrefs.prefs.subjectSelection)
    : { public: [], foundation: [], comprehensive: [] }
  formDailySubject.value = examPrefs.prefs.dailySubject
  formDailyMode.value = examPrefs.prefs.dailySubjectMode
  subjectOptions.value = null
  subjectsLoading.value = false
  resetPanelUi()
}

function selectionFromDefaults(options: ExamSubjectOptions): ExamSubjectSelection {
  return {
    public: [...options.public.defaults],
    foundation: [...options.foundation.defaults],
    comprehensive: [...options.comprehensive.defaults],
  }
}

async function loadSubjectOptions(applyDefaults: boolean) {
  const province = formProvince.value.trim()
  const majorCategory = formMajorCategory.value.trim()
  if (!province || !majorCategory) {
    subjectOptions.value = null
    subjectsLoading.value = false
    return
  }

  const requestId = ++subjectOptionsRequestId
  subjectsLoading.value = true
  try {
    const options = await fetchExamSubjectOptions(province, majorCategory)
    if (requestId !== subjectOptionsRequestId) return
    subjectOptions.value = options
    if (applyDefaults) {
      formSubjectSelection.value = selectionFromDefaults(options)
      applySubjectSelectionDraft()
    }
  } catch (e) {
    if (requestId !== subjectOptionsRequestId) return
    subjectOptions.value = null
    ElMessage.error(e instanceof Error ? e.message : '加载考试科目失败')
  } finally {
    if (requestId === subjectOptionsRequestId) subjectsLoading.value = false
  }
}

function applySubjectSelectionDraft() {
  const all = formSelectedSubjects.value
  if (!all.includes(formDailySubject.value)) {
    formDailySubject.value = all[0] ?? ''
  }
}

function loadPanelDraft(slot: SubjectSlot) {
  panelDraft.value = [...formSubjectSelection.value[slot]]
}

function commitPanelDraft() {
  if (!subjectPanelOpen.value) return
  formSubjectSelection.value = {
    ...formSubjectSelection.value,
    [subjectPanelSlot.value]: [...panelDraft.value],
  }
  applySubjectSelectionDraft()
}

function toggleSubjectPanel(slot: SubjectSlot) {
  if (!formMajorCategory.value || subjectsLoading.value || !subjectOptions.value) {
    if (subjectsLoading.value) ElMessage.info('考试科目加载中，请稍候')
    return
  }

  if (subjectPanelOpen.value && subjectPanelSlot.value === slot) {
    commitPanelDraft()
    subjectPanelOpen.value = false
    return
  }

  settingsFrameExpanded.value = true
  if (subjectPanelOpen.value) commitPanelDraft()

  subjectPanelSlot.value = slot
  loadPanelDraft(slot)
  subjectPanelOpen.value = true
}

function onSubjectPanelAfterLeave() {
  settingsFrameExpanded.value = false
}

function clearPanelDraft() {
  panelDraft.value = []
}

function togglePanelDraft(name: string) {
  const set = new Set(panelDraft.value)
  if (set.has(name)) set.delete(name)
  else set.add(name)
  panelDraft.value = [...set]
}

function isPanelSlotActive(slot: SubjectSlot) {
  return subjectPanelOpen.value && subjectPanelSlot.value === slot
}

function onFormProvinceChange(value: string | undefined) {
  ++subjectOptionsRequestId
  formProvince.value = value ?? ''
  formMajorCategory.value = ''
  formSubjectSelection.value = { public: [], foundation: [], comprehensive: [] }
  formDailySubject.value = ''
  subjectOptions.value = null
  subjectsLoading.value = false
  resetPanelUi()
  animateSettingsFrame(false)
}

async function onFormCategoryChange() {
  if (!formMajorCategory.value) {
    ++subjectOptionsRequestId
    formSubjectSelection.value = { public: [], foundation: [], comprehensive: [] }
    formDailySubject.value = ''
    subjectOptions.value = null
    subjectsLoading.value = false
    resetPanelUi()
    animateSettingsFrame(false)
    return
  }
  formSubjectSelection.value = { public: [], foundation: [], comprehensive: [] }
  subjectOptions.value = null
  animateSettingsFrame(true)
  await loadSubjectOptions(true)
}

async function saveSettings() {
  if (subjectPanelOpen.value) commitPanelDraft()
  if (!formProvince.value) {
    ElMessage.warning('请选择省份')
    return
  }
  if (formCohort.value == null) {
    ElMessage.warning('请选择届别')
    return
  }
  if (!isCohortInRange(formCohort.value)) {
    ElMessage.warning('届别不在可选范围内，请重新选择')
    return
  }
  if (!formMajorCategory.value) {
    ElMessage.warning('请先选择专业类型')
    return
  }
  const selected = formSelectedSubjects.value
  if (selected.length === 0) {
    ElMessage.warning('请至少选择一门考试科目')
    return
  }
  if (formPracticeSubjects.value.length === 0) {
    ElMessage.warning('当前科目组合暂无题库覆盖，请调整后再保存')
    return
  }
  if (formDailyMode.value === 'fixed' && !formDailySubject.value) {
    ElMessage.warning('请选择每日一练科目')
    return
  }
  examPrefs.patch({
    province: formProvince.value,
    cohortYear: formCohort.value,
    majorCategory: formMajorCategory.value,
    subjectSelection: cloneSelection(formSubjectSelection.value),
    dailySubject: formDailyMode.value === 'random' ? selected[0]! : formDailySubject.value,
    dailySubjectMode: formDailyMode.value,
  })
  try {
    await examPrefs.saveRemote()
  } catch {
    ElMessage.warning('已保存到本地，云端同步失败')
  }
  open.value = false
  emit('saved')
}

async function resetSettings() {
  try {
    await ElMessageBox.confirm('将清空届别、专业类型与科目设置，是否继续？', '重置备考设置', {
      confirmButtonText: '重置',
      cancelButtonText: '取消',
      type: 'warning',
    })
    examPrefs.reset()
    try {
      await examPrefs.deleteRemote()
    } catch {
      ElMessage.warning('已清除本地设置，云端设置删除失败')
    }
    syncFormFromPrefs()
    open.value = false
    emit('reset')
    ElMessage.success('已重置')
  } catch {
    /* cancelled */
  }
}

async function loadMajorCategories() {
  categoriesLoading.value = true
  try {
    majorCategories.value = await fetchMajorCategories()
  } catch {
    majorCategories.value = []
  } finally {
    categoriesLoading.value = false
  }
}

watch(open, (visible) => {
  if (visible) {
    syncFormFromPrefs()
    void loadSubjectOptions(false)
  }
})

onMounted(loadMajorCategories)
</script>

<template>
  <el-dialog
    v-model="open"
    title="备考设置"
    :width="settingsDialogWidth"
    class="exam-settings-dialog"
    destroy-on-close
    @closed="resetPanelUi()"
  >
    <div
      ref="settingsFrameRef"
      class="settings-dialog-frame"
      :class="{
        'settings-dialog-frame--full': showSubjectSection,
        'settings-dialog-frame--panel': settingsFrameExpanded,
      }"
      :style="{ height: settingsFrameHeight }"
      @transitionend="onSettingsFrameTransitionEnd"
    >
      <div class="settings-shell">
        <div class="settings-main">
          <el-form label-position="top" class="settings-form">
            <div class="settings-form__row">
              <el-form-item label="省份">
                <el-select
                  :model-value="formProvince || undefined"
                  clearable
                  placeholder="请选择省份"
                  style="width: 100%"
                  @update:model-value="onFormProvinceChange"
                >
                  <el-option label="广东" value="广东" />
                  <el-option label="山东" value="山东" />
                </el-select>
              </el-form-item>
              <el-form-item label="届别">
                <el-select v-model="formCohort" clearable placeholder="选择届别" style="width: 100%">
                  <el-option v-for="c in cohortOptions" :key="c" :label="`${c} 届`" :value="c" />
                </el-select>
              </el-form-item>
            </div>

            <el-form-item v-if="formProvince" label="专业类型">
              <el-select
                v-model="formMajorCategory"
                clearable
                filterable
                :loading="categoriesLoading"
                placeholder="如：计算机类、土木类"
                style="width: 100%"
                @change="onFormCategoryChange"
              >
                <el-option v-for="c in majorCategories" :key="c" :label="c" :value="c" />
              </el-select>
            </el-form-item>

            <div v-if="formProvince && !formMajorCategory" class="settings-guide settings-guide--compact">
              <p class="settings-guide__desc">选择专业类型后，将从{{ formProvince }}考试科目规则加载默认科目</p>
            </div>

            <Transition name="settings-reveal">
              <div v-if="showSubjectSection" class="settings-reveal">
                <el-form-item label="考试科目" class="settings-form__subjects">
                  <div class="subject-plan">
                    <p class="subject-plan__hint">
                      {{ subjectsLoading ? '正在加载考试科目规则…' : '已加载考试科目规则；点击行展开自定义，再次点击保存并收回' }}
                    </p>
                    <button
                      type="button"
                      class="subject-plan__section subject-plan__section--clickable"
                      :class="{ 'subject-plan__section--active': isPanelSlotActive('public') }"
                      @click="toggleSubjectPanel('public')"
                    >
                      <span class="subject-plan__label">
                        公共课
                        <span
                          class="subject-plan__arrow"
                          :class="{ 'subject-plan__arrow--open': isPanelSlotActive('public') }"
                          aria-hidden="true"
                        >›</span>
                      </span>
                      <div class="chip-row">
                        <span v-for="s in formSubjectSelection.public" :key="`req-${s}`" class="chip chip--required">
                          {{ s }}
                        </span>
                        <span v-if="!formSubjectSelection.public.length" class="subject-plan__placeholder">
                          点击选择（可不选）
                        </span>
                      </div>
                    </button>
                    <button
                      type="button"
                      class="subject-plan__section subject-plan__section--clickable"
                      :class="{ 'subject-plan__section--active': isPanelSlotActive('foundation') }"
                      @click="toggleSubjectPanel('foundation')"
                    >
                      <span class="subject-plan__label">
                        专业基础课
                        <span
                          class="subject-plan__arrow"
                          :class="{ 'subject-plan__arrow--open': isPanelSlotActive('foundation') }"
                          aria-hidden="true"
                        >›</span>
                      </span>
                      <div class="chip-row">
                        <span v-for="s in formSubjectSelection.foundation" :key="`f-${s}`" class="chip chip--foundation">
                          {{ s }}
                        </span>
                        <span v-if="!formSubjectSelection.foundation.length" class="subject-plan__placeholder">
                          点击选择（可不选）
                        </span>
                      </div>
                    </button>
                    <button
                      type="button"
                      class="subject-plan__section subject-plan__section--clickable"
                      :class="{ 'subject-plan__section--active': isPanelSlotActive('comprehensive') }"
                      @click="toggleSubjectPanel('comprehensive')"
                    >
                      <span class="subject-plan__label">
                        专业综合课
                        <span
                          class="subject-plan__arrow"
                          :class="{ 'subject-plan__arrow--open': isPanelSlotActive('comprehensive') }"
                          aria-hidden="true"
                        >›</span>
                      </span>
                      <div class="chip-row">
                        <span
                          v-for="s in formSubjectSelection.comprehensive"
                          :key="`c-${s}`"
                          class="chip chip--comprehensive"
                          :class="{ 'chip--muted': isSelfExamComprehensive(s) }"
                        >
                          {{ s }}
                        </span>
                        <span v-if="!formSubjectSelection.comprehensive.length" class="subject-plan__placeholder">
                          点击选择（可不选）
                        </span>
                      </div>
                    </button>
                    <p v-if="hasSelfExamComprehensive(formSubjectSelection.comprehensive)" class="subject-plan__warn">
                      含院校自命题综合课，请在院校查询中核对招生简章
                    </p>
                    <p class="subject-plan__note">{{ formPracticeNote }}</p>
                  </div>
                </el-form-item>

                <template v-if="showDailySection">
                  <el-form-item label="每日一练科目" class="settings-form__daily">
                    <el-select
                      v-model="formDailySubject"
                      :disabled="formDailyMode === 'random'"
                      placeholder="从已选考试科目中选择"
                      style="width: 100%"
                    >
                      <el-option v-for="s in formSelectedSubjects" :key="s" :label="s" :value="s" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="刷题模式" class="settings-form__mode">
                    <el-radio-group v-model="formDailyMode">
                      <el-radio value="fixed">固定科目（每天刷新该科一题）</el-radio>
                      <el-radio value="random">随机科目（在所选科目中随机）</el-radio>
                    </el-radio-group>
                  </el-form-item>
                </template>
              </div>
            </Transition>

            <div v-if="!formProvince" class="settings-guide settings-guide--compact">
              <p class="settings-guide__desc">先选择省份与届别，再选专业类型即可加载考试科目</p>
            </div>

            <footer class="settings-panel-foot">
              <el-button text type="danger" @click="resetSettings">重置</el-button>
              <div class="settings-panel-foot__right">
                <el-button @click="open = false">取消</el-button>
                <el-button type="primary" @click="saveSettings">保存</el-button>
              </div>
            </footer>
          </el-form>
        </div>

        <Transition name="subject-panel" @after-leave="onSubjectPanelAfterLeave">
          <aside v-if="subjectPanelOpen" class="subject-panel" :style="{ width: `${SETTINGS_PANEL_W}px` }">
            <header class="subject-panel__head">
              <h3>{{ subjectPanelTitle }}</h3>
            </header>
            <p class="subject-panel__tip">可多选；点「暂不选择」清空；再次点击左侧行保存并收回</p>
            <div v-loading="subjectsLoading" class="subject-panel__list">
              <button
                type="button"
                class="subject-panel__option subject-panel__option--btn subject-panel__option--none"
                :class="{ 'subject-panel__option--active': panelDraft.length === 0 }"
                @click="clearPanelDraft"
              >
                {{ SUBJECT_NONE }}
              </button>
              <label
                v-for="name in subjectPanelCandidates"
                :key="name"
                class="subject-panel__option"
                :class="{ 'subject-panel__option--active': panelDraft.includes(name) }"
              >
                <input type="checkbox" :checked="panelDraft.includes(name)" @change="togglePanelDraft(name)" />
                <span>{{ name }}</span>
              </label>
            </div>
          </aside>
        </Transition>
      </div>
    </div>
  </el-dialog>
</template>

<style scoped>
.settings-form__row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.settings-panel-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 12px;
  padding-top: 10px;
  border-top: 1px solid var(--st-outline-variant);
}

.settings-panel-foot__right {
  display: flex;
  gap: 8px;
}

.settings-dialog-frame {
  width: 100%;
  max-width: 100%;
  height: auto;
  overflow: visible;
  box-sizing: border-box;
  transition:
    width 0.32s cubic-bezier(0.4, 0, 0.2, 1),
    height 0.42s cubic-bezier(0.4, 0, 0.2, 1);
}

.settings-dialog-frame--full {
  height: min(900px, calc(100vh - 150px));
}

.settings-shell {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: flex-start;
  overflow: visible;
}

.settings-main {
  flex: 0 0 500px;
  width: 500px;
  max-width: 100%;
  height: 100%;
  box-sizing: border-box;
}

.settings-form {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.settings-dialog-frame:not(.settings-dialog-frame--full) .settings-shell,
.settings-dialog-frame:not(.settings-dialog-frame--full) .settings-main {
  height: auto;
}

.settings-form :deep(.el-form-item) {
  margin-bottom: 12px;
}

.settings-form :deep(.el-form-item:last-child) {
  margin-bottom: 0;
}

.settings-form__daily,
.settings-form__mode {
  margin-bottom: 0 !important;
}

.settings-form__mode :deep(.el-radio-group) {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 6px;
}

.settings-form__mode :deep(.el-radio) {
  height: auto;
  margin-right: 0;
  white-space: normal;
  align-items: flex-start;
}

.settings-form__mode :deep(.el-radio__label) {
  line-height: 1.45;
  white-space: normal;
}

.settings-guide {
  margin-top: 2px;
  padding: 8px 12px;
  border-radius: 10px;
  background: var(--st-surface-container-low);
  text-align: center;
}

.settings-guide--compact {
  padding: 6px 12px;
}

.settings-guide__desc {
  margin: 0;
  font-size: 12px;
  line-height: 1.45;
  color: var(--st-on-surface-variant);
}

.settings-reveal-enter-active,
.settings-reveal-leave-active {
  transition: opacity 0.26s ease, transform 0.26s ease;
}

.settings-reveal-enter-from,
.settings-reveal-leave-to {
  opacity: 0;
  transform: translateY(-6px);
}

.settings-dialog-frame--full .settings-reveal {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-width: thin;
  scrollbar-color: rgb(100 116 139 / 55%) transparent;
}

.settings-form__subjects :deep(.el-form-item__content) {
  display: block;
  width: 100%;
}

.chip-row {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.chip {
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  background: var(--st-surface-container);
  color: var(--st-secondary);
}

.chip--required {
  background: rgb(34 197 94 / 12%);
  color: #15803d;
}

.chip--foundation {
  background: rgb(59 130 246 / 12%);
  color: #1d4ed8;
}

.chip--comprehensive {
  background: rgb(168 85 247 / 12%);
  color: #7e22ce;
}

.chip--muted {
  background: var(--st-surface-container);
  color: var(--st-on-surface-variant);
}

.subject-plan {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
  padding: 12px;
  border-radius: 12px;
  background: var(--st-surface-container-low);
  box-sizing: border-box;
}

.subject-plan__hint {
  margin: 0;
  font-size: 12px;
  line-height: 1.5;
  color: var(--st-on-surface-variant);
}

.subject-plan__section {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
  margin: 0;
  padding: 10px 12px;
  border: 1px solid transparent;
  border-radius: 10px;
  background: var(--st-surface);
  text-align: left;
  font: inherit;
  box-sizing: border-box;
}

.subject-plan__section--clickable {
  cursor: pointer;
  transition: border-color 0.15s, box-shadow 0.15s;
}

.subject-plan__section--clickable:hover {
  border-color: var(--st-secondary);
  box-shadow: 0 0 0 1px rgb(34 197 94 / 15%);
}

.subject-plan__section--active {
  border-color: var(--st-secondary);
  background: rgb(34 197 94 / 6%);
  box-shadow: 0 0 0 1px rgb(34 197 94 / 20%);
}

.subject-plan__label {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 12px;
  font-weight: 700;
  color: var(--st-on-surface-variant);
}

.subject-plan__arrow {
  font-size: 16px;
  line-height: 1;
  opacity: 0.45;
  transition: transform 0.26s ease, opacity 0.2s ease;
}

.subject-plan__arrow--open {
  transform: rotate(90deg);
  opacity: 0.85;
}

.subject-plan__placeholder {
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.subject-plan__warn {
  margin: 0;
  font-size: 12px;
  line-height: 1.5;
  color: #b45309;
}

.subject-plan__note {
  margin: 0;
  padding-top: 4px;
  border-top: 1px dashed var(--st-outline-variant);
  font-size: 12px;
  line-height: 1.5;
  color: var(--st-on-surface-variant);
  word-break: break-word;
}

.subject-panel {
  flex: 0 0 290px;
  align-self: stretch;
  display: flex;
  flex-direction: column;
  width: 290px;
  min-width: 290px;
  min-height: 0;
  box-sizing: border-box;
  border-left: 1px solid var(--st-outline-variant);
  padding-left: 20px;
  padding-right: 20px;
  margin-left: 20px;
  background: var(--st-surface);
  overflow: visible;
  position: relative;
  z-index: 1;
}

.subject-panel-enter-active,
.subject-panel-leave-active {
  transition:
    transform 0.32s cubic-bezier(0.4, 0, 0.2, 1),
    opacity 0.28s ease;
}

.subject-panel-enter-from,
.subject-panel-leave-to {
  opacity: 0;
  transform: translateX(100%);
}

.subject-panel__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 8px;
  flex-shrink: 0;
}

.subject-panel__head h3 {
  margin: 0;
  font-size: 15px;
  font-weight: 700;
}

.subject-panel__tip {
  margin: 0 0 10px;
  font-size: 12px;
  line-height: 1.5;
  color: var(--st-on-surface-variant);
  flex-shrink: 0;
}

.subject-panel__list {
  flex: 1;
  min-height: 0;
  width: 100%;
  max-height: calc(100vh - 220px);
  display: flex;
  flex-direction: column;
  gap: 5px;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 2px;
  box-sizing: border-box;
  scrollbar-width: thin;
  scrollbar-color: rgb(100 116 139 / 55%) transparent;
}

.settings-reveal::-webkit-scrollbar,
.subject-panel__list::-webkit-scrollbar {
  width: 8px;
}

.settings-reveal::-webkit-scrollbar-track,
.subject-panel__list::-webkit-scrollbar-track {
  background: transparent;
}

.settings-reveal::-webkit-scrollbar-thumb,
.subject-panel__list::-webkit-scrollbar-thumb {
  border: 2px solid transparent;
  border-radius: 999px;
  background: rgb(100 116 139 / 55%);
  background-clip: padding-box;
}

.settings-reveal::-webkit-scrollbar-thumb:hover,
.subject-panel__list::-webkit-scrollbar-thumb:hover {
  background: rgb(71 85 105 / 70%);
  background-clip: padding-box;
}

.subject-panel__option {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  padding: 8px 10px;
  border-radius: 8px;
  border: 1px solid var(--st-outline-variant);
  background: var(--st-surface);
  font-size: 13px;
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s;
  flex-shrink: 0;
  box-sizing: border-box;
}

.subject-panel__option--btn {
  width: 100%;
  text-align: left;
  font: inherit;
}

.subject-panel__option--none {
  color: var(--st-on-surface-variant);
  border-style: dashed;
}

.subject-panel__option--active {
  border-color: var(--st-secondary);
  background: rgb(34 197 94 / 8%);
  color: #15803d;
  font-weight: 600;
}

.subject-panel__option input {
  flex-shrink: 0;
}
</style>

<style>
.exam-settings-dialog {
  max-width: min(860px, 96vw);
}

.exam-settings-dialog.el-dialog {
  height: auto !important;
  max-height: calc(100vh - 48px);
  margin: 24px auto !important;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  transition: width 0.32s cubic-bezier(0.4, 0, 0.2, 1);
}

.exam-settings-dialog .el-dialog__body {
  padding: 8px 18px 14px;
  min-height: 0 !important;
  flex: 0 0 auto;
  overflow: visible;
  width: 100%;
  box-sizing: border-box;
}

.exam-settings-dialog .el-dialog__header {
  padding: 14px 18px 8px;
  margin-right: 0;
  flex-shrink: 0;
}

.exam-settings-dialog .el-dialog__footer {
  display: none;
}
</style>
