<script setup lang="ts">
/**
 * 官网 ↔ 控制台过场：
 * - PPT 式对角线裁剪（左下 → 右上）铺满书面
 * - 钢笔笔尖贴着裁剪前沿「划过」，与背景同轴同步
 */
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import {
  registerPaperPlanePlayer,
  type PaperPlaneDirection,
} from '../utils/paperPlaneTransit'

const visible = ref(false)
const direction = ref<PaperPlaneDirection>('to-console')
const sheetRef = ref<HTMLElement | null>(null)
const craftRef = ref<HTMLElement | null>(null)
const contactRef = ref<HTMLElement | null>(null)
const labelRef = ref<HTMLElement | null>(null)

/** 笔尖划过与书面裁剪同一时长 */
const DURATION_MS = 1900
const HOLD_MS = 280
const EXIT_MS = 520

let raf = 0
let hideTimer = 0

function easeInOutCubic(t: number) {
  return t < 0.5 ? 4 * t * t * t : 1 - (-2 * t + 2) ** 3 / 2
}

function clearTimers() {
  if (raf) cancelAnimationFrame(raf)
  raf = 0
  if (hideTimer) window.clearTimeout(hideTimer)
  hideTimer = 0
}

/**
 * 对角线裁剪进度 0→1（左下扩到右上），返回 clip-path polygon。
 * to-console: 书面从左下铺开；to-landing: 从右上铺开。
 */
function diagonalClip(t: number, dir: PaperPlaneDirection): string {
  const p = Math.max(0, Math.min(1, t))
  if (dir === 'to-console') {
    // 覆盖层：从 BL 长出
    if (p <= 0) return 'polygon(0% 100%, 0% 100%, 0% 100%)'
    if (p >= 1) return 'polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)'
    const s = p * 2
    if (s <= 1) {
      return `polygon(0% 100%, ${s * 100}% 100%, 0% ${(1 - s) * 100}%)`
    }
    return `polygon(0% 100%, 100% 100%, 100% ${(2 - s) * 100}%, ${(s - 1) * 100}% 0%, 0% 0%)`
  }
  // 覆盖层：从 TR 长出
  if (p <= 0) return 'polygon(100% 0%, 100% 0%, 100% 0%)'
  if (p >= 1) return 'polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)'
  const s = p * 2
  if (s <= 1) {
    return `polygon(100% 0%, ${100 - s * 100}% 0%, 100% ${s * 100}%)`
  }
  return `polygon(100% 0%, 0% 0%, 0% ${(s - 1) * 100}%, ${100 - (s - 1) * 100}% 100%, 100% 100%)`
}

/** 裁剪前沿线段两端点（视口像素） */
function frontierSegment(t: number, dir: PaperPlaneDirection, w: number, h: number) {
  const p = Math.max(0, Math.min(1, t))
  const s = p * 2
  if (dir === 'to-console') {
    if (s <= 1) {
      return { a: { x: 0, y: h - s * h }, b: { x: s * w, y: h } }
    }
    const r = s - 1
    return { a: { x: r * w, y: 0 }, b: { x: w, y: h - r * h } }
  }
  if (s <= 1) {
    return { a: { x: w - s * w, y: 0 }, b: { x: w, y: s * h } }
  }
  const r = s - 1
  return { a: { x: 0, y: r * h }, b: { x: w - r * w, y: h } }
}

/** 笔尖沿前沿来回扫的次数（排线感） */
const SWEEPS = 3

/**
 * 笔尖落点：在前沿线段上来回扫动，同时随前沿推进，
 * 形成「一笔笔把页面排线涂满」的效果，而非整体平移。
 */
function penTip(t: number, dir: PaperPlaneDirection, w: number, h: number) {
  const { a, b } = frontierSegment(t, dir, w, h)
  const q = 0.5 - 0.5 * Math.cos(t * Math.PI * SWEEPS)
  // 扫动方向（用于笔身轻微前倾）
  const dq = Math.sin(t * Math.PI * SWEEPS)
  return {
    x: a.x + (b.x - a.x) * q,
    y: a.y + (b.y - a.y) * q,
    lean: dq,
  }
}

/** 图片中笔尖位置（占比），用于把笔尖精确锚在裁剪前沿 */
const TIP_X = 0.949
const TIP_Y = 0.993

/**
 * 笔身姿态：右手握笔——笔尖压在纸上，笔杆朝右下角（手腕方向）。
 * 原图笔杆在笔尖左上，旋转约 164° 后笔杆朝右下、与纸面约 50°。
 * 注意 transform-origin 需为 0 0，否则 rotate 会绕元素中心把笔尖甩偏。
 */
const HOLD_TILT_DEG = 164

function penTransform(t: number, x: number, y: number, lean: number) {
  // 随扫动方向轻微前倾 + 微小落笔起伏
  const tilt = HOLD_TILT_DEG + lean * 5 + Math.sin(t * Math.PI * 6) * 0.8
  return `translate(${x}px, ${y}px) rotate(${tilt}deg) translate(${-TIP_X * 100}%, ${-TIP_Y * 100}%)`
}

function craftOpacityAt(t: number) {
  if (t < 0.04) return t / 0.04
  if (t < 0.88) return 1
  return Math.max(0, 1 - (t - 0.88) / 0.12)
}

function setLabel(p: number) {
  const label = labelRef.value
  if (!label) return
  label.style.opacity = String(Math.max(0, Math.min(1, (p - 0.45) / 0.4)))
}

function runStroke() {
  const sheet = sheetRef.value
  const craft = craftRef.value
  if (!sheet || !craft) {
    return { whenCovered: Promise.resolve(), whenDone: Promise.resolve() }
  }

  const start = performance.now()
  let coveredResolve: () => void = () => {}
  let coveredDone = false
  const whenCovered = new Promise<void>((r) => {
    coveredResolve = r
  })

  const whenDone = new Promise<void>((resolve) => {
    const tick = (now: number) => {
      const raw = Math.min(1, (now - start) / DURATION_MS)
      const t = easeInOutCubic(raw)
      const w = window.innerWidth || 1280
      const h = window.innerHeight || 800
      const dir = direction.value

      sheet.style.clipPath = diagonalClip(t, dir)
      setLabel(t)

      const tip = penTip(t, dir, w, h)
      craft.style.transform = penTransform(t, tip.x, tip.y, tip.lean)
      craft.style.opacity = String(craftOpacityAt(t))
      const contact = contactRef.value
      if (contact) {
        contact.style.transform = `translate(${tip.x}px, ${tip.y}px) translate(-50%, -50%)`
        contact.style.opacity = String(craftOpacityAt(t) * 0.9)
      }

      if (!coveredDone && raw >= 0.92) {
        coveredDone = true
        coveredResolve()
      }

      if (raw < 1) {
        raf = requestAnimationFrame(tick)
      } else {
        sheet.style.clipPath = diagonalClip(1, dir)
        setLabel(1)
        craft.style.opacity = '0'
        if (!coveredDone) {
          coveredDone = true
          coveredResolve()
        }
        resolve()
      }
    }
    raf = requestAnimationFrame(tick)
  })

  return { whenCovered, whenDone }
}

function runSheetExit() {
  const sheet = sheetRef.value
  const label = labelRef.value
  if (!sheet) return Promise.resolve()
  const start = performance.now()
  const dir = direction.value
  return new Promise<void>((resolve) => {
    const tick = (now: number) => {
      const raw = Math.min(1, (now - start) / EXIT_MS)
      const t = easeInOutCubic(raw)
      // 反向裁掉书面（露出目标页）
      sheet.style.clipPath = diagonalClip(1 - t, dir)
      if (label) label.style.opacity = String(Math.max(0, 1 - t * 1.3))
      if (raw < 1) raf = requestAnimationFrame(tick)
      else resolve()
    }
    raf = requestAnimationFrame(tick)
  })
}

async function play(dir: PaperPlaneDirection) {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    return
  }
  clearTimers()
  direction.value = dir
  visible.value = true
  await nextTick()
  await new Promise<void>((r) => requestAnimationFrame(() => r()))

  const sheet = sheetRef.value
  const craft = craftRef.value
  if (sheet) sheet.style.clipPath = diagonalClip(0, dir)
  if (craft) {
    craft.style.opacity = '0'
    const w = window.innerWidth || 1280
    const h = window.innerHeight || 800
    const tip0 = penTip(0, dir, w, h)
    craft.style.transform = penTransform(0, tip0.x, tip0.y, 0)
  }
  if (contactRef.value) contactRef.value.style.opacity = '0'
  if (labelRef.value) labelRef.value.style.opacity = '0'

  const { whenCovered, whenDone } = runStroke()
  await whenCovered
  void whenDone.then(async () => {
    await new Promise<void>((r) => {
      hideTimer = window.setTimeout(r, HOLD_MS)
    })
    await runSheetExit()
    visible.value = false
    clearTimers()
  })
}

onMounted(() => {
  registerPaperPlanePlayer(play)
})

onBeforeUnmount(() => {
  clearTimers()
  registerPaperPlanePlayer(null)
})
</script>

<template>
  <div
    v-if="visible"
    class="brand-transit"
    :class="`brand-transit--${direction}`"
    aria-hidden="true"
  >
    <!-- 书面：对角线裁剪铺开（与笔尖同轴） -->
    <div ref="sheetRef" class="brand-transit__sheet">
      <div class="brand-transit__paper" />
      <p ref="labelRef" class="brand-transit__label">
        <span class="brand-transit__dot" />
        <span>升学通</span>
      </p>
    </div>

    <!-- 笔尖触纸点：小墨点 + 接触阴影，让笔「立」在页面上 -->
    <span ref="contactRef" class="brand-transit__contact" />

    <!-- 笔尖贴着裁剪前沿来回排线 -->
    <div ref="craftRef" class="brand-transit__craft">
      <img
        class="brand-transit__mark"
        src="/brand/transit-pen.png"
        alt=""
        draggable="false"
      />
    </div>
  </div>
</template>

<style scoped>
.brand-transit {
  position: fixed;
  inset: 0;
  z-index: 9999;
  pointer-events: none;
  overflow: hidden;
}

.brand-transit__sheet {
  position: absolute;
  inset: 0;
  z-index: 2;
  clip-path: polygon(0% 100%, 0% 100%, 0% 100%);
  will-change: clip-path;
  display: grid;
  place-items: center;
}

.brand-transit__paper {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(120% 80% at 20% 90%, rgb(148 163 184 / 14%), transparent 55%),
    radial-gradient(90% 70% at 85% 15%, rgb(56 189 248 / 10%), transparent 50%),
    #0f172a;
}

.brand-transit__label {
  position: relative;
  z-index: 1;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 0.55em;
  color: #f8fafc;
  font-size: clamp(32px, 5vw, 64px);
  font-weight: 650;
  letter-spacing: 0.12em;
  opacity: 0;
  white-space: nowrap;
  user-select: none;
}

.brand-transit__dot {
  width: 0.18em;
  height: 0.18em;
  border-radius: 50%;
  background: currentColor;
  flex-shrink: 0;
}

.brand-transit__craft {
  position: fixed;
  left: 0;
  top: 0;
  width: 92px;
  height: 320px;
  opacity: 0;
  transform-origin: 0 0;
  will-change: transform, opacity;
  /* 阴影向右下偏，笔尖处几乎无阴影 → 触纸感 */
  filter: drop-shadow(10px 14px 14px rgb(15 23 42 / 38%));
  z-index: 3;
  backface-visibility: hidden;
}

.brand-transit__contact {
  position: fixed;
  left: 0;
  top: 0;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: radial-gradient(circle, rgb(15 23 42 / 70%) 0%, rgb(15 23 42 / 25%) 45%, transparent 70%);
  opacity: 0;
  transform-origin: 0 0;
  will-change: transform, opacity;
  z-index: 3;
  pointer-events: none;
}

.brand-transit__mark {
  width: 92px;
  height: 320px;
  display: block;
  object-fit: fill;
  background: transparent;
  image-rendering: auto;
}

@media (max-width: 540px) {
  .brand-transit__craft {
    width: 66px;
    height: 230px;
  }

  .brand-transit__mark {
    width: 66px;
    height: 230px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .brand-transit {
    display: none !important;
  }
}
</style>
