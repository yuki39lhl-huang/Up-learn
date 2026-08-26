<script setup lang="ts">
import { onUnmounted, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { useWorkbenchPrefsStore } from '../../stores/workbenchPrefs'
import type { SidebarMode, TableDensity } from '../../stores/workbenchPrefs'
import '../../styles/glass-modal.css'

const props = defineProps<{
  visible: boolean
}>()

const emit = defineEmits<{
  close: []
  saved: []
}>()

const prefsStore = useWorkbenchPrefsStore()

const tableDensity = ref<TableDensity>('comfortable')
const sidebarMode = ref<SidebarMode>('full')
const showStatusBar = ref(true)
const defaultProvince = ref('广东')

function syncForm() {
  tableDensity.value = prefsStore.prefs.tableDensity
  sidebarMode.value = prefsStore.prefs.sidebarMode
  showStatusBar.value = prefsStore.prefs.showStatusBar
  defaultProvince.value = prefsStore.prefs.defaultProvince
}

function lockScroll(lock: boolean) {
  document.body.style.overflow = lock ? 'hidden' : ''
}

watch(
  () => props.visible,
  (open) => {
    lockScroll(open)
    if (open) syncForm()
  },
  { immediate: true },
)

onUnmounted(() => lockScroll(false))

function handleBackdropClick(e: MouseEvent) {
  if (e.target === e.currentTarget) emit('close')
}

function handleSave() {
  prefsStore.patch({
    tableDensity: tableDensity.value,
    sidebarMode: sidebarMode.value,
    showStatusBar: showStatusBar.value,
    defaultProvince: defaultProvince.value,
  })
  ElMessage.success('界面设置已应用')
  emit('saved')
  emit('close')
}

function handleReset() {
  prefsStore.reset()
  syncForm()
  ElMessage.info('已恢复默认布局')
}
</script>

<template>
  <Teleport to="body">
    <Transition name="glass-fade">
      <div
        v-if="visible"
        class="glass-overlay"
        role="dialog"
        aria-modal="true"
        aria-labelledby="layout-modal-title"
        @click="handleBackdropClick"
      >
        <div class="glass-modal glass-modal--wide">
          <div class="glass-modal__glow" aria-hidden="true" />
          <button type="button" class="glass-modal__close" aria-label="关闭" @click="emit('close')">
            ×
          </button>

          <h2 id="layout-modal-title" class="glass-modal__title">界面设置</h2>
          <p class="glass-modal__subtitle">调整工作台布局、密度与默认筛选，与用户资料无关</p>

          <form @submit.prevent="handleSave">
            <label class="glass-field">
              <span class="glass-field__label">表格密度</span>
              <select v-model="tableDensity" class="glass-field__input">
                <option value="comfortable">舒适</option>
                <option value="compact">紧凑</option>
              </select>
            </label>

            <label class="glass-field">
              <span class="glass-field__label">侧边栏</span>
              <select v-model="sidebarMode" class="glass-field__input">
                <option value="full">完整（图标 + 文字）</option>
                <option value="icon">仅图标</option>
              </select>
            </label>

            <label class="glass-field">
              <span class="glass-field__label">默认省份</span>
              <select v-model="defaultProvince" class="glass-field__input">
                <option value="广东">广东</option>
                <option value="河南">河南</option>
                <option value="北京">北京</option>
              </select>
              <span class="glass-field__hint">院校查询页的默认筛选省份</span>
            </label>

            <label class="glass-field layout-check">
              <input v-model="showStatusBar" type="checkbox" />
              <span>显示底部状态栏</span>
            </label>

            <button type="submit" class="glass-submit">应用设置</button>
            <button type="button" class="glass-reset" @click="handleReset">恢复默认</button>
          </form>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.layout-check {
  flex-direction: row;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  user-select: none;
}

.layout-check input {
  width: 16px;
  height: 16px;
  accent-color: var(--st-primary-container);
}

.glass-reset {
  width: 100%;
  height: 44px;
  margin-top: 10px;
  border: 1px solid #e2e8f0;
  border-radius: 999px;
  background: #fff;
  color: #64748b;
  font-size: 14px;
  cursor: pointer;
}

.glass-reset:hover {
  background: #f8fafc;
}
</style>
