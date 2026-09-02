import request, { getData } from './request'
import type { LoginVO, UserExamPreferenceVO, UserInfoVO, UserTargetVO } from '../types/api'

export function sendLoginCode(email: string) {
  return getData(request.post('/user/login/send-code', { email }))
}

export function loginByCode(email: string, code: string) {
  return getData<LoginVO>(request.post('/user/login', { email, code }))
}

export function refreshAccessToken(refreshToken: string) {
  return getData<LoginVO>(request.post('/user/token/refresh', { refreshToken }))
}

export function logout(refreshToken: string) {
  return getData(request.post('/user/logout', { refreshToken }))
}

export function fetchUserInfo() {
  return getData<UserInfoVO>(request.get('/user/info'))
}

export function updateUserProfile(payload: { nickname?: string; avatarUrl?: string }) {
  return getData<UserInfoVO>(request.put('/user/info', payload))
}

export function uploadUserAvatar(file: File) {
  const form = new FormData()
  form.append('file', file)
  return getData<{ avatarUrl: string }>(
    request.post('/user/avatar', form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    }),
  )
}

export function fetchExamPreference() {
  return getData<UserExamPreferenceVO | null>(request.get('/user/exam-preference'))
}

export function saveExamPreference(preference: Omit<UserExamPreferenceVO, 'id' | 'userId'>) {
  return getData<UserExamPreferenceVO>(request.put('/user/exam-preference', preference))
}

export function saveRandomSubjectFilter(payload: {
  randomSubjectMode: 'all' | 'single'
  randomSubject?: string
}) {
  // 仅更新随机刷题筛选，不触发完整备考保存
  return getData<UserExamPreferenceVO>(request.put('/user/exam-preference/random-filter', payload))
}

export function deleteExamPreference() {
  return getData(request.delete('/user/exam-preference'))
}

export function fetchUserTargets() {
  return getData<UserTargetVO[]>(request.get('/user/targets'))
}

export function addUserTarget(payload: { schoolId: number; majorId?: number }) {
  return getData<UserTargetVO>(request.post('/user/targets', payload))
}

export function removeUserTarget(id: number) {
  return getData<void>(request.delete(`/user/targets/${id}`))
}
