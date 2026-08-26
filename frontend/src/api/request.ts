import axios from 'axios'
import type { Result } from '../types/api'
import { useAuthStore } from '../stores/auth'

const request = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

/** 请求前自动带 Bearer Access Token（走网关 8082） */
request.interceptors.request.use((config) => {
  const auth = useAuthStore()
  if (auth.accessToken) {
    config.headers.Authorization = `Bearer ${auth.accessToken}`
  }
  return config
})

/** 统一解包 Result；code !== 200 视为业务失败 */
request.interceptors.response.use(
  (response) => {
    const body = response.data as Result<unknown>
    if (body.code !== 200) {
      return Promise.reject(new Error(body.msg || '请求失败'))
    }
    return response
  },
  (error) => {
    const msg =
      error.response?.data?.msg ||
      error.message ||
      '网络异常，请确认网关与各服务已启动'
    return Promise.reject(new Error(msg))
  }
)

export default request

/** 取 data 字段的便捷方法 */
export async function getData<T>(promise: Promise<{ data: Result<T> }>): Promise<T> {
  const res = await promise
  return res.data.data
}
