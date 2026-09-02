<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue'
import {
  AVATAR_CROP_HEIGHT,
  AVATAR_CROP_WIDTH,
  AVATAR_MAX_INPUT_BYTES,
  clampCropBox,
  drawAvatarCropPreview,
  exportAvatarBlob,
  formatFileSize,
  hitTestHandle,
  initialAvatarCropState,
  readImageFromFile,
  resizeCropByHandle,
  sourceCropSize,
  type AvatarCropState,
  type CropHandle,
} from '../../utils/avatarImage'

const visible = defineModel<boolean>({ default: false })

const props = defineProps<{
  file: File | null
}>()

const emit = defineEmits<{
  confirm: [blob: Blob]
}>()

const canvasRef = ref<HTMLCanvasElement | null>(null)
const image = ref<HTMLImageElement | null>(null)
const cropState = ref<AvatarCropState>({
  scale: 1,
  offsetX: 0,
  offsetY: 0,
  cropX: 0,
  cropY: 0,
  cropSize: 200,
})
const baseScale = ref(1)
const activeHandle = ref<CropHandle>(null)
const dragOrigin = ref({ x: 0, y: 0, state: null as AvatarCropState | null })
const submitting = ref(false)

const fileLabel = computed(() => (props.file ? formatFileSize(props.file.size) : ''))
const cropLabel = computed(() => {
  const px = sourceCropSize(cropState.value)
  return `${px} × ${px}`
})

watch(
  () => [visible.value, props.file] as const,
  async ([open, file]) => {
    if (!open || !file) {
      image.value = null
      activeHandle.value = null
      return
    }
    const img = await readImageFromFile(file)
    image.value = img
    const initial = initialAvatarCropState(img)
    cropState.value = initial
    baseScale.value = initial.scale
    await nextTick()
    redraw()
  },
)

function redraw() {
  if (!canvasRef.value || !image.value) return
  drawAvatarCropPreview(canvasRef.value, image.value, cropState.value)
}

function canvasPoint(e: PointerEvent) {
  const canvas = canvasRef.value!
  const rect = canvas.getBoundingClientRect()
  return {
    x: ((e.clientX - rect.left) / rect.width) * AVATAR_CROP_WIDTH,
    y: ((e.clientY - rect.top) / rect.height) * AVATAR_CROP_HEIGHT,
    scaleX: AVATAR_CROP_WIDTH / rect.width,
    scaleY: AVATAR_CROP_HEIGHT / rect.height,
  }
}

function clampImageScale(scale: number) {
  const min = baseScale.value * 0.4
  const max = baseScale.value * 4
  return Math.min(max, Math.max(min, scale))
}

function onWheel(e: WheelEvent) {
  e.preventDefault()
  if (!image.value) return
  const factor = e.deltaY > 0 ? 0.92 : 1.08
  cropState.value = {
    ...cropState.value,
    scale: clampImageScale(cropState.value.scale * factor),
  }
  redraw()
}

function onPointerDown(e: PointerEvent) {
  const pt = canvasPoint(e)
  activeHandle.value = hitTestHandle(pt.x, pt.y, cropState.value)
  dragOrigin.value = {
    x: e.clientX,
    y: e.clientY,
    state: { ...cropState.value },
  }
  ;(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId)
}

function onPointerMove(e: PointerEvent) {
  if (!activeHandle.value || !dragOrigin.value.state || !canvasRef.value) return
  const rect = canvasRef.value.getBoundingClientRect()
  const dx = ((e.clientX - dragOrigin.value.x) / rect.width) * AVATAR_CROP_WIDTH
  const dy = ((e.clientY - dragOrigin.value.y) / rect.height) * AVATAR_CROP_HEIGHT

  const base = dragOrigin.value.state
  if (activeHandle.value === 'pan') {
    cropState.value = { ...base, offsetX: base.offsetX + dx, offsetY: base.offsetY + dy }
  } else if (activeHandle.value === 'move-crop') {
    cropState.value = clampCropBox({ ...base, cropX: base.cropX + dx, cropY: base.cropY + dy })
  } else {
    cropState.value = resizeCropByHandle(base, activeHandle.value, dx, dy)
  }
  redraw()
}

function onPointerUp(e: PointerEvent) {
  activeHandle.value = null
  dragOrigin.value.state = null
  ;(e.currentTarget as HTMLElement).releasePointerCapture(e.pointerId)
}

async function handleConfirm() {
  if (!image.value || submitting.value) return
  submitting.value = true
  try {
    const blob = await exportAvatarBlob(image.value, cropState.value)
    emit('confirm', blob)
    visible.value = false
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <Teleport to="body">
    <Transition name="crop-fade">
      <div v-if="visible" class="avatar-crop-overlay" @click.self="visible = false">
        <div class="avatar-crop-modal">
          <button type="button" class="avatar-crop-modal__close" aria-label="关闭" @click="visible = false">
            ×
          </button>

          <div
            class="avatar-crop-stage"
            @pointerdown="onPointerDown"
            @pointermove="onPointerMove"
            @pointerup="onPointerUp"
            @pointercancel="onPointerUp"
            @wheel="onWheel"
          >
            <canvas
              ref="canvasRef"
              :width="AVATAR_CROP_WIDTH"
              :height="AVATAR_CROP_HEIGHT"
              class="avatar-crop-canvas"
            />
            <div
              class="avatar-crop-size"
              :style="{
                left: `${(cropState.cropX / AVATAR_CROP_WIDTH) * 100}%`,
                top: `${(cropState.cropY / AVATAR_CROP_HEIGHT) * 100}%`,
              }"
            >
              {{ cropLabel }}
            </div>
          </div>

          <p v-if="file && file.size > AVATAR_MAX_INPUT_BYTES" class="avatar-crop-warn">
            原图 {{ fileLabel }}，超过 10MB 建议换一张
          </p>
          <p v-else-if="file" class="avatar-crop-tip">
            拖动选框或图片 · 拖边角缩放 · 滚轮缩放图片
          </p>

          <div class="avatar-crop-actions">
            <el-button class="avatar-crop-actions__btn" @click="visible = false">取消</el-button>
            <el-button
              type="primary"
              class="avatar-crop-actions__btn avatar-crop-actions__btn--primary"
              :loading="submitting"
              :disabled="!image"
              @click="handleConfirm"
            >
              确认
            </el-button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.avatar-crop-overlay {
  position: fixed;
  inset: 0;
  z-index: 3000;
  display: grid;
  place-items: center;
  padding: 24px;
  background: rgb(15 23 42 / 72%);
  backdrop-filter: blur(4px);
}

.avatar-crop-modal {
  position: relative;
  width: min(560px, calc(100vw - 32px));
  padding: 20px 20px 16px;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 24px 48px rgb(15 23 42 / 22%);
}

.avatar-crop-modal__close {
  position: absolute;
  top: 10px;
  right: 12px;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 8px;
  background: transparent;
  color: #64748b;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
}

.avatar-crop-modal__close:hover {
  background: rgb(100 116 139 / 12%);
}

.avatar-crop-stage {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  touch-action: none;
  cursor: crosshair;
}

.avatar-crop-canvas {
  display: block;
  width: 100%;
  height: auto;
  vertical-align: top;
}

.avatar-crop-size {
  position: absolute;
  transform: translate(8px, 8px);
  padding: 2px 8px;
  border-radius: 4px;
  background: rgb(15 23 42 / 72%);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  pointer-events: none;
}

.avatar-crop-tip,
.avatar-crop-warn {
  margin: 10px 0 0;
  font-size: 12px;
  text-align: center;
}

.avatar-crop-tip {
  color: #64748b;
}

.avatar-crop-warn {
  color: #b45309;
}

.avatar-crop-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 16px;
}

.avatar-crop-actions__btn {
  min-width: 120px;
}

.avatar-crop-actions__btn--primary {
  --el-button-bg-color: #2563eb;
  --el-button-border-color: #2563eb;
}

.crop-fade-enter-active,
.crop-fade-leave-active {
  transition: opacity 0.2s ease;
}

.crop-fade-enter-from,
.crop-fade-leave-to {
  opacity: 0;
}
</style>
