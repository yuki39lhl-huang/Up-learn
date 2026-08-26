import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export type TableDensity = 'comfortable' | 'compact'
export type SidebarMode = 'full' | 'icon'

export interface WorkbenchPrefs {
  tableDensity: TableDensity
  sidebarMode: SidebarMode
  showStatusBar: boolean
  defaultProvince: string
}

const PREFS_KEY = 'ul_workbench_prefs'

const defaults: WorkbenchPrefs = {
  tableDensity: 'comfortable',
  sidebarMode: 'full',
  showStatusBar: true,
  defaultProvince: '广东',
}

function readPrefs(): WorkbenchPrefs {
  try {
    const raw = localStorage.getItem(PREFS_KEY)
    if (!raw) return { ...defaults }
    return { ...defaults, ...JSON.parse(raw) }
  } catch {
    return { ...defaults }
  }
}

/** 工作台界面布局偏好（与用户资料无关） */
export const useWorkbenchPrefsStore = defineStore('workbenchPrefs', () => {
  const prefs = ref<WorkbenchPrefs>(readPrefs())

  watch(
    prefs,
    (v) => localStorage.setItem(PREFS_KEY, JSON.stringify(v)),
    { deep: true },
  )

  function patch(partial: Partial<WorkbenchPrefs>) {
    prefs.value = { ...prefs.value, ...partial }
  }

  function reset() {
    prefs.value = { ...defaults }
  }

  return { prefs, patch, reset }
})
