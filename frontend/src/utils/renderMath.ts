/**
 * 文本 → 安全 HTML：转义 + KaTeX 公式（$...$ 行内 / $$...$$ 块级）。
 * 供 MathText 组件与 PDF 导出共用，避免两份 KaTeX 拆分逻辑。
 */
import katex from 'katex'
import 'katex/dist/katex.min.css'
import { escapeHtml } from './html'

const MATH_RE = /\$\$([\s\S]+?)\$\$|\$([^$\n]+?)\$/g

export interface RenderMathOptions {
  /** 纯文本段中的换行是否转为 <br/>（默认 false）。 */
  lineBreaks?: boolean
}

/**
 * 将含 $ 公式的文本渲染为 HTML；公式渲染失败时回退为原式文本。
 */
export function renderMathHtml(raw: string, options: RenderMathOptions = {}): string {
  const text = raw ?? ''
  if (!text) return ''
  const toText = (s: string) => {
    const escaped = escapeHtml(s)
    return options.lineBreaks ? escaped.replace(/\n/g, '<br/>') : escaped
  }
  try {
    let out = ''
    let last = 0
    let m: RegExpExecArray | null
    MATH_RE.lastIndex = 0
    while ((m = MATH_RE.exec(text))) {
      if (m.index > last) out += toText(text.slice(last, m.index))
      const expr = (m[1] ?? m[2] ?? '').trim()
      const display = Boolean(m[1])
      try {
        out += katex.renderToString(expr, { throwOnError: false, displayMode: display })
      } catch {
        out += toText(expr)
      }
      last = m.index + m[0].length
    }
    if (last < text.length) out += toText(text.slice(last))
    return out
  } catch {
    return toText(text)
  }
}
