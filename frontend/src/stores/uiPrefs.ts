import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import {
  fetchUiPreference,
  saveUiPreference,
  uploadUiWallpaper,
} from '../api/user'
import type { UserUiPreferenceVO, WallpaperFit, WallpaperTarget } from '../types/api'
import { t, type AppLocale } from '../i18n/messages'
import { useAuthStore } from './auth'

export type UiTheme = 'light' | 'dark'

export interface UiPrefsState {
  theme: UiTheme
  locale: AppLocale
  wallpaperUrl: string | null
  panelWallpaperUrl: string | null
  shellBgOpacity: number
  shellWallpaperFit: WallpaperFit
  panelOpacity: number
  moduleOpacity: number
  moduleBlur: number
  panelWallpaperFit: WallpaperFit
  sidebarCollapsed: boolean
  /** 内容块深色强调；仅本地偏好，不走后端 */
  contentEmphasis: boolean
}

const LOCAL_KEY = 'ul_ui_prefs'

const defaults: UiPrefsState = {
  theme: 'light',
  locale: 'zh-CN',
  wallpaperUrl: null,
  panelWallpaperUrl: null,
  shellBgOpacity: 100,
  shellWallpaperFit: 'cover',
  panelOpacity: 100,
  moduleOpacity: 85,
  moduleBlur: 67,
  panelWallpaperFit: 'cover',
  sidebarCollapsed: false,
  contentEmphasis: true,
}

function clampOpacity(n: number | undefined | null, fallback = 100): number {
  if (n == null || Number.isNaN(n)) return fallback
  return Math.max(0, Math.min(100, Math.round(n)))
}

function normalizeFit(v: unknown): WallpaperFit {
  return v === 'contain' || v === 'fill' ? v : 'cover'
}

function cssBgSize(fit: WallpaperFit): string {
  if (fit === 'contain') return 'contain'
  if (fit === 'fill') return '100% 100%'
  return 'cover'
}

function readLocal(): UiPrefsState {
  try {
    const raw = localStorage.getItem(LOCAL_KEY)
    if (!raw) return { ...defaults }
    const parsed = JSON.parse(raw) as Partial<UiPrefsState>
    return {
      theme: parsed.theme === 'dark' ? 'dark' : 'light',
      locale: parsed.locale === 'en-US' ? 'en-US' : 'zh-CN',
      wallpaperUrl: parsed.wallpaperUrl ?? null,
      panelWallpaperUrl: parsed.panelWallpaperUrl ?? null,
      shellBgOpacity: clampOpacity(parsed.shellBgOpacity),
      shellWallpaperFit: normalizeFit(parsed.shellWallpaperFit),
      panelOpacity: clampOpacity(parsed.panelOpacity),
      moduleOpacity: clampOpacity(parsed.moduleOpacity, 85),
      moduleBlur: clampOpacity(parsed.moduleBlur, 67),
      panelWallpaperFit: normalizeFit(parsed.panelWallpaperFit),
      sidebarCollapsed: Boolean(parsed.sidebarCollapsed),
      contentEmphasis: parsed.contentEmphasis !== false,
    }
  } catch {
    return { ...defaults }
  }
}

function writeLocal(state: UiPrefsState) {
  localStorage.setItem(LOCAL_KEY, JSON.stringify(state))
}

/** 签名 URL 刷新时若对象路径相同则保留旧展示地址，避免壁纸闪黑重载 */
function keepDisplayUrl(prev: string | null, next: string | null | undefined): string | null {
  if (!next) return null
  if (!prev) return next
  const strip = (u: string) => u.split('?')[0]
  return strip(prev) === strip(next) ? prev : next
}

function fromVo(vo: UserUiPreferenceVO, prev?: UiPrefsState): UiPrefsState {
  return {
    theme: vo.theme === 'dark' ? 'dark' : 'light',
    locale: vo.locale === 'en-US' ? 'en-US' : 'zh-CN',
    wallpaperUrl: keepDisplayUrl(prev?.wallpaperUrl ?? null, vo.wallpaperUrl),
    panelWallpaperUrl: keepDisplayUrl(prev?.panelWallpaperUrl ?? null, vo.panelWallpaperUrl),
    shellBgOpacity: clampOpacity(vo.shellBgOpacity),
    shellWallpaperFit: normalizeFit(vo.shellWallpaperFit),
    panelOpacity: clampOpacity(vo.panelOpacity),
    moduleOpacity: clampOpacity(vo.moduleOpacity, 85),
    moduleBlur: clampOpacity(vo.moduleBlur, 67),
    panelWallpaperFit: normalizeFit(vo.panelWallpaperFit),
    sidebarCollapsed: Boolean(vo.sidebarCollapsed),
    // 本地样式开关：远端拉取时保留本机选择
    contentEmphasis: prev?.contentEmphasis !== false,
  }
}

export const useUiPrefsStore = defineStore('uiPrefs', () => {
  const state = ref<UiPrefsState>(readLocal())

  const locale = computed(() => state.value.locale)
  const theme = computed(() => state.value.theme)
  const sidebarCollapsed = computed(() => state.value.sidebarCollapsed)

  function tr(key: string, vars?: Record<string, string | number>) {
    return t(state.value.locale, key, vars)
  }

  function applyToDocument() {
    const s = state.value
    const root = document.documentElement
    root.dataset.theme = s.theme
    root.classList.toggle('dark', s.theme === 'dark')
    root.style.setProperty(
      '--ul-shell-bg-image',
      s.wallpaperUrl ? `url("${s.wallpaperUrl}")` : 'none',
    )
    root.style.setProperty('--ul-shell-bg-size', cssBgSize(s.shellWallpaperFit))
    root.style.setProperty('--ul-shell-bg-opacity', String(s.shellBgOpacity))
    root.style.setProperty(
      '--ul-panel-bg-image',
      s.panelWallpaperUrl ? `url("${s.panelWallpaperUrl}")` : 'none',
    )
    root.style.setProperty('--ul-panel-bg-size', cssBgSize(s.panelWallpaperFit))
    root.style.setProperty('--ul-panel-opacity', String(s.panelOpacity))
    root.style.setProperty('--ul-module-opacity', String(s.moduleOpacity))
    root.style.setProperty('--ul-module-blur', String(s.moduleBlur))
    root.dataset.contentEmphasis = s.contentEmphasis ? 'on' : 'off'
  }

  function patchLocal(partial: Partial<UiPrefsState>) {
    state.value = { ...state.value, ...partial }
    writeLocal(state.value)
    applyToDocument()
  }

  async function loadRemote() {
    applyToDocument()
    const auth = useAuthStore()
    if (!auth.isLoggedIn) {
      return
    }
    try {
      const vo = await fetchUiPreference()
      state.value = fromVo(vo, state.value)
      writeLocal(state.value)
      applyToDocument()
    } catch {
      /* keep local */
    }
  }

  async function persist(
    partial?: Partial<UiPrefsState> & {
      clearWallpaper?: boolean
      clearPanelWallpaper?: boolean
    },
  ) {
    if (partial) {
      const { clearWallpaper: _a, clearPanelWallpaper: _b, ...rest } = partial
      if (Object.keys(rest).length) {
        state.value = { ...state.value, ...rest }
      }
    }
    writeLocal(state.value)
    applyToDocument()

    const auth = useAuthStore()
    if (!auth.isLoggedIn) return state.value

    const vo = await saveUiPreference({
      theme: state.value.theme,
      locale: state.value.locale,
      shellBgOpacity: state.value.shellBgOpacity,
      shellWallpaperFit: state.value.shellWallpaperFit,
      panelOpacity: state.value.panelOpacity,
      moduleOpacity: state.value.moduleOpacity,
      moduleBlur: state.value.moduleBlur,
      panelWallpaperFit: state.value.panelWallpaperFit,
      sidebarCollapsed: state.value.sidebarCollapsed,
      clearWallpaper: partial?.clearWallpaper === true,
      clearPanelWallpaper: partial?.clearPanelWallpaper === true,
    })
    const next = fromVo(vo, state.value)
    // 本地已清空时不要被旧库脏数据回填（MyBatis-Plus 曾忽略 null 更新）
    if (partial?.clearWallpaper || state.value.wallpaperUrl == null) next.wallpaperUrl = null
    if (partial?.clearPanelWallpaper || state.value.panelWallpaperUrl == null) {
      next.panelWallpaperUrl = null
    }
    state.value = next
    writeLocal(state.value)
    applyToDocument()
    return state.value
  }

  async function toggleTheme() {
    const next: UiTheme = state.value.theme === 'dark' ? 'light' : 'dark'
    return persist({ theme: next })
  }

  async function uploadWallpaper(file: File, target: WallpaperTarget = 'shell') {
    const { wallpaperUrl } = await uploadUiWallpaper(file, target)
    if (target === 'panel') {
      state.value = { ...state.value, panelWallpaperUrl: wallpaperUrl }
    } else {
      state.value = { ...state.value, wallpaperUrl }
    }
    writeLocal(state.value)
    applyToDocument()
    return wallpaperUrl
  }

  async function clearWallpaper(target: WallpaperTarget = 'shell') {
    if (target === 'panel') {
      state.value = { ...state.value, panelWallpaperUrl: null }
      return persist({ clearPanelWallpaper: true, panelWallpaperUrl: null })
    }
    state.value = { ...state.value, wallpaperUrl: null }
    return persist({ clearWallpaper: true, wallpaperUrl: null })
  }

  applyToDocument()

  return {
    state,
    locale,
    theme,
    sidebarCollapsed,
    tr,
    patchLocal,
    loadRemote,
    persist,
    toggleTheme,
    uploadWallpaper,
    clearWallpaper,
  }
})
