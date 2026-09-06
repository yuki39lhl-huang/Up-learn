import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { LoginVO, UserInfoVO } from '../types/api'
import { fetchUserInfo } from '../api/user'

const ACCESS_KEY = 'ul_access_token'
const REFRESH_KEY = 'ul_refresh_token'
const USER_KEY = 'ul_user'

type UserSummary = Pick<LoginVO, 'userId' | 'email' | 'nickname' | 'avatarUrl' | 'hasPassword'>

/** 登录态：Access Token + 用户摘要，持久化到 localStorage */
export const useAuthStore = defineStore('auth', () => {
  const accessToken = ref(localStorage.getItem(ACCESS_KEY) ?? '')
  const refreshToken = ref(localStorage.getItem(REFRESH_KEY) ?? '')
  const user = ref<UserSummary | null>(readUser())

  const isLoggedIn = computed(() => !!accessToken.value)

  function readUser() {
    const raw = localStorage.getItem(USER_KEY)
    if (!raw) return null
    try {
      return JSON.parse(raw) as UserSummary
    } catch {
      return null
    }
  }

  function persistUser() {
    if (user.value) {
      localStorage.setItem(USER_KEY, JSON.stringify(user.value))
    }
  }

  function setSession(vo: LoginVO) {
    accessToken.value = vo.accessToken
    refreshToken.value = vo.refreshToken
    user.value = {
      userId: vo.userId,
      email: vo.email,
      nickname: vo.nickname,
      avatarUrl: vo.avatarUrl,
      hasPassword: vo.hasPassword,
    }
    localStorage.setItem(ACCESS_KEY, vo.accessToken)
    localStorage.setItem(REFRESH_KEY, vo.refreshToken)
    persistUser()
  }

  function clearSession() {
    accessToken.value = ''
    refreshToken.value = ''
    user.value = null
    localStorage.removeItem(ACCESS_KEY)
    localStorage.removeItem(REFRESH_KEY)
    localStorage.removeItem(USER_KEY)
  }

  function patchUser(patch: Partial<Pick<UserSummary, 'nickname' | 'avatarUrl' | 'hasPassword'>>) {
    if (!user.value) return
    user.value = { ...user.value, ...patch }
    persistUser()
  }

  /** 刷新资料与头像签名 URL（私有 OSS 签名约 2h 过期） */
  async function refreshProfile(): Promise<UserInfoVO | null> {
    if (!accessToken.value) return null
    try {
      const info = await fetchUserInfo()
      patchUser({
        nickname: info.nickname,
        avatarUrl: info.avatarUrl,
        hasPassword: info.hasPassword,
      })
      return info
    } catch {
      return null
    }
  }

  return {
    accessToken,
    refreshToken,
    user,
    isLoggedIn,
    setSession,
    clearSession,
    patchUser,
    refreshProfile,
  }
})
