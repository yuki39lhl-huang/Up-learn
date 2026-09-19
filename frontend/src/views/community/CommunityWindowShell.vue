<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import BrandLogo from '../../components/stitch/BrandLogo.vue'
import { useAuthStore } from '../../stores/auth'
import { openCommunityWindow } from '../../api/community'
import '../../styles/console-workbench.css'

defineProps<{
  title: string
}>()

const router = useRouter()
const auth = useAuthStore()

const displayName = computed(() => auth.user?.nickname || '用户')

function goConsoleCommunity() {
  void router.push({ path: '/console', hash: '#community' })
}

function openMyProfile() {
  const id = auth.user?.userId
  if (!id) return
  if (router.currentRoute.value.path.startsWith(`/community/u/${id}`)) return
  void router.push(`/community/u/${id}`)
}

function openCompose() {
  openCommunityWindow('/community/compose')
}
</script>

<template>
  <div class="cm-win">
    <header class="cm-win__bar">
      <button type="button" class="cm-win__brand" @click="goConsoleCommunity">
        <BrandLogo />
      </button>
      <h1 class="cm-win__title">{{ title }}</h1>
      <div class="cm-win__spacer" />
      <el-button type="primary" size="small" @click="openCompose">发布</el-button>
      <button type="button" class="cm-win__user" title="个人主页 / 设置" @click="openMyProfile">
        <el-avatar :size="28" :src="auth.user?.avatarUrl || undefined">
          {{ displayName.slice(0, 1) }}
        </el-avatar>
        <span>{{ displayName }}</span>
      </button>
    </header>
    <main class="cm-win__body">
      <slot />
    </main>
  </div>
</template>

<style scoped>
.cm-win {
  min-height: 100vh;
  min-height: 100dvh;
  background:
    radial-gradient(900px 420px at 12% -10%, color-mix(in srgb, var(--st-primary) 14%, transparent), transparent 60%),
    radial-gradient(700px 360px at 90% 0%, color-mix(in srgb, var(--st-primary-container) 18%, transparent), transparent 55%),
    var(--st-surface);
  color: var(--st-on-surface);
}

.cm-win__bar {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  gap: 12px;
  height: 56px;
  padding: 0 16px;
  backdrop-filter: blur(10px);
  background: color-mix(in srgb, var(--st-surface) 82%, transparent);
  border-bottom: 1px solid color-mix(in srgb, var(--st-outline-variant) 50%, transparent);
}

.cm-win__brand {
  border: none;
  background: transparent;
  padding: 0;
  cursor: pointer;
}

.cm-win__title {
  margin: 0;
  font-size: 15px;
  font-weight: 700;
}

.cm-win__spacer {
  flex: 1;
}

.cm-win__user {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  border: none;
  background: transparent;
  padding: 4px 6px;
  border-radius: 999px;
  cursor: pointer;
  font: inherit;
}

.cm-win__user:hover {
  background: color-mix(in srgb, var(--st-primary) 8%, transparent);
  color: var(--st-primary);
}

.cm-win__body {
  max-width: 860px;
  margin: 0 auto;
  padding: 20px 16px 48px;
}
</style>
