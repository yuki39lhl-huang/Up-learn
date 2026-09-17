import { nextTick, onBeforeUnmount } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

/**
 * Antigravity-style feature row reveal: copy slides in, glow card rises.
 */
export function useFeatureReveal() {
  const triggers: ScrollTrigger[] = []

  async function bind(root: ParentNode = document) {
    await nextTick()
    kill()

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      root.querySelectorAll<HTMLElement>('[data-feature-row]').forEach((row) => {
        row.classList.add('is-in')
        row.querySelectorAll<HTMLElement>('[data-feature-copy], [data-feature-stage]').forEach((el) => {
          el.style.opacity = '1'
          el.style.transform = 'none'
        })
      })
      return
    }

    root.querySelectorAll<HTMLElement>('[data-feature-row]').forEach((row) => {
      const copy = row.querySelector<HTMLElement>('[data-feature-copy]')
      const stage = row.querySelector<HTMLElement>('[data-feature-stage]')
      if (!copy || !stage) return

      gsap.set(copy, { opacity: 0, y: 28 })
      gsap.set(stage, { opacity: 0, y: 40, scale: 0.97 })

      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: row,
          start: 'top 78%',
          toggleActions: 'play none none none',
        },
      })
      tl.to(copy, { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }, 0).to(
        stage,
        { opacity: 1, y: 0, scale: 1, duration: 0.85, ease: 'power3.out' },
        0.12,
      )
      if (tl.scrollTrigger) triggers.push(tl.scrollTrigger)
      row.classList.add('is-in')
    })
  }

  function kill() {
    triggers.splice(0).forEach((t) => t.kill())
  }

  function refresh() {
    ScrollTrigger.refresh()
  }

  onBeforeUnmount(kill)

  return { bind, kill, refresh }
}
