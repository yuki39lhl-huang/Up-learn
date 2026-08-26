import request, { getData } from './request'
import type { LoginVO } from '../types/api'

export function sendLoginCode(email: string) {
  return getData(request.post('/user/login/send-code', { email }))
}

export function loginByCode(email: string, code: string) {
  return getData<LoginVO>(request.post('/user/login', { email, code }))
}

export function logout(refreshToken: string) {
  return getData(request.post('/user/logout', { refreshToken }))
}
