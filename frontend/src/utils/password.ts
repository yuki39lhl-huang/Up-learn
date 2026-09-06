/**
 * 新密码 + 确认密码前端校验（账号安全设密/改密、邮箱重置）。
 *
 * 规则与后端一致：8～32 位，至少各含一个字母与一个数字；两次输入须一致。
 * 最终以服务端 {@code PASSWORD_WEAK} 等校验为准。
 *
 * @returns 错误文案；通过则返回 null
 */
export function validateNewPasswordPair(nextRaw: string, confirmRaw: string): string | null {
  const next = nextRaw.trim()
  const confirm = confirmRaw.trim()
  if (!next) return '请输入新密码'
  if (next.length < 8 || next.length > 32) return '新密码长度须为 8～32 位'
  if (!/[A-Za-z]/.test(next)) return '新密码须包含至少一个字母'
  if (!/\d/.test(next)) return '新密码须包含至少一个数字'
  if (!confirm) return '请再次输入新密码'
  if (next !== confirm) return '两次输入的新密码不一致'
  return null
}
