<script setup lang="ts">
/**
 * 控制台「账号」面板：基本信息（昵称/头像）+ 账号安全。
 * 账号安全：未设密可直接设密；已设密则「当前密码修改」与「邮箱验证码重置」二选一 Tab，
 * 重置成功后覆盖 password_hash。登录页不提供忘记密码。
 */
import { computed, onMounted, ref, watch } from 'vue'
import { Camera } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import {
  changePassword,
  fetchUserInfo,
  resetPassword,
  sendForgotPasswordCode,
  uploadUserAvatar,
  updateUserProfile,
} from '../../api/user'
import { useAuthStore } from '../../stores/auth'
import AvatarCropDialog from './AvatarCropDialog.vue'
import { AVATAR_MAX_INPUT_BYTES, formatFileSize } from '../../utils/avatarImage'
import { normalizeLoginCode } from '../../utils/loginCode'
import { validateNewPasswordPair } from '../../utils/password'

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

const hasPassword = ref(!!auth.user?.hasPassword)
/** 已设密时：用当前密码改 / 用邮箱验证码覆盖重置（二选一，不同时展示） */
type SecurityMode = 'byPassword' | 'byEmail'
const securityMode = ref<SecurityMode>('byPassword')

const oldPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const savingPassword = ref(false)

const resetCode = ref('')
const resetNewPassword = ref('')
const resetConfirmPassword = ref('')
const resetSending = ref(false)
const resetSaving = ref(false)
const resetCountdown = ref(0)
let resetTimer: ReturnType<typeof setInterval> | null = null

const accountNav: { key: AccountTab; label: string }[] = [
  { key: 'profile', label: '基本信息' },
  { key: 'security', label: '账号安全' },
]

const pageTitle = computed(() =>
  accountTab.value === 'profile' ? '基本信息' : '账号安全',
)

const passwordTitle = computed(() => (hasPassword.value ? '修改密码' : '设置密码'))

function warn(msg: string) {
  ElMessage.closeAll()
  ElMessage.warning(msg)
}

function switchSecurityMode(mode: SecurityMode) {
  securityMode.value = mode
  oldPassword.value = ''
  newPassword.value = ''
  confirmPassword.value = ''
  resetCode.value = ''
  resetNewPassword.value = ''
  resetConfirmPassword.value = ''
}

watch(
  () => auth.user?.nickname,
  (v) => {
    nicknameDraft.value = v ?? ''
  },
)

watch(
  () => auth.user?.hasPassword,
  (v) => {
    hasPassword.value = !!v
  },
)

onMounted(async () => {
  try {
    const info = await fetchUserInfo()
    auth.patchUser({
      nickname: info.nickname,
      avatarUrl: info.avatarUrl,
      hasPassword: info.hasPassword,
    })
    hasPassword.value = !!info.hasPassword
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
    auth.patchUser({
      nickname: info.nickname,
      avatarUrl: info.avatarUrl,
      hasPassword: info.hasPassword,
    })
    ElMessage.success('已保存')
  } catch (err) {
    ElMessage.error(err instanceof Error ? err.message : '保存失败')
  } finally {
    saving.value = false
  }
}

async function savePassword() {
  if (hasPassword.value && !oldPassword.value.trim()) {
    warn('请输入当前密码')
    return
  }
  const pairError = validateNewPasswordPair(newPassword.value, confirmPassword.value)
  if (pairError) {
    warn(pairError)
    return
  }
  const next = newPassword.value.trim()
  savingPassword.value = true
  try {
    const wasSet = hasPassword.value
    await changePassword({
      oldPassword: wasSet ? oldPassword.value.trim() : undefined,
      newPassword: next,
    })
    hasPassword.value = true
    auth.patchUser({ hasPassword: true })
    oldPassword.value = ''
    newPassword.value = ''
    confirmPassword.value = ''
    ElMessage.closeAll()
    ElMessage.success(wasSet ? '密码已更新' : '密码已设置，之后可用密码登录')
  } catch (err) {
    ElMessage.closeAll()
    ElMessage.error(err instanceof Error ? err.message : '操作失败')
  } finally {
    savingPassword.value = false
  }
}

function startResetCountdown() {
  resetCountdown.value = 60
  if (resetTimer) clearInterval(resetTimer)
  resetTimer = setInterval(() => {
    resetCountdown.value -= 1
    if (resetCountdown.value <= 0 && resetTimer) {
      clearInterval(resetTimer)
      resetTimer = null
    }
  }, 1000)
}

async function handleSendResetCode() {
  const email = auth.user?.email
  if (!email) {
    warn('未获取到邮箱')
    return
  }
  resetSending.value = true
  try {
    await sendForgotPasswordCode(email)
    ElMessage.closeAll()
    ElMessage.success('验证码已发送（开发环境见 user-service 日志）')
    startResetCountdown()
  } catch (err) {
    ElMessage.closeAll()
    ElMessage.error(err instanceof Error ? err.message : '发送失败')
  } finally {
    resetSending.value = false
  }
}

async function handleResetByCode() {
  const email = auth.user?.email
  if (!email) {
    warn('未获取到邮箱')
    return
  }
  const code = normalizeLoginCode(resetCode.value)
  if (!code) {
    warn('请输入验证码')
    return
  }
  if (code.length !== 6) {
    warn(`验证码须为 6 位数字（当前 ${code.length} 位）`)
    return
  }
  const pairError = validateNewPasswordPair(resetNewPassword.value, resetConfirmPassword.value)
  if (pairError) {
    warn(pairError)
    return
  }
  const next = resetNewPassword.value.trim()
  resetSaving.value = true
  try {
    await resetPassword({ email, code, newPassword: next })
    hasPassword.value = true
    auth.patchUser({ hasPassword: true })
    securityMode.value = 'byPassword'
    resetCode.value = ''
    resetNewPassword.value = ''
    resetConfirmPassword.value = ''
    oldPassword.value = ''
    newPassword.value = ''
    confirmPassword.value = ''
    ElMessage.closeAll()
    ElMessage.success('密码已覆盖更新，之后请用新密码登录')
  } catch (err) {
    ElMessage.closeAll()
    ElMessage.error(err instanceof Error ? err.message : '重置失败')
  } finally {
    resetSaving.value = false
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
          <el-avatar :size="138" shape="square" class="account-avatar-box__img" :src="auth.user?.avatarUrl">
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
          size="large"
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
            size="large"
            maxlength="32"
            show-word-limit
            placeholder="请输入昵称"
          />
        </div>

        <div class="account-field">
          <label class="account-field__label" for="profile-email">邮箱</label>
          <el-input id="profile-email" size="large" :model-value="auth.user?.email ?? '—'" disabled />
        </div>

        <div class="account-field">
          <label class="account-field__label" for="profile-id">用户 ID</label>
          <el-input id="profile-id" size="large" :model-value="String(auth.user?.userId ?? '—')" disabled />
        </div>
      </div>

      <div v-else class="account-form account-security">
        <p class="account-security__lead">
          {{
            !hasPassword
              ? '邮箱验证码登录后尚未设置密码。填写新密码即可开通密码登录（无需旧密码）。'
              : securityMode === 'byPassword'
                ? '验证当前密码后设置新密码。'
                : '校验邮箱验证码通过后，将直接覆盖原密码为新密码（旧密码立即失效）。'
          }}
        </p>

        <div v-if="hasPassword" class="account-security__tabs" role="tablist">
          <button
            type="button"
            class="account-security__tab"
            :class="{ 'account-security__tab--active': securityMode === 'byPassword' }"
            @click="switchSecurityMode('byPassword')"
          >
            当前密码修改
          </button>
          <button
            type="button"
            class="account-security__tab"
            :class="{ 'account-security__tab--active': securityMode === 'byEmail' }"
            @click="switchSecurityMode('byEmail')"
          >
            邮箱验证码重置
          </button>
        </div>

        <!-- 首次设密 / 用当前密码修改 -->
        <template v-if="!hasPassword || securityMode === 'byPassword'">
          <div v-if="hasPassword" class="account-field">
            <label class="account-field__label" for="security-old-password">当前密码</label>
            <el-input
              id="security-old-password"
              v-model="oldPassword"
              type="password"
              size="large"
              show-password
              placeholder="请输入当前密码"
              autocomplete="current-password"
            />
          </div>

          <div class="account-field">
            <label class="account-field__label" for="security-new-password">
              <span class="account-field__required">*</span>
              {{ hasPassword ? '新密码' : '设置密码' }}
            </label>
            <el-input
              id="security-new-password"
              v-model="newPassword"
              type="password"
              size="large"
              show-password
              placeholder="8～32 位，需同时包含字母与数字"
              autocomplete="new-password"
            />
          </div>

          <div class="account-field">
            <label class="account-field__label" for="security-confirm-password">
              <span class="account-field__required">*</span> 确认密码
            </label>
            <el-input
              id="security-confirm-password"
              v-model="confirmPassword"
              type="password"
              size="large"
              show-password
              placeholder="再次输入密码"
              autocomplete="new-password"
            />
          </div>

          <div class="account-security__actions">
            <el-button type="primary" size="large" :loading="savingPassword" @click="savePassword">
              {{ passwordTitle }}
            </el-button>
          </div>
        </template>

        <!-- 邮箱验证码覆盖重置（与上方互斥） -->
        <template v-else>
          <p class="account-security__hint">
            验证码发送至 <strong>{{ auth.user?.email }}</strong>
            <span class="account-security__hint-sub">（开发环境见 user-service 日志）</span>
          </p>
          <div class="account-field">
            <label class="account-field__label" for="reset-code">验证码</label>
            <div class="account-code-row">
              <el-input
                id="reset-code"
                :model-value="resetCode"
                size="large"
                placeholder="6 位数字"
                inputmode="numeric"
                @update:model-value="(v: string) => (resetCode = normalizeLoginCode(v))"
              />
              <el-button
                size="large"
                :disabled="resetCountdown > 0"
                :loading="resetSending"
                @click="handleSendResetCode"
              >
                {{ resetCountdown > 0 ? `${resetCountdown}s` : '发送验证码' }}
              </el-button>
            </div>
          </div>
          <div class="account-field">
            <label class="account-field__label" for="reset-new-password">
              <span class="account-field__required">*</span> 新密码
            </label>
            <el-input
              id="reset-new-password"
              v-model="resetNewPassword"
              type="password"
              size="large"
              show-password
              placeholder="8～32 位，需同时包含字母与数字"
              autocomplete="new-password"
            />
          </div>
          <div class="account-field">
            <label class="account-field__label" for="reset-confirm-password">
              <span class="account-field__required">*</span> 确认新密码
            </label>
            <el-input
              id="reset-confirm-password"
              v-model="resetConfirmPassword"
              type="password"
              size="large"
              show-password
              placeholder="再次输入新密码"
              autocomplete="new-password"
            />
          </div>
          <div class="account-security__actions">
            <el-button type="primary" size="large" :loading="resetSaving" @click="handleResetByCode">
              确认覆盖密码
            </el-button>
          </div>
        </template>
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
  --acc-scale: 1.15;

  display: grid;
  grid-template-columns: calc(220px * var(--acc-scale)) minmax(0, 1fr);
  gap: calc(20px * var(--acc-scale));
  box-sizing: border-box;
  flex: 1;
  min-height: 0;
  padding: calc(24px * var(--acc-scale)) calc(28px * var(--acc-scale)) calc(28px * var(--acc-scale));
}

.account-sidebar {
  display: flex;
  flex-direction: column;
  gap: calc(16px * var(--acc-scale));
}

.account-user-card {
  padding: calc(20px * var(--acc-scale)) calc(16px * var(--acc-scale)) calc(24px * var(--acc-scale));
  border-radius: calc(12px * var(--acc-scale));
  background: rgb(255 255 255 / 72%);
  border: 1px solid rgb(226 232 240 / 80%);
  text-align: center;
}

.account-user-card__name {
  margin: 0 0 calc(16px * var(--acc-scale));
  font-size: calc(15px * var(--acc-scale));
  font-weight: 700;
  color: var(--st-on-surface);
}

.account-avatar-box {
  position: relative;
  display: inline-block;
}

.account-avatar-box__img {
  border-radius: calc(12px * var(--acc-scale)) !important;
  background: linear-gradient(145deg, #dbeafe, #eff6ff);
  color: #2563eb;
  font-size: calc(36px * var(--acc-scale));
  font-weight: 700;
}

.account-avatar-box__camera {
  position: absolute;
  right: -4px;
  bottom: -4px;
  width: calc(34px * var(--acc-scale));
  height: calc(34px * var(--acc-scale));
  font-size: calc(16px * var(--acc-scale));
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
  gap: calc(6px * var(--acc-scale));
}

.account-nav__item {
  width: 100%;
  padding: calc(13px * var(--acc-scale)) calc(16px * var(--acc-scale));
  border: none;
  border-radius: calc(10px * var(--acc-scale));
  background: transparent;
  text-align: left;
  font-size: calc(14px * var(--acc-scale));
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
  padding: calc(12px * var(--acc-scale)) calc(16px * var(--acc-scale));
  border: 1px solid rgb(239 68 68 / 35%);
  border-radius: calc(10px * var(--acc-scale));
  background: transparent;
  color: #dc2626;
  font-size: calc(13px * var(--acc-scale));
  cursor: pointer;
}

.account-logout:hover {
  background: rgb(239 68 68 / 8%);
}

.account-main {
  display: flex;
  flex-direction: column;
  min-height: 0;
  padding: calc(16px * var(--acc-scale)) calc(20px * var(--acc-scale)) calc(28px * var(--acc-scale));
  border-radius: calc(12px * var(--acc-scale));
  background: rgb(255 255 255 / 55%);
  border: 1px solid rgb(226 232 240 / 65%);
}

.account-main__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: calc(28px * var(--acc-scale));
  padding-bottom: calc(14px * var(--acc-scale));
  border-bottom: 1px solid rgb(226 232 240 / 70%);
}

.account-main__head h2 {
  margin: 0;
  font-size: calc(18px * var(--acc-scale));
  font-weight: 700;
}

.account-form {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: calc(28px * var(--acc-scale));
  max-width: min(820px, 100%);
}

.account-field {
  display: flex;
  flex-direction: column;
  gap: calc(10px * var(--acc-scale));
}

.account-field__label {
  font-size: calc(14px * var(--acc-scale));
  font-weight: 600;
  color: var(--st-on-surface);
}

.account-field :deep(.el-input__wrapper) {
  min-height: calc(40px * var(--acc-scale));
  font-size: calc(14px * var(--acc-scale));
}

.account-field :deep(.el-input__count) {
  font-size: calc(12px * var(--acc-scale));
}

.account-field__required {
  color: #ef4444;
  margin-right: 2px;
}

.account-placeholder {
  flex: 1;
  padding: calc(12px * var(--acc-scale)) calc(4px * var(--acc-scale));
}

.account-placeholder h3 {
  margin: 0 0 calc(10px * var(--acc-scale));
  font-size: calc(16px * var(--acc-scale));
}

.account-placeholder p {
  margin: 0;
  color: var(--st-on-surface-variant);
  font-size: calc(14px * var(--acc-scale));
  line-height: 1.6;
}

.account-security__lead {
  margin: 0 0 calc(8px * var(--acc-scale));
  font-size: calc(14px * var(--acc-scale));
  color: var(--st-on-surface-variant);
  line-height: 1.6;
}

.account-security__tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px;
  margin-bottom: calc(4px * var(--acc-scale));
  padding: 4px;
  border-radius: 10px;
  background: var(--st-surface-container-low, #f0f3ff);
}

.account-security__tab {
  height: 36px;
  border: none;
  border-radius: 8px;
  background: transparent;
  font-size: calc(13px * var(--acc-scale));
  color: var(--st-on-surface-variant);
  cursor: pointer;
}

.account-security__tab--active {
  background: #fff;
  color: var(--st-on-surface);
  font-weight: 600;
  box-shadow: 0 1px 2px rgb(21 28 39 / 8%);
}

.account-security__hint {
  margin: 0;
  font-size: calc(13px * var(--acc-scale));
  color: var(--st-on-surface-variant);
  line-height: 1.5;
}

.account-security__hint-sub {
  margin-left: 4px;
  opacity: 0.85;
}

.account-security__actions {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: calc(12px * var(--acc-scale));
  margin-top: calc(8px * var(--acc-scale));
}

.account-code-row {
  display: flex;
  gap: 8px;
  width: 100%;
}

.account-code-row .el-input {
  flex: 1;
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
