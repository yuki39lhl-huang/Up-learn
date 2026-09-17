import { nextTick, onBeforeUnmount, type Ref } from 'vue'
import gsap from 'gsap'

type TypedHeadlineOptions = {
  root: Ref<HTMLElement | null>
  text: string
  /** delay before first char */
  delay?: number
  /** seconds between chars */
  stagger?: number
  /** keep blinking cursor after typing finishes (Antigravity bridge) */
  cursorPersists?: boolean
}

/**
 * GSAP char stagger “typing” + CSS-var cursor (Antigravity-style technique, brand-safe).
 */
export function useTypedHeadline(options: TypedHeadlineOptions) {
  let timeline: gsap.core.Timeline | null = null
  let resizeHandler: (() => void) | null = null

  function prefersReducedMotion() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches
  }

  function setCursor(root: HTMLElement, x: number, y: number) {
    root.style.setProperty('--typed-cursor-x', `${x}px`)
    root.style.setProperty('--typed-cursor-y', `${y}px`)
  }

  function placeCursorAt(root: HTMLElement, el: HTMLElement | null, after = false) {
    if (!el) return
    const rootRect = root.getBoundingClientRect()
    const elRect = el.getBoundingClientRect()
    const left = elRect.left - rootRect.left + (after ? elRect.width + 6 : 0)
    const top = elRect.top - rootRect.top
    setCursor(root, left, top)
  }

  async function start() {
    await nextTick()
    const root = options.root.value
    if (!root) return

    const content = root.querySelector<HTMLElement>('[data-typed-content]')
    const cursor = root.querySelector<HTMLElement>('[data-typed-cursor]')
    if (!content) return

    timeline?.kill()
    content.replaceChildren()

    /** 标点粘在上一字，避免中文换行出现「，」顶格 */
    const trailingPunct = /[，。、；：！？…）》」』）】》'"»]$/
    const chars: HTMLElement[] = []
    for (const ch of Array.from(options.text)) {
      const glyph = ch === ' ' ? '\u00a0' : ch
      if (chars.length && trailingPunct.test(glyph)) {
        chars[chars.length - 1]!.textContent += glyph
        continue
      }
      const span = document.createElement('span')
      span.className = 'lp-typed__char'
      span.textContent = glyph
      content.appendChild(span)
      chars.push(span)
    }

    if (prefersReducedMotion()) {
      gsap.set(chars, { opacity: 1 })
      if (cursor) gsap.set(cursor, { opacity: 0 })
      return
    }

    gsap.set(chars, { opacity: 0 })
    if (cursor) {
      gsap.set(cursor, { opacity: 1 })
      placeCursorAt(root, chars[0] ?? null, false)
    }

    const delay = options.delay ?? 0.25
    const stagger = options.stagger ?? 0.045

    timeline = gsap.timeline()
    timeline.fromTo(
      chars,
      { opacity: 0 },
      {
        opacity: 1,
        duration: 0.02,
        delay,
        stagger: {
          each: stagger,
          onStart() {
            const tween = this as { targets: () => unknown[] }
            const target = tween.targets()[0] as HTMLElement | undefined
            if (target) placeCursorAt(root, target, true)
          },
        },
        ease: 'none',
      },
    )
    if (cursor && !options.cursorPersists) {
      timeline.to(cursor, { opacity: 0, duration: 0.45, ease: 'power1.out' }, '+=0.15')
    }

    resizeHandler = () => {
      const last = chars[chars.length - 1]
      if (last && cursor && Number(gsap.getProperty(cursor, 'opacity')) > 0.05) {
        placeCursorAt(root, last, true)
      }
    }
    window.addEventListener('resize', resizeHandler)
  }

  function stop() {
    timeline?.kill()
    timeline = null
    if (resizeHandler) {
      window.removeEventListener('resize', resizeHandler)
      resizeHandler = null
    }
  }

  onBeforeUnmount(stop)

  return { start, stop }
}
