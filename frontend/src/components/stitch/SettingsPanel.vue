<script setup lang="ts">
import { computed, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useUiPrefsStore, type UiTheme } from '../../stores/uiPrefs'
import type { AppLocale } from '../../i18n/messages'
import type { WallpaperFit, WallpaperTarget } from '../../types/api'

const ui = useUiPrefsStore()
const uploadingShell = ref(false)
const uploadingPanel = ref(false)
const shellFileInput = ref<HTMLInputElement | null>(null)
const panelFileInput = ref<HTMLInputElement | null>(null)

const theme = computed({
  get: () => ui.state.theme,
  set: async (v: UiTheme) => {
    try {
      await ui.persist({ theme: v })
      ElMessage.success(ui.tr('settings.saved'))
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '保存失败')
    }
  },
})

const locale = computed({
  get: () => ui.state.locale,
  set: async (v: AppLocale) => {
    try {
      await ui.persist({ locale: v })
      ElMessage.success(ui.tr('settings.saved'))
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '保存失败')
    }
  },
})

const shellOpacity = computed({
  get: () => ui.state.shellBgOpacity,
  set: (v: number) => ui.patchLocal({ shellBgOpacity: v }),
})

const panelOpacity = computed({
  get: () => ui.state.panelOpacity,
  set: (v: number) => ui.patchLocal({ panelOpacity: v }),
})

const moduleOpacity = computed({
  get: () => ui.state.moduleOpacity,
  set: (v: number) => ui.patchLocal({ moduleOpacity: v }),
})

const moduleBlur = computed({
  get: () => ui.state.moduleBlur,
  set: (v: number) => ui.patchLocal({ moduleBlur: v }),
})

const shellFit = computed({
  get: () => ui.state.shellWallpaperFit,
  set: async (v: WallpaperFit) => {
    try {
      await ui.persist({ shellWallpaperFit: v })
      ElMessage.success(ui.tr('settings.saved'))
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '保存失败')
    }
  },
})

const panelFit = computed({
  get: () => ui.state.panelWallpaperFit,
  set: async (v: WallpaperFit) => {
    try {
      await ui.persist({ panelWallpaperFit: v })
      ElMessage.success(ui.tr('settings.saved'))
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '保存失败')
    }
  },
})

const sidebarCollapsed = computed({
  get: () => ui.state.sidebarCollapsed,
  set: async (v: boolean) => {
    try {
      await ui.persist({ sidebarCollapsed: v })
      ElMessage.success(ui.tr('settings.saved'))
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '保存失败')
    }
  },
})

const contentEmphasis = computed({
  get: () => ui.state.contentEmphasis,
  set: (v: boolean) => {
    ui.patchLocal({ contentEmphasis: v })
    ElMessage.success(ui.tr('settings.saved'))
  },
})

async function commitOpacity() {
  try {
    await ui.persist()
    ElMessage.success(ui.tr('settings.saved'))
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  }
}

function pickFile(target: WallpaperTarget) {
  if (target === 'panel') panelFileInput.value?.click()
  else shellFileInput.value?.click()
}

async function onFileChange(ev: Event, target: WallpaperTarget) {
  const input = ev.target as HTMLInputElement
  const file = input.files?.[0]
  input.value = ''
  if (!file) return
  const loading = target === 'panel' ? uploadingPanel : uploadingShell
  loading.value = true
  try {
    await ui.uploadWallpaper(file, target)
    ElMessage.success(ui.tr('settings.uploadOk'))
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '上传失败')
  } finally {
    loading.value = false
  }
}

async function clearWallpaper(target: WallpaperTarget) {
  try {
    await ui.clearWallpaper(target)
    ElMessage.success(ui.tr('settings.clearOk'))
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '清除失败')
  }
}
</script>

<template>
  <div class="settings-panel stitch-form">
    <section class="settings-section">
      <h2 class="settings-section__title">{{ ui.tr('settings.section.appearance') }}</h2>
      <div class="settings-row">
        <span class="settings-label">{{ ui.tr('settings.theme') }}</span>
        <el-radio-group v-model="theme" class="settings-radios">
          <el-radio-button value="light">{{ ui.tr('settings.theme.light') }}</el-radio-button>
          <el-radio-button value="dark">{{ ui.tr('settings.theme.dark') }}</el-radio-button>
        </el-radio-group>
      </div>
    </section>

    <section class="settings-section">
      <h2 class="settings-section__title">{{ ui.tr('settings.section.background') }}</h2>
      <p class="settings-hint">{{ ui.tr('settings.wallpaper.hint') }}</p>

      <!-- 底层壁纸 -->
      <div class="settings-block">
        <div class="settings-row settings-row--wrap">
          <span class="settings-label">{{ ui.tr('settings.wallpaper.shell') }}</span>
          <div class="settings-actions">
            <input
              ref="shellFileInput"
              type="file"
              accept="image/jpeg,image/png,image/webp"
              class="settings-file"
              @change="onFileChange($event, 'shell')"
            />
            <el-button type="primary" :loading="uploadingShell" @click="pickFile('shell')">
              {{ ui.tr('settings.wallpaper.upload') }}
            </el-button>
            <el-button :disabled="!ui.state.wallpaperUrl" @click="clearWallpaper('shell')">
              {{ ui.tr('settings.wallpaper.clear') }}
            </el-button>
          </div>
        </div>
        <div v-if="ui.state.wallpaperUrl" class="settings-preview">
          <img :src="ui.state.wallpaperUrl" alt="" />
        </div>
        <div class="settings-row">
          <span class="settings-label">{{ ui.tr('settings.wallpaper.fit') }}</span>
          <el-radio-group v-model="shellFit" class="settings-radios settings-radios--fit">
            <el-radio-button value="cover">{{ ui.tr('settings.wallpaper.fit.cover') }}</el-radio-button>
            <el-radio-button value="contain">{{ ui.tr('settings.wallpaper.fit.contain') }}</el-radio-button>
            <el-radio-button value="fill">{{ ui.tr('settings.wallpaper.fit.fill') }}</el-radio-button>
          </el-radio-group>
        </div>
        <div class="settings-row settings-row--slider">
          <span class="settings-label">{{ ui.tr('settings.shellOpacity') }}</span>
          <el-slider
            v-model="shellOpacity"
            :min="0"
            :max="100"
            :show-tooltip="true"
            @change="commitOpacity"
          />
          <span class="settings-value">{{ shellOpacity }}%</span>
        </div>
      </div>

      <!-- 主展示区壁纸 -->
      <div class="settings-block">
        <div class="settings-row settings-row--wrap">
          <span class="settings-label">{{ ui.tr('settings.wallpaper.panel') }}</span>
          <div class="settings-actions">
            <input
              ref="panelFileInput"
              type="file"
              accept="image/jpeg,image/png,image/webp"
              class="settings-file"
              @change="onFileChange($event, 'panel')"
            />
            <el-button type="primary" :loading="uploadingPanel" @click="pickFile('panel')">
              {{ ui.tr('settings.wallpaper.upload') }}
            </el-button>
            <el-button :disabled="!ui.state.panelWallpaperUrl" @click="clearWallpaper('panel')">
              {{ ui.tr('settings.wallpaper.clear') }}
            </el-button>
          </div>
        </div>
        <div v-if="ui.state.panelWallpaperUrl" class="settings-preview">
          <img :src="ui.state.panelWallpaperUrl" alt="" />
        </div>
        <div class="settings-row">
          <span class="settings-label">{{ ui.tr('settings.wallpaper.fit') }}</span>
          <el-radio-group v-model="panelFit" class="settings-radios settings-radios--fit">
            <el-radio-button value="cover">{{ ui.tr('settings.wallpaper.fit.cover') }}</el-radio-button>
            <el-radio-button value="contain">{{ ui.tr('settings.wallpaper.fit.contain') }}</el-radio-button>
            <el-radio-button value="fill">{{ ui.tr('settings.wallpaper.fit.fill') }}</el-radio-button>
          </el-radio-group>
        </div>
        <div class="settings-row settings-row--slider">
          <span class="settings-label">{{ ui.tr('settings.panelOpacity') }}</span>
          <el-slider
            v-model="panelOpacity"
            :min="0"
            :max="100"
            :show-tooltip="true"
            @change="commitOpacity"
          />
          <span class="settings-value">{{ panelOpacity }}%</span>
        </div>
        <div class="settings-row settings-row--slider">
          <span class="settings-label">{{ ui.tr('settings.moduleOpacity') }}</span>
          <el-slider
            v-model="moduleOpacity"
            :min="0"
            :max="100"
            :show-tooltip="true"
            @change="commitOpacity"
          />
          <span class="settings-value">{{ moduleOpacity }}%</span>
        </div>
        <div class="settings-row settings-row--slider">
          <span class="settings-label">{{ ui.tr('settings.moduleBlur') }}</span>
          <el-slider
            v-model="moduleBlur"
            :min="0"
            :max="100"
            :show-tooltip="true"
            @change="commitOpacity"
          />
          <span class="settings-value">{{ moduleBlur }}%</span>
        </div>
      </div>
    </section>

    <section class="settings-section">
      <h2 class="settings-section__title">{{ ui.tr('settings.section.layout') }}</h2>
      <div class="settings-row">
        <span class="settings-label">{{ ui.tr('settings.sidebarCollapsed') }}</span>
        <el-switch v-model="sidebarCollapsed" />
      </div>
      <div class="settings-row settings-row--wrap">
        <span class="settings-label">{{ ui.tr('settings.emphasisBlocks') }}</span>
        <el-switch v-model="contentEmphasis" />
      </div>
      <p class="settings-hint">{{ ui.tr('settings.emphasisBlocksHint') }}</p>
    </section>

    <section class="settings-section">
      <h2 class="settings-section__title">{{ ui.tr('settings.section.language') }}</h2>
      <div class="settings-row">
        <span class="settings-label">{{ ui.tr('settings.locale') }}</span>
        <el-radio-group v-model="locale" class="settings-radios">
          <el-radio-button value="zh-CN">{{ ui.tr('settings.locale.zh') }}</el-radio-button>
          <el-radio-button value="en-US">{{ ui.tr('settings.locale.en') }}</el-radio-button>
        </el-radio-group>
      </div>
    </section>
  </div>
</template>

<style scoped>
.settings-panel {
  max-width: 760px;
  padding: 8px 8px 32px;
}

.settings-section {
  margin-bottom: 28px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--st-outline-variant);
}

.settings-section:last-child {
  border-bottom: none;
}

.settings-section__title {
  margin: 0 0 14px;
  font-size: 15px;
  font-weight: 600;
  color: var(--st-on-surface);
}

.settings-hint {
  margin: 0 0 16px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.settings-block {
  margin-bottom: 22px;
  padding: 14px 16px;
  border-radius: 12px;
  background: var(--ul-settings-block-bg);
  border: 1px solid var(--st-outline-variant);
}

.settings-block:last-child {
  margin-bottom: 0;
}

.settings-row {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 14px;
}

.settings-row:last-child {
  margin-bottom: 0;
}

.settings-row--wrap {
  flex-wrap: wrap;
}

.settings-row--slider {
  align-items: center;
}

.settings-row--slider :deep(.el-slider) {
  flex: 1;
  max-width: 320px;
}

.settings-label {
  min-width: 140px;
  font-size: 14px;
  color: var(--st-on-surface);
}

.settings-value {
  width: 48px;
  text-align: right;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.settings-actions {
  display: flex;
  gap: 8px;
  align-items: center;
}

.settings-file {
  display: none;
}

.settings-preview {
  width: 100%;
  max-width: 360px;
  height: 120px;
  margin: 0 0 14px 140px;
  border-radius: 10px;
  overflow: hidden;
  border: 1px solid var(--st-outline-variant);
  background: var(--st-surface-container-low);
}

.settings-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.settings-radios :deep(.el-radio-button__inner) {
  min-width: 88px;
}

.settings-radios--fit :deep(.el-radio-button__inner) {
  min-width: 96px;
  padding-left: 12px;
  padding-right: 12px;
}

@media (max-width: 640px) {
  .settings-preview {
    margin-left: 0;
  }
}
</style>
