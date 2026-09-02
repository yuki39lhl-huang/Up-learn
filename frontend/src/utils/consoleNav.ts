import type { Router, RouteLocationRaw } from 'vue-router'

export type ConsoleModule =
  | 'dashboard'
  | 'school'
  | 'syllabus'
  | 'random'
  | 'papers'
  | 'community'
  | 'agent'

const MODULE_HASH: Record<ConsoleModule, string> = {
  dashboard: '#dashboard',
  school: '#school',
  syllabus: '#syllabus',
  random: '#practice',
  papers: '#papers',
  community: '#community',
  agent: '#agent',
}

/** 控制台路由对象（history 模式下 hash 须单独字段） */
export function consoleLocation(
  module: ConsoleModule = 'dashboard',
  query?: Record<string, string>,
): RouteLocationRaw {
  return {
    path: '/console',
    hash: MODULE_HASH[module],
    query,
  }
}

export function consoleFullPath(module: ConsoleModule = 'dashboard', query?: Record<string, string>) {
  const q = query
    ? `?${new URLSearchParams(query).toString()}`
    : ''
  return `/console${MODULE_HASH[module]}${q}`
}

export function pushConsole(router: Router, module: ConsoleModule = 'dashboard', query?: Record<string, string>) {
  return router.push(consoleLocation(module, query))
}

const DASHBOARD_ENTRY_KEY = 'ul_console_dashboard_entry'

/** 标记下次进入控制台时应落到主页（用于登录后默认主页） */
export function markConsoleDashboardEntry() {
  sessionStorage.setItem(DASHBOARD_ENTRY_KEY, '1')
}

/** 消费主页标记；返回 true 表示应强制主页 */
export function consumeConsoleDashboardEntry() {
  const hit = sessionStorage.getItem(DASHBOARD_ENTRY_KEY) === '1'
  if (hit) sessionStorage.removeItem(DASHBOARD_ENTRY_KEY)
  return hit
}

export function isDashboardConsoleHref(href: string) {
  const hashIndex = href.indexOf('#')
  if (hashIndex < 0) return true
  const hash = href.slice(hashIndex)
  return hash === '#dashboard' || hash === '#home' || hash === '#daily' || hash === '#'
}

/** 解析 `/console#dashboard` 等字符串并跳转（兼容登录 redirect） */
export function pushConsoleHref(router: Router, href: string) {
  const hashIndex = href.indexOf('#')
  const hash = hashIndex >= 0 ? href.slice(hashIndex) : '#dashboard'
  const moduleMap: Record<string, ConsoleModule> = {
    '#dashboard': 'dashboard',
    '#home': 'dashboard',
    '#daily': 'dashboard',
    '#school': 'school',
    '#syllabus': 'syllabus',
    '#practice': 'random',
    '#random': 'random',
    '#papers': 'papers',
    '#community': 'community',
    '#agent': 'agent',
  }
  const module = moduleMap[hash] ?? 'dashboard'
  const queryIndex = href.indexOf('?')
  const queryStr =
    queryIndex >= 0 && hashIndex > queryIndex
      ? href.slice(queryIndex + 1, hashIndex)
      : queryIndex >= 0
        ? href.slice(queryIndex + 1)
        : ''
  const query = queryStr ? Object.fromEntries(new URLSearchParams(queryStr)) : undefined
  return pushConsole(router, module, query)
}
