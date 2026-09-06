import { onUnmounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { sendLoginCode, loginByCode, loginByPassword } from '../api/user'
import { useAuthStore } from '../stores/auth'
import { normalizeLoginCode } from '../utils/loginCode'
import type { LoginVO } from '../types/api'

/** 登录方式：邮箱验证码 / 已设密后的密码登录 */
export type LoginMode = 'code' | 'password'

/**
 * 登录表单共享逻辑（LoginModal / LoginView）。
 *
 * 职责：模式切换、验证码倒计时、验证码输入规范化、发码与登录请求、写入 auth 会话。
 * 登录页不提供「忘记密码」；重置入口仅在账号安全页。
 */
export function useLoginForm(options?: { onSuccess?: (vo: LoginVO) => void | Promise<void> }) {
  const auth = useAuthStore()

  const mode = ref<LoginMode>('code')
  const email = ref('')
  const code = ref('')
  const password = ref('')
  const sending = ref(false)
  const logging = ref(false)
  /** 发码冷却剩余秒数；>0 时按钮应禁用 */
  const countdown = ref(0)

  let timer: ReturnType<typeof setInterval> | null = null

  function clearCountdown() {
    if (timer) {
      clearInterval(timer)
      timer = null
    }
    countdown.value = 0
  }

  /** 发码成功后启动 60s 冷却 */
  function startCountdown() {
    countdown.value = 60
    if (timer) clearInterval(timer)
    timer = setInterval(() => {
      countdown.value -= 1
      if (countdown.value <= 0) clearCountdown()
    }, 1000)
  }

  /** 切换登录方式时清空对方字段，避免误提交 */
  function switchMode(next: LoginMode) {
    mode.value = next
    code.value = ''
    password.value = ''
  }

  /** 弹窗关闭等场景：回到验证码模式并清空敏感输入 */
  function resetForm() {
    code.value = ''
    password.value = ''
    mode.value = 'code'
  }

  /** input 事件：去非数字并截 6 位 */
  function setCodeFromInput(raw: string) {
    code.value = normalizeLoginCode(raw)
  }

  /** paste：整段粘贴规范化，避免 maxlength 截断末位 */
  function onCodePaste(e: ClipboardEvent) {
    e.preventDefault()
    code.value = normalizeLoginCode(e.clipboardData?.getData('text') ?? '')
  }

  async function handleSendCode() {
    if (!email.value.trim()) {
      ElMessage.warning('请输入邮箱')
      return
    }
    sending.value = true
    try {
      await sendLoginCode(email.value.trim())
      ElMessage.success('验证码已发送')
      startCountdown()
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '发送失败')
    } finally {
      sending.value = false
    }
  }

  async function handleLogin() {
    if (!email.value.trim()) {
      ElMessage.warning('请输入邮箱')
      return
    }
    logging.value = true
    try {
      const vo =
        mode.value === 'code'
          ? await loginByCode(email.value.trim(), normalizeLoginCode(code.value))
          : await loginByPassword(email.value.trim(), password.value)
      auth.setSession(vo)
      ElMessage.success('登录成功')
      await options?.onSuccess?.(vo)
    } catch (e) {
      ElMessage.error(e instanceof Error ? e.message : '登录失败')
    } finally {
      logging.value = false
    }
  }

  onUnmounted(() => clearCountdown())

  return {
    mode,
    email,
    code,
    password,
    sending,
    logging,
    countdown,
    switchMode,
    resetForm,
    setCodeFromInput,
    onCodePaste,
    handleSendCode,
    handleLogin,
    clearCountdown,
  }
}
