import request, { getData } from './request'
import type { LoginVO, UserExamPreferenceVO } from '../types/api'

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

export function fetchExamPreference() {
  return getData<UserExamPreferenceVO | null>(request.get('/user/exam-preference'))
}

export function saveExamPreference(preference: Omit<UserExamPreferenceVO, 'id' | 'userId'>) {
  return getData<UserExamPreferenceVO>(request.put('/user/exam-preference', preference))
}

export function deleteExamPreference() {
  return getData(request.delete('/user/exam-preference'))
}
