/**
 * 轻量 Markdown → HTML（前言弹框用）：标题、段落、粗体、引用、表格、列表。
 * 内容来自仓库静态 md，不做不可信用户输入场景。
 */
export function renderGuideMarkdown(src: string): string {
  const lines = src.replace(/\r\n/g, '\n').split('\n')
  const html: string[] = []
  let i = 0

  while (i < lines.length) {
    const line = lines[i]
    const trimmed = line.trim()

    if (!trimmed) {
      i++
      continue
    }

    if (/^---+$/.test(trimmed)) {
      html.push('<hr />')
      i++
      continue
    }

    const heading = trimmed.match(/^(#{1,3})\s+(.+)$/)
    if (heading) {
      const level = heading[1].length
      html.push(`<h${level}>${inline(heading[2])}</h${level}>`)
      i++
      continue
    }

    if (trimmed.startsWith('>')) {
      const quote: string[] = []
      while (i < lines.length && lines[i].trim().startsWith('>')) {
        quote.push(lines[i].trim().replace(/^>\s?/, ''))
        i++
      }
      html.push(`<blockquote>${quote.map((q) => `<p>${inline(q)}</p>`).join('')}</blockquote>`)
      continue
    }

    if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
      const rows: string[][] = []
      while (i < lines.length && lines[i].trim().startsWith('|')) {
        const rowLine = lines[i].trim()
        const cells = rowLine
          .slice(1, -1)
          .split('|')
          .map((c) => c.trim())
        // 跳过对齐行 | :--- |
        if (!cells.every((c) => /^:?-+:?$/.test(c))) {
          rows.push(cells)
        }
        i++
      }
      if (rows.length) {
        const [head, ...body] = rows
        html.push('<table><thead><tr>')
        html.push(...head.map((c) => `<th>${inline(c)}</th>`))
        html.push('</tr></thead><tbody>')
        for (const row of body) {
          html.push('<tr>')
          html.push(...row.map((c) => `<td>${inline(c)}</td>`))
          html.push('</tr>')
        }
        html.push('</tbody></table>')
      }
      continue
    }

    if (/^[-*]\s+/.test(trimmed) || /^\d+\.\s+/.test(trimmed)) {
      const ordered = /^\d+\.\s+/.test(trimmed)
      const items: string[] = []
      while (i < lines.length) {
        const t = lines[i].trim()
        if (ordered ? !/^\d+\.\s+/.test(t) : !/^[-*]\s+/.test(t)) break
        items.push(t.replace(ordered ? /^\d+\.\s+/ : /^[-*]\s+/, ''))
        i++
      }
      const tag = ordered ? 'ol' : 'ul'
      html.push(`<${tag}>${items.map((it) => `<li>${inline(it)}</li>`).join('')}</${tag}>`)
      continue
    }

    const para: string[] = [trimmed]
    i++
    while (i < lines.length) {
      const t = lines[i].trim()
      if (
        !t ||
        t.startsWith('#') ||
        t.startsWith('>') ||
        t.startsWith('|') ||
        /^[-*]\s+/.test(t) ||
        /^\d+\.\s+/.test(t) ||
        /^---+$/.test(t)
      ) {
        break
      }
      para.push(t)
      i++
    }
    html.push(`<p>${inline(para.join(' '))}</p>`)
  }

  return html.join('\n')
}

function inline(text: string): string {
  let s = escapeHtml(text)
  s = s.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
  s = s.replace(/`([^`]+)`/g, '<code>$1</code>')
  s = s.replace(/\*(.+?)\*/g, '<em>$1</em>')
  return s
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}
