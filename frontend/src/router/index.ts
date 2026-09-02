import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { consoleLocation, markConsoleDashboardEntry } from '../utils/consoleNav'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/home' },
    {
      path: '/home',
      component: () => import('../views/HomeView.vue'),
      meta: { title: '首页' },
    },
    {
      path: '/login',
      component: () => import('../views/LoginView.vue'),
      meta: { title: '登录', guest: true },
    },
    {
      path: '/console',
      component: () => import('../views/ConsoleView.vue'),
      meta: { title: '工作台', requiresAuth: true },
      beforeEnter: (to) => {
        if (!to.hash || to.hash === '#') {
          return { path: '/console', hash: '#dashboard', replace: true }
        }
      },
    },
    { path: '/practice', redirect: { path: '/console', hash: '#dashboard' } },
  ],
})

router.beforeEach((to) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { path: '/home', query: { login: '1', redirect: to.fullPath } }
  }
  if (to.meta.guest && auth.isLoggedIn && to.path === '/login') {
    markConsoleDashboardEntry()
    return consoleLocation('dashboard')
  }
  return true
})

export default router
