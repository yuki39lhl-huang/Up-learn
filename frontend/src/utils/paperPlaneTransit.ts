/** 官网 ↔ 控制台纸飞机过场 */

export type PaperPlaneDirection = 'to-console' | 'to-home'

type Player = (dir: PaperPlaneDirection) => Promise<void>

let player: Player | null = null
let inflight: Promise<void> | null = null

export function registerPaperPlanePlayer(fn: Player | null) {
  player = fn
}

function isLandingPath(path: string) {
  return path === '/home' || path === '/'
}

function isConsolePath(path: string) {
  return path.startsWith('/console')
}

/** 根据路由判断是否需要飞行动画 */
export function resolvePaperPlaneDirection(
  fromPath: string,
  toPath: string,
): PaperPlaneDirection | null {
  if (!fromPath || fromPath === toPath) return null
  if (isLandingPath(fromPath) && isConsolePath(toPath)) return 'to-console'
  if (isConsolePath(fromPath) && isLandingPath(toPath)) return 'to-home'
  return null
}

/**
 * 播放过场；铺满挡屏后再放行路由，飞完淡出在后台继续。
 */
export async function playPaperPlaneTransit(dir: PaperPlaneDirection) {
  if (!player) return
  if (inflight) {
    await inflight
    return
  }
  inflight = player(dir).finally(() => {
    inflight = null
  })
  await inflight
}
