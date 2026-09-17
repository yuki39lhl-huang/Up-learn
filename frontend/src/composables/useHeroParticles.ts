import { onBeforeUnmount, type Ref } from 'vue'

type Particle = {
  x: number
  y: number
  vx: number
  vy: number
  r: number
  a: number
  rgb: string
}

type HeroParticlesOptions = {
  canvas: Ref<HTMLCanvasElement | null>
  /** single rgb triplet; omit for soft multi-hue on black */
  color?: string
}

const LIFTOFF_DARK = [
  '255, 255, 255',
  '167, 243, 208',
  '147, 197, 253',
  '253, 186, 116',
  '249, 168, 212',
  '196, 181, 253',
]

const LIFTOFF_LIGHT = [
  '37, 99, 235',
  '59, 130, 246',
  '96, 165, 250',
  '147, 197, 253',
  '100, 116, 139',
  '148, 163, 184',
]

function activePalette() {
  return document.documentElement.getAttribute('data-theme') === 'dark' ? LIFTOFF_DARK : LIFTOFF_LIGHT
}

/**
 * Lightweight canvas particles with soft mouse ring push (no Three.js).
 */
export function useHeroParticles(options: HeroParticlesOptions) {
  let raf = 0
  let particles: Particle[] = []
  let w = 0
  let h = 0
  let dpr = 1
  let mouseX = -9999
  let mouseY = -9999
  let running = false

  const onMove = (e: PointerEvent) => {
    const canvas = options.canvas.value
    if (!canvas) return
    const rect = canvas.getBoundingClientRect()
    mouseX = e.clientX - rect.left
    mouseY = e.clientY - rect.top
  }

  const onLeave = () => {
    mouseX = -9999
    mouseY = -9999
  }

  function prefersReducedMotion() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches
  }

  function seed(count: number) {
    const palette = activePalette()
    particles = Array.from({ length: count }, () => ({
      x: Math.random() * w,
      y: Math.random() * h,
      vx: (Math.random() - 0.5) * 0.4,
      vy: (Math.random() - 0.5) * 0.4,
      r: 0.9 + Math.random() * 2.4,
      a: 0.22 + Math.random() * 0.45,
      rgb: options.color ?? palette[Math.floor(Math.random() * palette.length)]!,
    }))
  }

  function resize() {
    const canvas = options.canvas.value
    if (!canvas) return
    const parent = canvas.parentElement
    if (!parent) return
    dpr = Math.min(window.devicePixelRatio || 1, 2)
    w = parent.clientWidth
    h = parent.clientHeight
    canvas.width = Math.floor(w * dpr)
    canvas.height = Math.floor(h * dpr)
    canvas.style.width = `${w}px`
    canvas.style.height = `${h}px`
    const ctx = canvas.getContext('2d')
    if (ctx) ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
    const count = Math.min(180, Math.floor((w * h) / 7500))
    seed(Math.max(64, count))
  }

  function frame() {
    const canvas = options.canvas.value
    if (!canvas || !running) return
    const ctx = canvas.getContext('2d')
    if (!ctx) return

    ctx.clearRect(0, 0, w, h)

    for (const p of particles) {
      const dx = p.x - mouseX
      const dy = p.y - mouseY
      const dist = Math.hypot(dx, dy)
      if (dist < 140 && dist > 0.1) {
        const force = ((140 - dist) / 140) * 0.7
        p.vx += (dx / dist) * force
        p.vy += (dy / dist) * force
      }

      p.vx *= 0.96
      p.vy *= 0.96
      p.x += p.vx + Math.sin(p.y * 0.01) * 0.1
      p.y += p.vy + Math.cos(p.x * 0.01) * 0.1

      if (p.x < -8) p.x = w + 8
      if (p.x > w + 8) p.x = -8
      if (p.y < -8) p.y = h + 8
      if (p.y > h + 8) p.y = -8

      ctx.beginPath()
      ctx.fillStyle = `rgba(${p.rgb}, ${p.a})`
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
      ctx.fill()
    }

    raf = requestAnimationFrame(frame)
  }

  function start() {
    stop()
    const canvas = options.canvas.value
    if (!canvas || prefersReducedMotion()) return

    resize()
    running = true
    window.addEventListener('resize', resize)
    canvas.addEventListener('pointermove', onMove)
    canvas.addEventListener('pointerleave', onLeave)
    const hero = canvas.closest('.lp-hero')
    hero?.addEventListener('pointermove', onMove as EventListener)
    hero?.addEventListener('pointerleave', onLeave)
    raf = requestAnimationFrame(frame)
  }

  function stop() {
    running = false
    cancelAnimationFrame(raf)
    window.removeEventListener('resize', resize)
    const canvas = options.canvas.value
    if (canvas) {
      canvas.removeEventListener('pointermove', onMove)
      canvas.removeEventListener('pointerleave', onLeave)
      const hero = canvas.closest('.lp-hero')
      hero?.removeEventListener('pointermove', onMove as EventListener)
      hero?.removeEventListener('pointerleave', onLeave)
    }
  }

  onBeforeUnmount(stop)

  return { start, stop }
}
