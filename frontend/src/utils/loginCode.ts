/**
 * 登录验证码输入规范化。
 *
 * 去掉空格与非数字字符，再截取最多 6 位。
 * 用于避免粘贴「前导空格 + 6 位码」时被 maxlength=6 截断末位。
 */
export function normalizeLoginCode(raw: string): string {
  return String(raw ?? '').replace(/\D/g, '').slice(0, 6)
}
