<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { addUserTarget, fetchUserTargets, removeUserTarget } from '../../api/user'
import {
  fetchMajorCategories,
  fetchMajorOptions,
  fetchSchoolList,
  fetchSchoolMajors,
} from '../../api/school'
import { useAuthStore } from '../../stores/auth'
import type { MajorOptionVO, MajorVO, SchoolVO, UserTargetVO } from '../../types/api'
import ProvinceGuideDialog from './ProvinceGuideDialog.vue'

const props = withDefaults(
  defineProps<{
    /** 是否为当前激活模块；切入时播下拉展开 */
    active?: boolean
  }>(),
  { active: false },
)

const auth = useAuthStore()
const contentRevealed = ref(false)

async function playContentReveal() {
  contentRevealed.value = false
  await nextTick()
  // 等显示帧再展开，避免与 v-show 切显抢同一帧导致「卡一下全出来」
  requestAnimationFrame(() => {
    contentRevealed.value = true
  })
}

watch(
  () => props.active,
  (on) => {
    if (on) void playContentReveal()
    else contentRevealed.value = false
  },
  { immediate: true },
)

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
const majorCategory = ref('')
const majorCategories = ref<string[]>([])
const majorDictId = ref<number | undefined>()
const majorOptions = ref<MajorOptionVO[]>([])
const majorSearchLoading = ref(false)
const pageNo = ref(1)
const pageSize = 12
/** 广东新目录默认查 2026；山东暂不按年强过滤 */
const listYear = computed(() => (province.value === '广东' ? 2026 : undefined))

const selectedSchool = ref<SchoolVO | null>(null)
const schoolMajors = ref<MajorVO[]>([])
const targetsExpanded = ref(false)
const highlightedMajorId = ref<number | null>(null)
const activeTargetId = ref<number | null>(null)
const majorsPanelRef = ref<HTMLElement | null>(null)
const guideOpen = ref(false)

const TARGET_HOME_HINT = '主页仅展示第一目标志愿'

const targetPreview = computed(() => {
  if (targets.value.length === 0) return ''
  const names = targets.value.slice(0, 2).map((t) => t.schoolName)
  if (targets.value.length <= 2) return names.join('、')
  return `${names.join('、')} 等`
})

function majorTitle(m: MajorVO) {
  return m.displayName || m.name || '—'
}

function isSchoolExam(m: MajorVO) {
  return (m.examType || '').includes('校考')
}

function isLimited(m: MajorVO) {
  return (m.prerequisite || '').includes('限招')
}

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

/** 最近可滚动祖先（控制台面板），找不到则用 window */
function findScrollParent(el: HTMLElement | null): HTMLElement | null {
  let node: HTMLElement | null = el?.parentElement ?? null
  while (node) {
    const style = getComputedStyle(node)
    const oy = style.overflowY
    if ((oy === 'auto' || oy === 'scroll' || oy === 'overlay') && node.scrollHeight > node.clientHeight) {
      return node
    }
    node = node.parentElement
  }
  return null
}

/** 将开设专业面板滚到可视区顶部；可选再滚到高亮专业 */
async function scrollToMajorsPanel(majorId?: number | null) {
  await nextTick()
  // 等专业面板挂载并完成布局后再量取位置
  await new Promise<void>((resolve) => requestAnimationFrame(() => resolve()))

  const panel = majorsPanelRef.value
  if (!panel) return

  const scroller = findScrollParent(panel)
  if (scroller) {
    const panelTop = panel.getBoundingClientRect().top
    const scrollerTop = scroller.getBoundingClientRect().top
    const nextTop = scroller.scrollTop + (panelTop - scrollerTop) - 12
    scroller.scrollTo({ top: Math.max(0, nextTop), behavior: 'smooth' })
  } else {
    panel.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  if (majorId == null) return
  await nextTick()
  const majorEl = panel.querySelector(`tr[data-major-id="${majorId}"]`) as HTMLElement | null
  majorEl?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
}

async function openTargetDetail(item: UserTargetVO) {
  targetsExpanded.value = false
  await showMajors(schoolFromTarget(item), {
    scroll: true,
    majorId: item.majorId ?? null,
    targetId: item.id,
  })
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
      year: listYear.value,
      majorDictId: majorDictId.value,
      majorCategory:
        !majorDictId.value && majorCategory.value ? majorCategory.value : undefined,
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

async function reloadWithSelection() {
  const keep = selectedSchool.value
  pageNo.value = 1
  await loadSchools()
  if (keep && schools.value.some((s) => s.id === keep.id)) {
    selectedSchool.value = keep
    await showMajors(keep, { scroll: false })
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
  } catch {
    majorOptions.value = []
  } finally {
    majorSearchLoading.value = false
  }
}

function onMajorCategoryChange() {
  majorDictId.value = undefined
  majorOptions.value = []
  if (majorCategory.value) {
    void searchMajorOptions('')
  }
  void reloadWithSelection()
}

async function onMajorDictChange() {
  await reloadWithSelection()
}

function isMajorFilterMatch(m: MajorVO) {
  if (majorDictId.value != null && m.majorDictId === majorDictId.value) return true
  if (!majorDictId.value && majorCategory.value && m.majorCategory === majorCategory.value) return true
  return false
}

/** 防止连点切换院校时旧请求覆盖新结果 */
let majorsRequestSeq = 0

async function showMajors(
  row: SchoolVO,
  opts?: { scroll?: boolean; majorId?: number | null; targetId?: number | null },
) {
  const shouldScroll = opts?.scroll !== false
  const alreadyOpen = selectedSchool.value != null

  highlightedMajorId.value = opts?.majorId ?? null
  activeTargetId.value = opts?.targetId ?? null
  selectedSchool.value = row
  if (!alreadyOpen) {
    schoolMajors.value = []
  }

  const seq = ++majorsRequestSeq
  majorsLoading.value = true
  try {
    const list = await fetchSchoolMajors(row.id, {
      majorDictId: majorDictId.value,
      majorCategory: majorCategory.value || undefined,
    })
    if (seq !== majorsRequestSeq) return
    schoolMajors.value = list
  } catch (e) {
    if (seq !== majorsRequestSeq) return
    schoolMajors.value = []
    ElMessage.error(e instanceof Error ? e.message : '专业列表加载失败')
  } finally {
    if (seq !== majorsRequestSeq) return
    majorsLoading.value = false
    const jumpFromTarget = opts?.majorId != null || opts?.targetId != null
    if (shouldScroll && (!alreadyOpen || jumpFromTarget || !isMajorsPanelMostlyVisible())) {
      await scrollToMajorsPanel(opts?.majorId)
    }
  }
}

function isMajorsPanelMostlyVisible(): boolean {
  const panel = majorsPanelRef.value
  if (!panel) return false
  const rect = panel.getBoundingClientRect()
  const scroller = findScrollParent(panel)
  const topBound = scroller ? scroller.getBoundingClientRect().top : 0
  const bottomBound = scroller ? scroller.getBoundingClientRect().bottom : window.innerHeight
  return rect.top < bottomBound - 80 && rect.bottom > topBound + 80
}

function typeChip(row: SchoolVO) {
  return row.type === '公办' ? 'st-chip--public' : 'st-chip--private'
}

function isTargetMajorHighlighted(m: MajorVO) {
  return highlightedMajorId.value != null && m.id === highlightedMajorId.value
}

onMounted(async () => {
  try {
    majorCategories.value = await fetchMajorCategories()
  } catch {
    majorCategories.value = []
  }
  await loadTargets()
  loadSchools()
})
</script>

<template>
  <!-- 顶栏已有「院校查询」，内容区不再重复同名标题 -->
  <div class="module-shell">
    <section class="module-card">
      <header class="module-card__head">
        <div>
          <p class="module-card__eyebrow">升学通 · 院校中心</p>
          <h2>在招院校</h2>
        </div>
      </header>
      <Transition name="school-reveal">
        <div v-if="contentRevealed" class="school-reveal-clip">
          <div class="school-panel__body school-reveal-inner">
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
          style="width: 160px"
          @change="onMajorDictChange"
          @clear="onMajorDictChange"
        >
          <el-option v-for="item in majorOptions" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
        <el-input v-model="kw" placeholder="搜索院校" clearable style="width: 160px" @keyup.enter="onSearch" />
        <el-button type="primary" @click="onSearch">查询</el-button>
        <el-button @click="guideOpen = true">前言</el-button>

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
      <el-table v-loading="loading" :data="schools" size="small" class="school-table">
        <el-table-column prop="name" label="院校" min-width="180" />
        <el-table-column label="类型" width="88">
          <template #default="{ row }">
            <span class="st-chip" :class="typeChip(row)">{{ row.type }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="majorCount" label="专业数" width="88" align="center" />
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

      <section v-if="selectedSchool" ref="majorsPanelRef" class="majors-panel">
        <header class="majors-panel__head">
          <span>{{ selectedSchool.name }} · 招生专业（{{ majorsLoading ? '…' : schoolMajors.length }}）</span>
          <span v-if="selectedSchool.type" class="st-chip" :class="typeChip(selectedSchool)">{{
            selectedSchool.type
          }}</span>
        </header>
        <div v-loading="majorsLoading" class="majors-panel__body">
          <p v-if="!majorsLoading && schoolMajors.length === 0" class="majors-empty">暂无开设专业数据</p>
          <div v-else class="majors-table-wrap">
            <table class="majors-table">
              <thead>
                <tr>
                  <th>专业组</th>
                  <th>专业号</th>
                  <th>批次</th>
                  <th class="majors-table__col-major">招生专业</th>
                  <th>公共课</th>
                  <th>专业基础课</th>
                  <th>专业综合课</th>
                  <th>专综类型</th>
                  <th>学费</th>
                  <th>教学地点</th>
                  <th>前置要求</th>
                  <th class="majors-table__col-act">操作</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="m in schoolMajors"
                  :key="m.id"
                  :class="{
                    'majors-table__row--target': isTargetMajorHighlighted(m),
                    'majors-table__row--match': isMajorFilterMatch(m),
                  }"
                  :data-major-id="m.id"
                >
                  <td>{{ m.majorGroup || '—' }}</td>
                  <td>{{ m.majorCode || '—' }}</td>
                  <td>{{ m.batchName || '—' }}</td>
                  <td class="majors-table__col-major">
                    <span class="majors-table__major-name">{{ majorTitle(m) }}</span>
                    <span v-if="isTargetMajorHighlighted(m)" class="st-chip st-chip--match">目标</span>
                  </td>
                  <td>{{ m.publicSubjects || '—' }}</td>
                  <td>{{ m.foundationSubject || '—' }}</td>
                  <td>{{ m.comprehensiveSubject || '—' }}</td>
                  <td>
                    <span
                      class="majors-table__exam"
                      :class="{ 'majors-table__exam--school': isSchoolExam(m) }"
                    >
                      {{ m.examType || '—' }}
                    </span>
                  </td>
                  <td>{{ m.tuition != null ? m.tuition : '—' }}</td>
                  <td>{{ m.campus || '—' }}</td>
                  <td>
                    <span :class="{ 'majors-table__limit': isLimited(m) }">{{ m.prerequisite || '—' }}</span>
                  </td>
                  <td class="majors-table__col-act">
                    <el-button
                      link
                      type="success"
                      size="small"
                      :loading="targetAdding === m.id"
                      :disabled="!selectedSchool || isMajorTargeted(selectedSchool.id, m.id)"
                      @click.stop="handleAddMajorTarget(m)"
                    >
                      {{
                        selectedSchool && isMajorTargeted(selectedSchool.id, m.id) ? '已加入' : '加入目标'
                      }}
                    </el-button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
      </div>
          </div>
        </div>
      </Transition>
    </section>

    <ProvinceGuideDialog :open="guideOpen" :province="province" @close="guideOpen = false" />
  </div>
</template>

<style scoped>
.school-panel__body {
  position: relative;
}

/* 与备考设置「计算机类」展开同思路：只裁高度，避免整块瞬显 */
.school-reveal-enter-active.school-reveal-clip,
.school-reveal-leave-active.school-reveal-clip {
  display: grid;
  grid-template-rows: 1fr;
  overflow: hidden;
}

.school-reveal-enter-active.school-reveal-clip {
  transition: grid-template-rows 0.48s cubic-bezier(0.4, 0, 0.2, 1);
}

.school-reveal-leave-active.school-reveal-clip {
  transition: grid-template-rows 0.32s cubic-bezier(0.4, 0, 0.2, 1);
}

.school-reveal-enter-from.school-reveal-clip,
.school-reveal-leave-to.school-reveal-clip {
  grid-template-rows: 0fr;
}

.school-reveal-clip > .school-reveal-inner {
  min-height: 0;
}

.school-reveal-enter-active .school-reveal-inner,
.school-reveal-leave-active .school-reveal-inner {
  overflow: hidden;
}

.school-reveal-enter-active .school-reveal-inner {
  transition: opacity 0.36s ease 0.06s;
}

.school-reveal-enter-from .school-reveal-inner {
  opacity: 0.35;
}

@media (prefers-reduced-motion: reduce) {
  .school-reveal-enter-active.school-reveal-clip,
  .school-reveal-leave-active.school-reveal-clip {
    transition: none;
  }

  .school-reveal-enter-active .school-reveal-inner {
    transition: none;
  }
}

.majors-panel {
  margin-top: 18px;
  border: 1px solid color-mix(in srgb, var(--st-on-surface) 10%, transparent);
  border-radius: 18px;
  overflow: hidden;
  background: var(--ul-content-fill);
}

.majors-panel__head {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  font-size: 14px;
  font-weight: 650;
  color: var(--st-on-surface);
  border-bottom: 1px solid color-mix(in srgb, var(--st-on-surface) 8%, transparent);
}

.majors-table-wrap {
  overflow-x: auto;
  overflow-y: visible;
}

.majors-table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  font-size: 12px;
}

.majors-table th,
.majors-table td {
  border: none;
  border-bottom: 1px solid color-mix(in srgb, var(--st-on-surface) 8%, transparent);
  padding: 10px 12px;
  text-align: left;
  vertical-align: top;
  white-space: nowrap;
  background: transparent;
  color: var(--st-on-surface);
}

.majors-table thead th {
  background: var(--ul-ep-table-header-bg);
  font-weight: 650;
  color: var(--st-on-surface);
}

.majors-table__col-major {
  white-space: normal;
  min-width: 140px;
  max-width: 220px;
}

.majors-table__col-act {
  position: sticky;
  right: 0;
  z-index: 1;
  background: var(--ul-ep-table-bg);
  box-shadow: -4px 0 8px color-mix(in srgb, var(--st-on-surface) 8%, transparent);
}

.majors-table thead .majors-table__col-act {
  background: var(--ul-ep-table-header-bg);
}

.majors-table__major-name {
  display: inline;
  line-height: 1.45;
}

.majors-table__exam--school {
  color: #b42318;
  font-weight: 600;
}

.majors-table__limit {
  color: #b42318;
  font-weight: 600;
}

.majors-table__row--target td,
.majors-table__row--match td {
  background: rgba(61, 107, 79, 0.08);
}

/* —— 目标院校：筛选项右侧紧凑入口，点击下拉同前 —— */
.targets-anchor {
  position: relative;
  z-index: 30;
  margin-left: auto;
  flex: 0 1 auto;
  max-width: min(340px, 100%);
}

.targets-toggle {
  display: flex;
  align-items: center;
  gap: 6px;
  width: auto;
  max-width: 100%;
  padding: 6px 10px;
  border: 1px solid var(--st-glass-border);
  border-radius: 12px;
  background: var(--st-glass-bg);
  backdrop-filter: blur(calc(var(--ul-module-blur, 67) * 0.2px)) saturate(1.2);
  -webkit-backdrop-filter: blur(calc(var(--ul-module-blur, 67) * 0.2px)) saturate(1.2);
  box-shadow: var(--st-glass-shadow);
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
  background: color-mix(in srgb, var(--st-glass-bg) 88%, var(--st-surface));
  box-shadow: 0 4px 14px color-mix(in srgb, var(--st-on-surface) 8%, transparent);
}

.targets-toggle--open {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  border-bottom-color: var(--st-glass-border);
  box-shadow: none;
}

.targets-toggle__icon {
  flex-shrink: 0;
  width: 20px;
  height: 20px;
  display: grid;
  place-items: center;
  border-radius: 7px;
  font-size: 10px;
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
  min-width: 20px;
  height: 20px;
  padding: 0 5px;
  border-radius: 999px;
  background: rgb(34 197 94 / 14%);
  color: #15803d;
  font-size: 12px;
  font-weight: 700;
  line-height: 20px;
  text-align: center;
}

.targets-toggle__preview {
  flex: 1;
  min-width: 0;
  max-width: 96px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.targets-toggle__chevron {
  flex-shrink: 0;
  margin-left: 2px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  transition: transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
  line-height: 1;
}

.targets-toggle__chevron--up {
  transform: rotate(180deg);
}

.targets-float {
  width: 100%;
  border: 1px solid var(--st-glass-border);
  border-top: 1px solid var(--st-glass-border);
  border-radius: 0 0 14px 14px;
  background: var(--st-glass-bg);
  backdrop-filter: blur(18px) saturate(1.25);
  -webkit-backdrop-filter: blur(18px) saturate(1.25);
  box-shadow: var(--st-glass-shadow);
  color: var(--st-on-surface);
}

.targets-expanded-wrap {
  position: absolute;
  top: calc(100% - 1px);
  left: auto;
  right: 0;
  z-index: 50;
  width: min(360px, calc(100vw - 48px));
  min-width: 260px;
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
  background: var(--st-glass-inner-bg);
  border: 1px solid transparent;
  transition: background 0.12s, border-color 0.12s;
  color: var(--st-on-surface);
}

.targets-item:hover {
  background: color-mix(in srgb, var(--st-glass-inner-bg) 70%, var(--st-surface));
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
  color: var(--st-on-surface-variant);
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
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  padding: 12px 14px;
  border-radius: 16px;
  background: var(--ul-content-fill);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 70%, transparent);
  position: relative;
  z-index: 28;
}

.filters :deep(.el-input__wrapper),
.filters :deep(.el-select__wrapper) {
  border-radius: 12px !important;
  box-shadow: none !important;
  background: var(--ul-content-fill-strong) !important;
}

.school-table {
  width: 100%;
  border-radius: 16px;
  overflow: hidden;
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 65%, transparent);
  background: transparent;
}

.school-table :deep(.el-table) {
  --el-table-border-color: transparent;
  --el-table-header-bg-color: var(--ul-ep-table-header-bg);
  --el-table-row-hover-bg-color: var(--ul-ep-table-hover-bg);
  --el-table-bg-color: var(--ul-ep-table-bg);
  --el-table-tr-bg-color: var(--ul-ep-table-bg);
  --el-table-current-row-bg-color: var(--ul-ep-table-hover-bg);
  --el-fill-color-blank: var(--ul-ep-table-bg);
  background: transparent !important;
}

.school-table :deep(.el-table__inner-wrapper::before) {
  display: none;
}

.school-table :deep(.el-table tr) {
  background-color: var(--ul-ep-table-bg) !important;
}

.school-table :deep(th.el-table__cell) {
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 45%, transparent) !important;
  background: var(--ul-ep-table-header-bg) !important;
}

.school-table :deep(td.el-table__cell) {
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 45%, transparent) !important;
  background: var(--ul-ep-table-bg) !important;
}

.school-table :deep(.el-table__row) {
  height: 48px;
}

.school-table :deep(.el-button) {
  border-radius: 999px;
}

.pager {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}

.majors-panel__body {
  min-height: 80px;
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
  padding: 14px 16px;
  border-radius: 14px;
  background: var(--ul-content-fill-strong);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 70%, transparent);
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
