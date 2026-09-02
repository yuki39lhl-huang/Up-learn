import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { LoginVO } from '../types/api'

const ACCESS_KEY = 'ul_access_token'
const REFRESH_KEY = 'ul_refresh_token'
const USER_KEY = 'ul_user'

/** 登录态：Access Token + 用户摘要，持久化到 localStorage */
export const useAuthStore = defineStore('auth', () => {
  const accessToken = ref(localStorage.getItem(ACCESS_KEY) ?? '')
  const refreshToken = ref(localStorage.getItem(REFRESH_KEY) ?? '')
  const user = ref<Pick<LoginVO, 'userId' | 'email' | 'nickname' | 'avatarUrl'> | null>(
    readUser()
  )

  const isLoggedIn = computed(() => !!accessToken.value)

  function readUser() {
    const raw = localStorage.getItem(USER_KEY)
    if (!raw) return null
    try {
      return JSON.parse(raw) as Pick<LoginVO, 'userId' | 'email' | 'nickname' | 'avatarUrl'>
    } catch {
      return null
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
    }
    localStorage.setItem(ACCESS_KEY, vo.accessToken)
    localStorage.setItem(REFRESH_KEY, vo.refreshToken)
    localStorage.setItem(USER_KEY, JSON.stringify(user.value))
  }

  function clearSession() {
    accessToken.value = ''
    refreshToken.value = ''
    user.value = null
    localStorage.removeItem(ACCESS_KEY)
    localStorage.removeItem(REFRESH_KEY)
    localStorage.removeItem(USER_KEY)
  }

  function patchUser(patch: Partial<Pick<LoginVO, 'nickname' | 'avatarUrl'>>) {
    if (!user.value) return
    user.value = { ...user.value, ...patch }
    localStorage.setItem(USER_KEY, JSON.stringify(user.value))
  }

  return { accessToken, refreshToken, user, isLoggedIn, setSession, clearSession, patchUser }
})
