<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchMajorCategories, fetchMajorOptions, fetchSchoolList, fetchSchoolMajors } from '../../api/school'
import type { MajorOptionVO, MajorVO, SchoolVO } from '../../types/api'

const loading = ref(false)
const majorsLoading = ref(false)
const schools = ref<SchoolVO[]>([])
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
    searchMajorOptions('')
  }
  onSearch()
}

async function showMajors(row: SchoolVO) {
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

function onSearch() {
  pageNo.value = 1
  selectedSchool.value = null
  schoolMajors.value = []
  loadSchools()
}

function typeChip(row: SchoolVO) {
  return row.type === '公办' ? 'st-chip--public' : 'st-chip--private'
}

function isMajorHighlighted(m: MajorVO) {
  if (majorDictId.value != null && m.majorDictId === majorDictId.value) return true
  if (!majorDictId.value && majorCategory.value && m.majorCategory === majorCategory.value) return true
  return false
}

onMounted(async () => {
  try {
    majorCategories.value = await fetchMajorCategories()
  } catch {
    majorCategories.value = []
  }
  loadSchools()
})
watch([pageNo], loadSchools)
</script>

<template>
  <section class="school-panel st-card">
    <header class="st-card-header">按省份查询在招院校</header>
    <div class="st-card-body">
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
          @change="onSearch"
          @clear="onSearch"
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
        <el-table-column label="" width="72" align="center">
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
          </template>
        </el-table-column>
      </el-table>

      <div class="pager">
        <el-pagination
          v-model:current-page="pageNo"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          small
          background
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
            >
              <div class="majors-item__head">
                <strong>{{ m.name }}</strong>
                <span v-if="isMajorHighlighted(m)" class="st-chip st-chip--match">与筛选相关</span>
                <span v-if="m.majorCategory" class="st-chip st-chip--muted">{{ m.majorCategory }}</span>
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
  </section>
</template>

<style scoped>
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
