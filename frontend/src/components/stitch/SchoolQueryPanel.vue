<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { addUserTarget, fetchUserTargets, removeUserTarget } from '../../api/user'
import { fetchMajorCategories, fetchMajorOptions, fetchSchoolList, fetchSchoolMajors } from '../../api/school'
import { useAuthStore } from '../../stores/auth'
import type { MajorOptionVO, MajorVO, SchoolVO, UserTargetVO } from '../../types/api'

const auth = useAuthStore()
const loading = ref(false)
const majorsLoading = ref(false)
const targetsLoading = ref(false)
const targetAdding = ref<number | null>(null)
const schools = ref<SchoolVO[]>([])
const targets = ref<UserTargetVO[]>([])
const total = ref(0)
const kw = ref('')
const province = ref('广东')
const type = ref('')
const preferPublic = ref(false)
const majorCategory = ref('')
const majorCategories = ref<string[]>([])
const majorDictId = ref<number | undefined>()
const majorOptions = ref<MajorOptionVO[]>([])
const majorSearchLoading = ref(false)
const pageNo = ref(1)
const pageSize = 12

const selectedSchool = ref<SchoolVO | null>(null)
const schoolMajors = ref<MajorVO[]>([])
const targetsExpanded = ref(false)
const highlightedMajorId = ref<number | null>(null)
const activeTargetId = ref<number | null>(null)

const TARGET_HOME_HINT = '主页仅展示第一目标志愿'

const targetPreview = computed(() => {
  if (targets.value.length === 0) return ''
  const names = targets.value.slice(0, 2).map((t) => t.schoolName)
  if (targets.value.length <= 2) return names.join('、')
  return `${names.join('、')} 等`
})

function toggleTargetsPanel() {
  targetsExpanded.value = !targetsExpanded.value
}

function closeTargetsPanel() {
  targetsExpanded.value = false
}

function schoolFromTarget(item: UserTargetVO): SchoolVO {
  const found = schools.value.find((s) => s.id === item.schoolId)
  if (found) return found
  return {
    id: item.schoolId,
    name: item.schoolName,
    province: item.schoolProvince ?? '',
    city: item.schoolCity ?? '',
    type: item.schoolType ?? '',
  }
}

function isTargetItemActive(item: UserTargetVO) {
  return activeTargetId.value === item.id
}

async function openTargetDetail(item: UserTargetVO) {
  targetsExpanded.value = false
  await showMajors(schoolFromTarget(item))
  activeTargetId.value = item.id
  highlightedMajorId.value = item.majorId ?? null
  await nextTick()
  document.querySelector('.majors-panel')?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
  if (item.majorId) {
    document
      .querySelector(`.majors-item[data-major-id="${item.majorId}"]`)
      ?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
  }
}

const targetKeySet = computed(() => {
  const set = new Set<string>()
  for (const t of targets.value) {
    set.add(`${t.schoolId}:${t.majorId ?? ''}`)
  }
  return set
})

function isSchoolTargeted(schoolId: number) {
  return targetKeySet.value.has(`${schoolId}:`)
}

function isMajorTargeted(schoolId: number, majorId: number) {
  return targetKeySet.value.has(`${schoolId}:${majorId}`)
}

function requireLogin(): boolean {
  if (auth.isLoggedIn) return true
  ElMessage.warning('请先登录后再加入目标院校')
  return false
}

async function loadTargets() {
  if (!auth.isLoggedIn) {
    targets.value = []
    return
  }
  targetsLoading.value = true
  try {
    targets.value = await fetchUserTargets()
  } catch (e) {
    targets.value = []
    ElMessage.error(e instanceof Error ? e.message : '目标列表加载失败')
  } finally {
    targetsLoading.value = false
  }
}

async function handleAddSchoolTarget(row: SchoolVO) {
  if (!requireLogin() || isSchoolTargeted(row.id)) return
  targetAdding.value = row.id
  try {
    const vo = await addUserTarget({ schoolId: row.id })
    targets.value = [vo, ...targets.value.filter((t) => t.id !== vo.id)]
    ElMessage.success(`已加入目标院校。${TARGET_HOME_HINT}`)
    targetsExpanded.value = true
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加入失败')
  } finally {
    targetAdding.value = null
  }
}

async function handleAddMajorTarget(major: MajorVO) {
  if (!selectedSchool.value || !requireLogin()) return
  if (isMajorTargeted(selectedSchool.value.id, major.id)) return
  targetAdding.value = major.id
  try {
    const vo = await addUserTarget({ schoolId: selectedSchool.value.id, majorId: major.id })
    targets.value = [vo, ...targets.value.filter((t) => t.id !== vo.id)]
    ElMessage.success(`已加入目标专业。${TARGET_HOME_HINT}`)
    targetsExpanded.value = true
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加入失败')
  } finally {
    targetAdding.value = null
  }
}

async function handleRemoveTarget(id: number) {
  try {
    await removeUserTarget(id)
    targets.value = targets.value.filter((t) => t.id !== id)
    if (activeTargetId.value === id) {
      activeTargetId.value = null
      highlightedMajorId.value = null
    }
    ElMessage.success('已移除')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '移除失败')
  }
}

async function loadSchools() {
  loading.value = true
  try {
    const data = await fetchSchoolList({
      pageNo: pageNo.value,
      pageSize,
      kw: kw.value.trim() || undefined,
      province: province.value || undefined,
      type: type.value || undefined,
      majorDictId: majorDictId.value,
      majorCategory:
        !majorDictId.value && majorCategory.value ? majorCategory.value : undefined,
      preferPublic: preferPublic.value || undefined,
    })
    schools.value = data.list
    total.value = data.total
    if (selectedSchool.value && !data.list.some((s) => s.id === selectedSchool.value!.id)) {
      selectedSchool.value = null
      schoolMajors.value = []
    }
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '院校加载失败')
  } finally {
    loading.value = false
  }
}

function resetMajorPanel() {
  selectedSchool.value = null
  schoolMajors.value = []
  highlightedMajorId.value = null
  activeTargetId.value = null
}

function onPageChange(page: number) {
  pageNo.value = page
  loadSchools()
}

function onSearch() {
  resetMajorPanel()
  pageNo.value = 1
  loadSchools()
}

/** 专业筛选变更：刷新院校列表，若当前校仍在结果中则同步刷新专业列表 */
async function reloadWithSelection() {
  const keep = selectedSchool.value
  pageNo.value = 1
  await loadSchools()
  if (keep && schools.value.some((s) => s.id === keep.id)) {
    selectedSchool.value = keep
    await showMajors(keep)
  }
}

async function searchMajorOptions(query: string) {
  if (!majorCategory.value) {
    majorOptions.value = []
    return
  }
  majorSearchLoading.value = true
  try {
    const data = await fetchMajorOptions({
      kw: query.trim() || undefined,
      majorCategory: majorCategory.value,
      pageNo: 1,
      pageSize: 30,
    })
    majorOptions.value = data.list
  } catch (e) {
    majorOptions.value = []
    ElMessage.error(e instanceof Error ? e.message : '专业选项加载失败')
  } finally {
    majorSearchLoading.value = false
  }
}

function onMajorCategoryChange() {
  majorDictId.value = undefined
  majorOptions.value = []
  if (majorCategory.value) {
    searchMajorOptions('')
  }
  reloadWithSelection()
}

async function onMajorDictChange() {
  await reloadWithSelection()
}

async function showMajors(row: SchoolVO) {
  highlightedMajorId.value = null
  activeTargetId.value = null
  selectedSchool.value = row
  schoolMajors.value = []
  majorsLoading.value = true
  try {
    schoolMajors.value = await fetchSchoolMajors(row.id, {
      majorDictId: majorDictId.value,
      majorCategory: majorCategory.value || undefined,
    })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '专业列表加载失败')
  } finally {
    majorsLoading.value = false
  }
}

function typeChip(row: SchoolVO) {
  return row.type === '公办' ? 'st-chip--public' : 'st-chip--private'
}

function isTargetMajorHighlighted(m: MajorVO) {
  return highlightedMajorId.value != null && m.id === highlightedMajorId.value
}

function isMajorFilterMatch(m: MajorVO) {
  if (majorDictId.value != null && m.majorDictId === majorDictId.value) return true
  if (!majorDictId.value && majorCategory.value && m.majorCategory === majorCategory.value) return true
  return false
}

function isMajorHighlighted(m: MajorVO) {
  return isTargetMajorHighlighted(m) || isMajorFilterMatch(m)
}

onMounted(async () => {
  try {
    majorCategories.value = await fetchMajorCategories()
  } catch (e) {
    majorCategories.value = []
    ElMessage.error(e instanceof Error ? e.message : '专业类型加载失败')
  }
  await loadTargets()
  loadSchools()
})
</script>

<template>
  <section class="school-panel st-card">
    <header class="st-card-header">按省份查询在招院校</header>
    <div class="st-card-body school-panel__body">
      <div v-if="auth.isLoggedIn" class="targets-anchor">
        <button
          type="button"
          class="targets-toggle"
          :class="{ 'targets-toggle--open': targetsExpanded }"
          :aria-expanded="targetsExpanded"
          @click="toggleTargetsPanel"
        >
          <span class="targets-toggle__icon" aria-hidden="true">★</span>
          <span class="targets-toggle__label">我的目标院校</span>
          <span class="targets-toggle__badge">{{ targets.length }}</span>
          <span v-if="targetPreview && !targetsExpanded" class="targets-toggle__preview">
            {{ targetPreview }}
          </span>
          <span class="targets-toggle__chevron" :class="{ 'targets-toggle__chevron--up': targetsExpanded }">
            ▾
          </span>
        </button>

        <Transition name="targets-drop">
          <div v-if="targetsExpanded" class="targets-expanded-wrap">
            <div class="targets-float">
              <div class="targets-float__inner" v-loading="targetsLoading">
                <p v-if="!targetsLoading && targets.length === 0" class="targets-empty">
                  在下方院校或专业旁点击「加入目标」即可收藏意向志愿。
                </p>
                <ul v-else class="targets-list">
                  <li
                    v-for="item in targets"
                    :key="item.id"
                    class="targets-item"
                    :class="{ 'targets-item--active': isTargetItemActive(item) }"
                  >
                    <button
                      type="button"
                      class="targets-item__main"
                      @click="openTargetDetail(item)"
                    >
                      <div class="targets-item__row">
                        <strong class="targets-item__name" :title="item.schoolName">{{ item.schoolName }}</strong>
                        <span
                          v-if="item.majorName"
                          class="targets-item__tag targets-item__tag--major"
                          :title="item.majorName"
                        >
                          {{ item.majorName }}
                        </span>
                        <span v-else class="targets-item__tag">院校意向</span>
                      </div>
                      <div class="targets-item__meta">
                        <span class="targets-item__loc">{{ item.schoolCity }}</span>
                        <span v-if="item.schoolType" class="targets-item__type">{{ item.schoolType }}</span>
                      </div>
                    </button>
                    <button
                      type="button"
                      class="targets-item__remove"
                      aria-label="移除"
                      @click.stop="handleRemoveTarget(item.id)"
                    >
                      ×
                    </button>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </Transition>
      </div>

      <Transition name="targets-fade">
        <button
          v-if="auth.isLoggedIn && targetsExpanded"
          type="button"
          class="targets-backdrop"
          aria-label="收起目标院校"
          @click="closeTargetsPanel"
        />
      </Transition>

      <div class="school-main" :class="{ 'school-main--dimmed': targetsExpanded }">
      <div class="filters">
        <el-select v-model="province" placeholder="省份" style="width: 120px" @change="onSearch">
          <el-option label="广东" value="广东" />
          <el-option label="山东" value="山东" />
        </el-select>
        <el-select v-model="type" clearable placeholder="类型" style="width: 110px" @change="onSearch">
          <el-option label="公办" value="公办" />
          <el-option label="民办" value="民办" />
        </el-select>
        <el-select
          v-model="majorCategory"
          clearable
          placeholder="专业类型"
          style="width: 140px"
          @change="onMajorCategoryChange"
          @clear="onMajorCategoryChange"
        >
          <el-option v-for="cat in majorCategories" :key="cat" :label="cat" :value="cat" />
        </el-select>
        <el-select
          v-model="majorDictId"
          clearable
          filterable
          remote
          reserve-keyword
          :disabled="!majorCategory"
          :placeholder="majorCategory ? '专业筛选' : '先选专业类型'"
          :remote-method="searchMajorOptions"
          :loading="majorSearchLoading"
          style="width: 180px"
          @change="onMajorDictChange"
          @clear="onMajorDictChange"
        >
          <el-option
            v-for="item in majorOptions"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          />
        </el-select>
        <el-input v-model="kw" placeholder="搜索院校" clearable style="width: 160px" @keyup.enter="onSearch" />
        <el-button type="primary" @click="onSearch">查询</el-button>
      </div>

      <el-checkbox v-model="preferPublic" class="prefer-public" @change="onSearch">
        优先展示公办院校
      </el-checkbox>

      <el-table v-loading="loading" :data="schools" size="small" class="school-table">
        <el-table-column prop="name" label="院校" min-width="140" />
        <el-table-column prop="city" label="城市" width="80" />
        <el-table-column label="类型" width="88">
          <template #default="{ row }">
            <span class="st-chip" :class="typeChip(row)">{{ row.type }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="majorCount" label="专业数" width="72" align="center" />
        <el-table-column prop="minScore" label="最低分" width="72" align="center" />
        <el-table-column prop="enrollment" label="招生" width="72" align="center" />
        <el-table-column label="学费" width="88" align="right">
          <template #default="{ row }">
            <span v-if="row.tuition">¥{{ row.tuition }}</span>
            <span v-else>—</span>
          </template>
        </el-table-column>
        <el-table-column label="" width="148" align="center">
          <template #default="{ row }">
            <el-button
              link
              type="primary"
              size="small"
              :class="{ 'is-active': selectedSchool?.id === row.id }"
              @click="showMajors(row)"
            >
              查看
            </el-button>
            <el-button
              link
              type="success"
              size="small"
              :loading="targetAdding === row.id"
              :disabled="isSchoolTargeted(row.id)"
              @click="handleAddSchoolTarget(row)"
            >
              {{ isSchoolTargeted(row.id) ? '已加入' : '加入目标' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pager">
        <el-pagination
          :current-page="pageNo"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          small
          background
          @current-change="onPageChange"
        />
      </div>

      <section v-if="selectedSchool" class="majors-panel st-card">
        <header class="st-card-header">
          {{ selectedSchool.name }} · 开设专业（{{ schoolMajors.length }}）
        </header>
        <div v-loading="majorsLoading" class="majors-panel__body">
          <p v-if="!majorsLoading && schoolMajors.length === 0" class="majors-empty">暂无开设专业数据</p>
          <ul v-else class="majors-list">
            <li
              v-for="m in schoolMajors"
              :key="m.id"
              class="majors-item"
              :class="{ 'majors-item--match': isMajorHighlighted(m) }"
              :data-major-id="m.id"
            >
              <div class="majors-item__head">
                <strong>{{ m.name }}</strong>
                <span v-if="isTargetMajorHighlighted(m)" class="st-chip st-chip--match">目标专业</span>
                <span v-else-if="isMajorFilterMatch(m)" class="st-chip st-chip--match">与筛选相关</span>
                <span v-if="m.majorCategory" class="st-chip st-chip--muted">{{ m.majorCategory }}</span>
                <el-button
                  link
                  type="success"
                  size="small"
                  class="majors-item__target-btn"
                  :loading="targetAdding === m.id"
                  :disabled="!selectedSchool || isMajorTargeted(selectedSchool.id, m.id)"
                  @click.stop="handleAddMajorTarget(m)"
                >
                  {{
                    selectedSchool && isMajorTargeted(selectedSchool.id, m.id) ? '已加入' : '加入目标'
                  }}
                </el-button>
              </div>
              <dl class="majors-item__meta">
                <div><dt>考试科目</dt><dd>{{ m.examSubjects || '—' }}</dd></div>
                <div><dt>最低分</dt><dd>{{ m.minScore ?? '—' }}</dd></div>
                <div><dt>招生</dt><dd>{{ m.enrollment ?? '—' }}</dd></div>
                <div><dt>学费</dt><dd>{{ m.tuition ? `¥${m.tuition}` : '—' }}</dd></div>
                <div><dt>年份</dt><dd>{{ m.year ?? '—' }}</dd></div>
              </dl>
            </li>
          </ul>
        </div>
      </section>
      </div>
    </div>
  </section>
</template>

<style scoped>
.school-panel__body {
  position: relative;
}

/* —— 目标院校：可收缩悬浮层 —— */
.targets-anchor {
  position: relative;
  z-index: 30;
  margin-bottom: 8px;
}

.targets-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  padding: 8px 12px;
  border: 1px solid rgb(255 255 255 / 55%);
  border-radius: 14px;
  background: rgb(255 255 255 / 72%);
  backdrop-filter: blur(14px) saturate(1.2);
  -webkit-backdrop-filter: blur(14px) saturate(1.2);
  box-shadow:
    0 1px 2px rgb(15 23 42 / 4%),
    inset 0 1px 0 rgb(255 255 255 / 65%);
  cursor: pointer;
  font: inherit;
  color: var(--st-on-surface);
  text-align: left;
  transition:
    border-radius 0.22s ease,
    box-shadow 0.22s ease,
    background 0.22s ease;
}

.targets-toggle:hover {
  background: rgb(255 255 255 / 88%);
  box-shadow: 0 4px 14px rgb(15 23 42 / 6%);
}

.targets-toggle--open {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  border-bottom-color: rgb(255 255 255 / 35%);
  box-shadow: none;
}

.targets-toggle__icon {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  display: grid;
  place-items: center;
  border-radius: 8px;
  font-size: 11px;
  color: #b45309;
  background: linear-gradient(135deg, rgb(251 191 36 / 28%), rgb(245 158 11 / 14%));
}

.targets-toggle__label {
  flex-shrink: 0;
  font-size: 13px;
  font-weight: 700;
}

.targets-toggle__badge {
  flex-shrink: 0;
  min-width: 22px;
  height: 22px;
  padding: 0 6px;
  border-radius: 999px;
  background: rgb(34 197 94 / 14%);
  color: #15803d;
  font-size: 12px;
  font-weight: 700;
  line-height: 22px;
  text-align: center;
}

.targets-toggle__preview {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.targets-toggle__chevron {
  flex-shrink: 0;
  margin-left: auto;
  font-size: 14px;
  color: var(--st-on-surface-variant);
  transition: transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
  line-height: 1;
}

.targets-toggle__chevron--up {
  transform: rotate(180deg);
}

.targets-float {
  width: 100%;
  border: 1px solid rgb(255 255 255 / 55%);
  border-top: 1px solid rgb(226 232 240 / 65%);
  border-radius: 0 0 16px 16px;
  background: rgb(255 255 255 / 88%);
  backdrop-filter: blur(18px) saturate(1.25);
  -webkit-backdrop-filter: blur(18px) saturate(1.25);
  box-shadow:
    0 18px 40px rgb(15 23 42 / 12%),
    0 4px 12px rgb(15 23 42 / 6%),
    inset 0 1px 0 rgb(255 255 255 / 70%);
}

.targets-expanded-wrap {
  position: absolute;
  top: calc(100% - 1px);
  left: 0;
  right: 0;
  z-index: 50;
  max-width: min(100%, calc(100vw - 48px));
}

.targets-float__inner {
  max-height: min(280px, 42vh);
  overflow-y: auto;
  padding: 8px 10px 10px;
}

.targets-float__inner::-webkit-scrollbar {
  width: 4px;
}

.targets-float__inner::-webkit-scrollbar-thumb {
  border-radius: 4px;
  background: rgb(100 116 139 / 25%);
}

.targets-backdrop {
  position: absolute;
  inset: 0;
  z-index: 25;
  border: none;
  padding: 0;
  margin: 0;
  cursor: default;
  background: rgb(15 23 42 / 12%);
  backdrop-filter: blur(2px);
  -webkit-backdrop-filter: blur(2px);
}

.targets-drop-enter-active,
.targets-drop-leave-active {
  transition:
    opacity 0.24s ease,
    transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  transform-origin: top center;
}

.targets-drop-enter-from,
.targets-drop-leave-to {
  opacity: 0;
  transform: translateY(-6px) scale(0.98);
}

.targets-fade-enter-active,
.targets-fade-leave-active {
  transition: opacity 0.22s ease;
}

.targets-fade-enter-from,
.targets-fade-leave-to {
  opacity: 0;
}

.school-main {
  position: relative;
  z-index: 1;
  transition: opacity 0.22s ease;
}

.school-main--dimmed {
  opacity: 0.72;
}

.targets-empty {
  margin: 0;
  padding: 10px 6px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
  line-height: 1.45;
  text-align: center;
}

.targets-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.targets-item {
  display: flex;
  align-items: stretch;
  gap: 8px;
  padding: 10px 10px 10px 12px;
  border-radius: 12px;
  background: rgb(255 255 255 / 45%);
  border: 1px solid transparent;
  transition: background 0.12s, border-color 0.12s;
}

.targets-item:hover {
  background: rgb(255 255 255 / 75%);
  border-color: rgb(34 197 94 / 22%);
}

.targets-item--active {
  background: rgb(34 197 94 / 10%);
  border-color: rgb(34 197 94 / 35%);
}

.targets-item__main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 0;
  border: none;
  background: transparent;
  font: inherit;
  text-align: left;
  cursor: pointer;
  color: inherit;
}

.targets-item__row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
}

.targets-item__name {
  font-size: 14px;
  font-weight: 700;
  line-height: 1.35;
}

.targets-item__meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.targets-item__tag {
  flex-shrink: 0;
  font-size: 11px;
  font-weight: 600;
  color: var(--st-on-surface-variant);
  background: rgb(100 116 139 / 10%);
  padding: 2px 8px;
  border-radius: 999px;
}

.targets-item__tag--major {
  color: #15803d;
  background: rgb(34 197 94 / 12%);
}

.targets-item__loc {
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.targets-item__type {
  font-size: 11px;
  font-weight: 600;
  padding: 1px 6px;
  border-radius: 4px;
  background: rgb(59 130 246 / 10%);
  color: #1d4ed8;
}

.targets-item__remove {
  flex-shrink: 0;
  align-self: center;
  width: 28px;
  height: 28px;
  display: grid;
  place-items: center;
  border: none;
  background: transparent;
  color: #94a3b8;
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
  border-radius: 8px;
  transition: color 0.12s, background 0.12s;
}

.targets-item__remove:hover {
  color: #dc2626;
  background: rgb(220 38 38 / 10%);
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 8px;
}

.prefer-public {
  margin-bottom: 12px;
}

.school-table {
  width: 100%;
}

.school-table :deep(.el-table__row) {
  height: 40px;
}

.pager {
  margin-top: 12px;
  display: flex;
  justify-content: flex-end;
}

.majors-panel {
  margin-top: 16px;
  border: 1px solid var(--st-outline-variant);
}

.majors-panel__body {
  min-height: 80px;
  max-height: 320px;
  overflow-y: auto;
  padding: 12px 16px;
}

.majors-empty {
  margin: 0;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  text-align: center;
  padding: 24px 0;
}

.majors-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.majors-item {
  padding: 12px;
  border-radius: 10px;
  background: var(--st-surface-container, #f8fafc);
  border: 1px solid var(--st-outline-variant);
}

.majors-item--match {
  border-color: var(--st-primary, #0058be);
  background: var(--st-primary-container, #e6f0ff);
}

.st-chip--match {
  background: var(--st-primary, #0058be);
  color: #fff;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 999px;
}

.majors-item__head {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  flex-wrap: wrap;
}

.majors-item__target-btn {
  margin-left: auto;
}

.majors-item__head strong {
  font-size: 14px;
}

.st-chip--muted {
  background: rgb(0 88 190 / 8%);
  color: var(--st-primary, #0058be);
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 999px;
}

.majors-item__meta {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 6px 16px;
  margin: 0;
}

.majors-item__meta div {
  display: flex;
  gap: 6px;
  font-size: 12px;
}

.majors-item__meta dt {
  color: var(--st-on-surface-variant);
  flex-shrink: 0;
}

.majors-item__meta dd {
  margin: 0;
  font-weight: 500;
}

.is-active {
  font-weight: 700;
}
</style>
