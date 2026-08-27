import axios, { type AxiosError, type InternalAxiosRequestConfig } from 'axios'
import type { LoginVO, Result } from '../types/api'
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

let refreshPromise: Promise<void> | null = null

async function ensureFreshAccessToken(): Promise<void> {
  const auth = useAuthStore()
  if (!auth.refreshToken) {
    throw new Error('登录已过期，请重新登录')
  }
  if (!refreshPromise) {
    refreshPromise = axios
      .post<Result<LoginVO>>('/api/user/token/refresh', { refreshToken: auth.refreshToken })
      .then((res) => {
        const body = res.data
        if (body.code !== 200 || !body.data) {
          throw new Error(body.msg || '刷新登录失败')
        }
        auth.setSession(body.data)
      })
      .finally(() => {
        refreshPromise = null
      })
  }
  await refreshPromise
}

/** 统一解包 Result；code !== 200 视为业务失败 */
request.interceptors.response.use(
  (response) => {
    const body = response.data as Result<unknown>
    if (body.code !== 200) {
      return Promise.reject(new Error(body.msg || '请求失败'))
    }
    return response
  },
  async (error: AxiosError<Result<unknown>>) => {
    const config = error.config as (InternalAxiosRequestConfig & { _retried?: boolean }) | undefined
    const status = error.response?.status
    const bizCode = error.response?.data?.code

    if (config && !config._retried && (status === 401 || bizCode === 401)) {
      config._retried = true
      try {
        await ensureFreshAccessToken()
        const auth = useAuthStore()
        config.headers.Authorization = `Bearer ${auth.accessToken}`
        return request(config)
      } catch {
        useAuthStore().clearSession()
      }
    }

    let msg =
      error.response?.data?.msg ||
      error.message ||
      '网络异常，请确认网关与各服务已启动'

    if (error.code === 'ECONNABORTED') {
      msg = '请求超时，请确认网关与各微服务已启动（若刚切换网络，重启各服务后再试）'
    }

    return Promise.reject(new Error(msg))
  }
)

export default request

/** 取 data 字段的便捷方法 */
export async function getData<T>(promise: Promise<{ data: Result<T> }>): Promise<T> {
  const res = await promise
  return res.data.data
}
