/**
 * 选项文本解析（单一实现，供刷题 / 试卷预览 / 作答 / PDF 导出共用）。
 * 支持 "A.xxx" / "A、xxx" / "A．xxx" / "A xxx"，字母 A–E。
 */
const LETTER_PREFIX = /^([A-Ea-e])[.、．\s]/
const LETTER_STRIP = /^[A-Ea-e][.、．\s]+/

/** 选项字母（大写）；无前缀时取首字符。 */
export function optionLetter(opt: string): string {
  const s = opt.trim()
  const m = s.match(LETTER_PREFIX)
  return m ? m[1].toUpperCase() : s.charAt(0).toUpperCase()
}

/** 去掉字母前缀后的选项正文。 */
export function optionBody(opt: string): string {
  return opt.replace(LETTER_STRIP, '').trim()
}

/** 解析选项 "A.xxx" → { label: 'A', text: 'xxx' }；无法识别时 label/text 均为原文。 */
export function parseOption(opt: string): { label: string; text: string } {
  const s = opt.trim()
  if (LETTER_PREFIX.test(s)) {
    return { label: optionLetter(s), text: optionBody(s) }
  }
  return { label: opt, text: opt }
}
