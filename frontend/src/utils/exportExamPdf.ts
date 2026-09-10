/**
 * 当前页直接下载无水印卷面 PDF（不跳转、不弹系统打印框）。
 * 离屏构建纯净 DOM + KaTeX，避免页面 color-mix 导致 html2canvas 失败。
 */
import html2canvas from 'html2canvas'
import { jsPDF } from 'jspdf'
import katex from 'katex'
import 'katex/dist/katex.min.css'
import { fetchPaperDetail } from '../api/papers'
import type { PaperDetailVO } from '../types/api'
import { buildSheetSections, displayQuestionNo, sortBySeq } from './paperSheet'

const SHEET_WIDTH = 794

const SHEET_CSS = `
.ul-pdf-root {
  width: ${SHEET_WIDTH}px;
  margin: 0;
  padding: 28px 36px 40px;
  background: #ffffff;
  color: #1a1a1a;
  font-family: "SimSun", "Songti SC", "Noto Serif SC", "Times New Roman", serif;
  font-size: 14px;
  line-height: 1.75;
  box-sizing: border-box;
}
.ul-pdf-root * { box-sizing: border-box; color: #1a1a1a; }
.ul-pdf-root .head { text-align: center; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #222; }
.ul-pdf-root .head h1 { margin: 0; font-size: 22px; letter-spacing: 0.06em; }
.ul-pdf-root .head p { margin: 6px 0 0; font-size: 13px; }
.ul-pdf-root .sec { margin-bottom: 14px; }
.ul-pdf-root .sec h2 { margin: 0 0 10px; font-size: 15px; font-weight: 700; }
.ul-pdf-root .q--material {
  margin: 10px 0 14px;
  padding: 10px 12px;
  background: #faf9f6;
  border: 1px solid #e5e1d8;
}

.ul-pdf-root .stem { margin-bottom: 6px; }
.ul-pdf-root .stem--pre { white-space: pre-wrap; font-size: 13px; line-height: 1.65; }
.ul-pdf-root .no { font-weight: 700; margin-right: 4px; }
.ul-pdf-root .opts { display: grid; grid-template-columns: 1fr 1fr; gap: 4px 16px; padding-left: 1.2em; }
.ul-pdf-root .opt { display: flex; align-items: baseline; gap: 6px; }
.ul-pdf-root .letter { font-weight: 600; flex-shrink: 0; }
.ul-pdf-root .foot { margin-top: 22px; padding-top: 10px; border-top: 1px dashed #ccc; text-align: center; font-size: 11px; color: #888 !important; }
.ul-pdf-root .katex { font-size: 1.05em; }
.ul-pdf-root .katex-display { margin: 0.4em 0; overflow: visible; }
`

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}

function renderMathSafe(raw: string): string {
  const chunks: { type: 'text' | 'html'; value: string }[] = []
  const re = /\$\$([\s\S]+?)\$\$|\$([^$\n]+?)\$/g
  let last = 0
  let m: RegExpExecArray | null
  while ((m = re.exec(raw))) {
    if (m.index > last) {
      chunks.push({ type: 'text', value: raw.slice(last, m.index) })
    }
    const expr = (m[1] ?? m[2] ?? '').trim()
    const display = Boolean(m[1])
    try {
      chunks.push({
        type: 'html',
        value: katex.renderToString(expr, { throwOnError: false, displayMode: display }),
      })
    } catch {
      chunks.push({ type: 'text', value: expr })
    }
    last = m.index + m[0].length
  }
  if (last < raw.length) chunks.push({ type: 'text', value: raw.slice(last) })
  return chunks.map((c) => (c.type === 'html' ? c.value : escapeHtml(c.value))).join('')
}

function optionLetter(opt: string): string {
  const m = opt.trim().match(/^([A-Da-d])[.、．\s]/)
  return m ? m[1].toUpperCase() : opt.trim().charAt(0).toUpperCase()
}

function optionBody(opt: string): string {
  return opt.replace(/^[A-Da-d][.、．\s]+/, '').trim()
}

function buildSheetHtml(detail: PaperDetailVO): string {
  const qs = detail.questions ?? []
  const total = qs.reduce((s, q) => s + (q.score || 0), 0)
  const ordered = sortBySeq(qs)
  const sections = buildSheetSections(qs)

  let body = `
    <div class="head">
      <h1>《${escapeHtml(detail.subject)}》</h1>
      <p>${detail.year}年${escapeHtml(detail.province)}专升本招生统一考试 · 升学通卷面</p>
      <p>（本试卷满分 ${total} 分。）</p>
    </div>
  `

  for (const sec of sections) {
    body += `<div class="sec">`
    if (sec.title) body += `<h2>${escapeHtml(sec.title)}</h2>`
    for (const q of sec.items) {
      const no = displayQuestionNo(q, ordered)
      const isMat = q.qType === 'material'
      const stemInner = isMat
        ? renderMathSafe(q.stem).replace(/\n/g, '<br/>')
        : `${no != null ? `<span class="no">${no}.</span>` : ''}${renderMathSafe(q.stem)}`
      body += `<div class="q${isMat ? ' q--material' : ''}"><div class="stem${isMat ? ' stem--pre' : ''}">${stemInner}</div>`
      if (q.qType === 'choice' && q.options?.length) {
        body += `<div class="opts">`
        for (const opt of q.options) {
          body += `<div class="opt"><span class="letter">${optionLetter(opt)}.</span><span>${renderMathSafe(optionBody(opt))}</span></div>`
        }
        body += `</div>`
      }
      body += `</div>`
    }
    body += `</div>`
  }

  body += `<div class="foot">升学通 · 无水印练习卷面（非招生考试原件扫描）</div>`
  return body
}

function waitForFonts(): Promise<void> {
  if (document.fonts?.ready) {
    return document.fonts.ready.then(() => undefined).catch(() => undefined)
  }
  return new Promise((r) => setTimeout(r, 300))
}

async function renderElementToPdf(root: HTMLElement, fileName: string) {
  await waitForFonts()
  await new Promise((r) => setTimeout(r, 200))

  const canvas = await html2canvas(root, {
    scale: 2,
    useCORS: true,
    allowTaint: true,
    backgroundColor: '#ffffff',
    logging: false,
    width: SHEET_WIDTH,
    windowWidth: SHEET_WIDTH,
    onclone: (doc, el) => {
      // 仅保留安全样式，避免解析页面 color()
      doc.querySelectorAll('link[rel="stylesheet"]').forEach((n) => {
        const href = (n as HTMLLinkElement).href || ''
        if (!href.includes('katex')) n.remove()
      })
      doc.querySelectorAll('style').forEach((n) => {
        const t = n.textContent || ''
        if (t.includes('color-mix') || t.includes('oklch(') || t.includes('color(')) {
          // 若不是我们注入的卷面样式则移除
          if (!t.includes('.ul-pdf-root')) n.remove()
        }
      })
      if (el instanceof HTMLElement) {
        el.style.width = `${SHEET_WIDTH}px`
        el.style.background = '#ffffff'
        el.style.color = '#1a1a1a'
      }
    },
  })

  const img = canvas.toDataURL('image/jpeg', 0.95)
  const pdf = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' })
  const pageW = pdf.internal.pageSize.getWidth()
  const pageH = pdf.internal.pageSize.getHeight()
  const margin = 10
  const usableW = pageW - margin * 2
  const usableH = pageH - margin * 2
  const imgH = (canvas.height * usableW) / canvas.width

  let y = 0
  let page = 0
  while (y < imgH - 0.5) {
    if (page > 0) pdf.addPage()
    pdf.addImage(img, 'JPEG', margin, margin - y, usableW, imgH)
    y += usableH
    page += 1
    if (page > 50) break
  }

  const safeName = fileName.replace(/[\\/:*?"<>|]+/g, '_')
  pdf.save(safeName.endsWith('.pdf') ? safeName : `${safeName}.pdf`)
}

/** 按试卷 ID 直接下载 PDF（当前页，无跳转） */
export async function downloadPaperAsPdf(paperId: number) {
  const detail = await fetchPaperDetail(paperId)
  if (!detail?.questions?.length) {
    throw new Error('该卷尚无结构化题目，无法生成 PDF')
  }

  const host = document.createElement('div')
  host.setAttribute('aria-hidden', 'true')
  host.style.cssText =
    'position:fixed;left:-14000px;top:0;width:794px;background:#fff;z-index:-1;pointer-events:none;overflow:visible;'

  const style = document.createElement('style')
  style.textContent = SHEET_CSS

  const root = document.createElement('div')
  root.className = 'ul-pdf-root'
  root.innerHTML = buildSheetHtml(detail)

  host.appendChild(style)
  host.appendChild(root)
  document.body.appendChild(host)

  try {
    const name = `${detail.title || detail.subject || '试卷'}-升学通卷面.pdf`
    await renderElementToPdf(root, name)
  } finally {
    host.remove()
  }
}
