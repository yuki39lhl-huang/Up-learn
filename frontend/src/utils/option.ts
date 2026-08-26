/** 解析选项 "A.xxx" → { label: 'A', text: 'xxx' } */
export function parseOption(opt: string): { label: string; text: string } {
  const m = opt.match(/^([A-Da-d])\.(.+)$/)
  if (m) {
    return { label: m[1].toUpperCase(), text: m[2] }
  }
  return { label: opt, text: opt }
}
