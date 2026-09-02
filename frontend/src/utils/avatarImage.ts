/** 头像裁剪画布与导出参数 */
export const AVATAR_CROP_WIDTH = 520
export const AVATAR_CROP_HEIGHT = 400
export const AVATAR_EXPORT_SIZE = 512
export const AVATAR_JPEG_QUALITY = 0.88
export const AVATAR_MAX_INPUT_BYTES = 10 * 1024 * 1024
export const CROP_HANDLE_SIZE = 10

export type CropHandle =
  | 'nw'
  | 'n'
  | 'ne'
  | 'e'
  | 'se'
  | 's'
  | 'sw'
  | 'w'
  | 'move-crop'
  | 'pan'
  | null

export interface AvatarCropState {
  scale: number
  offsetX: number
  offsetY: number
  cropX: number
  cropY: number
  cropSize: number
}

export function readImageFromFile(file: File): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const url = URL.createObjectURL(file)
    const img = new Image()
    img.onload = () => {
      URL.revokeObjectURL(url)
      resolve(img)
    }
    img.onerror = () => {
      URL.revokeObjectURL(url)
      reject(new Error('图片无法读取'))
    }
    img.src = url
  })
}

function fitScale(img: HTMLImageElement) {
  const pad = 24
  const maxW = AVATAR_CROP_WIDTH - pad * 2
  const maxH = AVATAR_CROP_HEIGHT - pad * 2
  return Math.min(maxW / img.width, maxH / img.height)
}

export function initialAvatarCropState(img: HTMLImageElement): AvatarCropState {
  const scale = fitScale(img)
  const cropSize = Math.min(
    280,
    Math.min(AVATAR_CROP_WIDTH, AVATAR_CROP_HEIGHT) * 0.72,
  )
  return {
    scale,
    offsetX: 0,
    offsetY: 0,
    cropX: (AVATAR_CROP_WIDTH - cropSize) / 2,
    cropY: (AVATAR_CROP_HEIGHT - cropSize) / 2,
    cropSize,
  }
}

export function sourceCropSize(state: AvatarCropState) {
  return Math.round(state.cropSize / state.scale)
}

export function imageDrawRect(img: HTMLImageElement, state: AvatarCropState) {
  const w = img.width * state.scale
  const h = img.height * state.scale
  const x = AVATAR_CROP_WIDTH / 2 - w / 2 + state.offsetX
  const y = AVATAR_CROP_HEIGHT / 2 - h / 2 + state.offsetY
  return { x, y, w, h }
}

export function clampCropBox(state: AvatarCropState): AvatarCropState {
  const minSize = 96
  const maxSize = Math.min(AVATAR_CROP_WIDTH, AVATAR_CROP_HEIGHT) - 16
  let { cropX, cropY, cropSize } = state
  cropSize = Math.min(maxSize, Math.max(minSize, cropSize))
  cropX = Math.min(AVATAR_CROP_WIDTH - cropSize - 8, Math.max(8, cropX))
  cropY = Math.min(AVATAR_CROP_HEIGHT - cropSize - 8, Math.max(8, cropY))
  return { ...state, cropX, cropY, cropSize }
}

export function hitTestHandle(canvasX: number, canvasY: number, state: AvatarCropState): CropHandle {
  const { cropX, cropY, cropSize } = state
  const hs = CROP_HANDLE_SIZE + 4
  const cx = cropX + cropSize / 2
  const cy = cropY + cropSize / 2
  const points: { id: CropHandle; x: number; y: number }[] = [
    { id: 'nw', x: cropX, y: cropY },
    { id: 'n', x: cx, y: cropY },
    { id: 'ne', x: cropX + cropSize, y: cropY },
    { id: 'e', x: cropX + cropSize, y: cy },
    { id: 'se', x: cropX + cropSize, y: cropY + cropSize },
    { id: 's', x: cx, y: cropY + cropSize },
    { id: 'sw', x: cropX, y: cropY + cropSize },
    { id: 'w', x: cropX, y: cy },
  ]
  for (const p of points) {
    if (Math.abs(canvasX - p.x) <= hs && Math.abs(canvasY - p.y) <= hs) {
      return p.id
    }
  }
  if (
    canvasX >= cropX &&
    canvasX <= cropX + cropSize &&
    canvasY >= cropY &&
    canvasY <= cropY + cropSize
  ) {
    return 'move-crop'
  }
  return 'pan'
}

export function drawAvatarCropPreview(
  canvas: HTMLCanvasElement,
  img: HTMLImageElement,
  state: AvatarCropState,
) {
  const ctx = canvas.getContext('2d')
  if (!ctx) return

  ctx.clearRect(0, 0, AVATAR_CROP_WIDTH, AVATAR_CROP_HEIGHT)
  ctx.fillStyle = '#0f172a'
  ctx.fillRect(0, 0, AVATAR_CROP_WIDTH, AVATAR_CROP_HEIGHT)

  const { x, y, w, h } = imageDrawRect(img, state)
  ctx.drawImage(img, x, y, w, h)

  const { cropX, cropY, cropSize } = state
  ctx.fillStyle = 'rgba(15, 23, 42, 0.55)'
  ctx.fillRect(0, 0, AVATAR_CROP_WIDTH, cropY)
  ctx.fillRect(0, cropY + cropSize, AVATAR_CROP_WIDTH, AVATAR_CROP_HEIGHT - cropY - cropSize)
  ctx.fillRect(0, cropY, cropX, cropSize)
  ctx.fillRect(cropX + cropSize, cropY, AVATAR_CROP_WIDTH - cropX - cropSize, cropSize)

  ctx.strokeStyle = '#3b82f6'
  ctx.lineWidth = 2
  ctx.strokeRect(cropX, cropY, cropSize, cropSize)

  const hs = CROP_HANDLE_SIZE / 2
  const handles = [
    [cropX, cropY],
    [cropX + cropSize / 2, cropY],
    [cropX + cropSize, cropY],
    [cropX + cropSize, cropY + cropSize / 2],
    [cropX + cropSize, cropY + cropSize],
    [cropX + cropSize / 2, cropY + cropSize],
    [cropX, cropY + cropSize],
    [cropX, cropY + cropSize / 2],
  ]
  ctx.fillStyle = '#ffffff'
  ctx.strokeStyle = '#3b82f6'
  ctx.lineWidth = 1.5
  for (const [hx, hy] of handles) {
    ctx.beginPath()
    ctx.rect(hx - hs, hy - hs, CROP_HANDLE_SIZE, CROP_HANDLE_SIZE)
    ctx.fill()
    ctx.stroke()
  }
}

export function exportAvatarBlob(
  img: HTMLImageElement,
  state: AvatarCropState,
): Promise<Blob> {
  const { x, y } = imageDrawRect(img, state)
  const srcX = (state.cropX - x) / state.scale
  const srcY = (state.cropY - y) / state.scale
  const srcSize = state.cropSize / state.scale

  const out = document.createElement('canvas')
  out.width = AVATAR_EXPORT_SIZE
  out.height = AVATAR_EXPORT_SIZE
  const ctx = out.getContext('2d')
  if (!ctx) {
    return Promise.reject(new Error('无法导出图片'))
  }
  ctx.drawImage(img, srcX, srcY, srcSize, srcSize, 0, 0, AVATAR_EXPORT_SIZE, AVATAR_EXPORT_SIZE)

  return new Promise((resolve, reject) => {
    out.toBlob(
      (blob) => {
        if (!blob) {
          reject(new Error('无法导出图片'))
          return
        }
        resolve(blob)
      },
      'image/jpeg',
      AVATAR_JPEG_QUALITY,
    )
  })
}

export function resizeCropByHandle(
  state: AvatarCropState,
  handle: CropHandle,
  dx: number,
  dy: number,
): AvatarCropState {
  if (!handle || handle === 'pan' || handle === 'move-crop') return state

  let { cropX, cropY, cropSize } = state
  let delta = 0

  switch (handle) {
    case 'se':
      delta = Math.max(dx, dy)
      break
    case 'nw':
      delta = -Math.max(-dx, -dy)
      cropX -= delta
      cropY -= delta
      break
    case 'ne':
      delta = Math.max(dx, -dy)
      cropY -= delta
      break
    case 'sw':
      delta = Math.max(-dx, dy)
      cropX -= delta
      break
    case 'e':
      delta = dx
      break
    case 'w':
      delta = -dx
      cropX -= delta
      break
    case 's':
      delta = dy
      break
    case 'n':
      delta = -dy
      cropY -= delta
      break
  }

  cropSize += delta
  return clampCropBox({ ...state, cropX, cropY, cropSize })
}

export function formatFileSize(bytes: number) {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}
