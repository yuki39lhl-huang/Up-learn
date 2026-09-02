<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { Camera } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { fetchUserInfo, uploadUserAvatar, updateUserProfile } from '../../api/user'
import { useAuthStore } from '../../stores/auth'
import AvatarCropDialog from './AvatarCropDialog.vue'
import { AVATAR_MAX_INPUT_BYTES, formatFileSize } from '../../utils/avatarImage'

const emit = defineEmits<{
  logout: []
}>()

const auth = useAuthStore()

type AccountTab = 'profile' | 'security'

const accountTab = ref<AccountTab>('profile')
const nicknameDraft = ref(auth.user?.nickname ?? '')
const saving = ref(false)
const uploading = ref(false)
const fileInput = ref<HTMLInputElement | null>(null)
const cropOpen = ref(false)
const cropFile = ref<File | null>(null)

const accountNav: { key: AccountTab; label: string }[] = [
  { key: 'profile', label: '基本信息' },
  { key: 'security', label: '账号安全' },
]

const pageTitle = computed(() =>
  accountTab.value === 'profile' ? '基本信息' : '账号安全',
)

watch(
  () => auth.user?.nickname,
  (v) => {
    nicknameDraft.value = v ?? ''
  },
)

onMounted(async () => {
  try {
    const info = await fetchUserInfo()
    auth.patchUser({ nickname: info.nickname, avatarUrl: info.avatarUrl })
  } catch {
    /* 静默失败 */
  }
})

function openFilePicker() {
  fileInput.value?.click()
}

function onAvatarSelected(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  input.value = ''
  if (!file) return

  if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
    ElMessage.warning('仅支持 JPG / PNG / WebP')
    return
  }
  if (file.size > AVATAR_MAX_INPUT_BYTES) {
    ElMessage.warning(`原图不能超过 ${formatFileSize(AVATAR_MAX_INPUT_BYTES)}`)
    return
  }

  cropFile.value = file
  cropOpen.value = true
}

async function onCropConfirm(blob: Blob) {
  cropFile.value = null
  uploading.value = true
  try {
    const file = new File([blob], 'avatar.jpg', { type: 'image/jpeg' })
    const { avatarUrl } = await uploadUserAvatar(file)
    auth.patchUser({ avatarUrl })
    ElMessage.success('头像已更新')
  } catch (err) {
    ElMessage.error(err instanceof Error ? err.message : '头像上传失败')
  } finally {
    uploading.value = false
  }
}

async function saveProfile() {
  const nickname = nicknameDraft.value.trim()
  if (!nickname) {
    ElMessage.warning('昵称不能为空')
    return
  }
  if (nickname === auth.user?.nickname) {
    ElMessage.info('没有需要保存的修改')
    return
  }
  saving.value = true
  try {
    const info = await updateUserProfile({ nickname })
    auth.patchUser({ nickname: info.nickname, avatarUrl: info.avatarUrl })
    ElMessage.success('已保存')
  } catch (err) {
    ElMessage.error(err instanceof Error ? err.message : '保存失败')
  } finally {
    saving.value = false
  }
}

async function handleLogout() {
  emit('logout')
}
</script>

<template>
  <div class="account-layout">
    <aside class="account-sidebar">
      <div class="account-user-card">
        <p class="account-user-card__name">{{ auth.user?.nickname ?? '用户' }}</p>
        <div class="account-avatar-box">
          <el-avatar :size="120" shape="square" class="account-avatar-box__img" :src="auth.user?.avatarUrl">
            {{ auth.user?.nickname?.slice(0, 1) ?? 'U' }}
          </el-avatar>
          <button
            type="button"
            class="account-avatar-box__camera"
            :disabled="uploading"
            aria-label="更换头像"
            @click="openFilePicker"
          >
            <el-icon><Camera /></el-icon>
          </button>
        </div>
      </div>

      <nav class="account-nav" aria-label="账号设置">
        <button
          v-for="item in accountNav"
          :key="item.key"
          type="button"
          class="account-nav__item"
          :class="{ 'account-nav__item--active': accountTab === item.key }"
          @click="accountTab = item.key"
        >
          {{ item.label }}
        </button>
      </nav>

      <button type="button" class="account-logout" @click="handleLogout">退出登录</button>
    </aside>

    <section class="account-main">
      <header class="account-main__head">
        <h2>{{ pageTitle }}</h2>
        <el-button
          v-if="accountTab === 'profile'"
          type="primary"
          :loading="saving"
          @click="saveProfile"
        >
          保存
        </el-button>
      </header>

      <div v-if="accountTab === 'profile'" class="account-form">
        <div class="account-field">
          <label class="account-field__label" for="profile-nickname">
            <span class="account-field__required">*</span> 昵称
          </label>
          <el-input
            id="profile-nickname"
            v-model="nicknameDraft"
            maxlength="32"
            show-word-limit
            placeholder="请输入昵称"
          />
        </div>

        <div class="account-field">
          <label class="account-field__label" for="profile-email">邮箱</label>
          <el-input id="profile-email" :model-value="auth.user?.email ?? '—'" disabled />
        </div>

        <div class="account-field">
          <label class="account-field__label" for="profile-id">用户 ID</label>
          <el-input id="profile-id" :model-value="String(auth.user?.userId ?? '—')" disabled />
        </div>
      </div>

      <div v-else class="account-placeholder">
        <h3>账号安全</h3>
        <p>密码、登录设备管理等功能将在后续版本开放。</p>
      </div>
    </section>

    <input
      ref="fileInput"
      type="file"
      accept="image/jpeg,image/png,image/webp"
      class="account-file-input"
      @change="onAvatarSelected"
    />
    <AvatarCropDialog v-model="cropOpen" :file="cropFile" @confirm="onCropConfirm" />
  </div>
</template>

<style scoped>
.account-layout {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr);
  gap: 20px;
  min-height: 520px;
  padding: 20px 24px 24px;
}

.account-sidebar {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.account-user-card {
  padding: 16px 12px 20px;
  border-radius: 12px;
  background: rgb(255 255 255 / 72%);
  border: 1px solid rgb(226 232 240 / 80%);
  text-align: center;
}

.account-user-card__name {
  margin: 0 0 14px;
  font-size: 15px;
  font-weight: 700;
  color: var(--st-on-surface);
}

.account-avatar-box {
  position: relative;
  display: inline-block;
}

.account-avatar-box__img {
  border-radius: 12px !important;
  background: linear-gradient(145deg, #dbeafe, #eff6ff);
  color: #2563eb;
  font-size: 36px;
  font-weight: 700;
}

.account-avatar-box__camera {
  position: absolute;
  right: -4px;
  bottom: -4px;
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border: 2px solid #fff;
  border-radius: 50%;
  background: rgb(15 23 42 / 78%);
  color: #fff;
  cursor: pointer;
  box-shadow: 0 4px 12px rgb(15 23 42 / 18%);
}

.account-avatar-box__camera:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.account-nav {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.account-nav__item {
  width: 100%;
  padding: 11px 14px;
  border: none;
  border-radius: 8px;
  background: transparent;
  text-align: left;
  font-size: 14px;
  color: var(--st-on-surface-variant);
  cursor: pointer;
  transition: background 0.15s, color 0.15s;
}

.account-nav__item:hover {
  background: rgb(59 130 246 / 8%);
  color: #2563eb;
}

.account-nav__item--active {
  background: rgb(59 130 246 / 12%);
  color: #2563eb;
  font-weight: 600;
}

.account-logout {
  margin-top: auto;
  padding: 10px 14px;
  border: 1px solid rgb(239 68 68 / 35%);
  border-radius: 8px;
  background: transparent;
  color: #dc2626;
  font-size: 13px;
  cursor: pointer;
}

.account-logout:hover {
  background: rgb(239 68 68 / 8%);
}

.account-main {
  padding: 8px 8px 24px;
  border-radius: 12px;
  background: rgb(255 255 255 / 55%);
  border: 1px solid rgb(226 232 240 / 65%);
}

.account-main__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgb(226 232 240 / 70%);
}

.account-main__head h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
}

.account-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 640px;
}

.account-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.account-field__label {
  font-size: 14px;
  font-weight: 600;
  color: var(--st-on-surface);
}

.account-field__required {
  color: #ef4444;
  margin-right: 2px;
}

.account-placeholder {
  padding: 12px 4px;
}

.account-placeholder h3 {
  margin: 0 0 8px;
  font-size: 16px;
}

.account-placeholder p {
  margin: 0;
  color: var(--st-on-surface-variant);
  font-size: 14px;
  line-height: 1.6;
}

.account-file-input {
  display: none;
}

@media (max-width: 860px) {
  .account-layout {
    grid-template-columns: 1fr;
  }

  .account-sidebar {
    flex-direction: row;
    flex-wrap: wrap;
    align-items: flex-start;
  }

  .account-user-card {
    flex: 1;
    min-width: 180px;
  }

  .account-nav {
    flex: 1;
    min-width: 160px;
  }

  .account-logout {
    width: 100%;
    margin-top: 0;
  }
}
</style>
