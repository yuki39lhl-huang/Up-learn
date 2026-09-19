import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { consoleLocation, markConsoleDashboardEntry } from '../utils/consoleNav'
import {
  playPaperPlaneTransit,
  resolvePaperPlaneDirection,
} from '../utils/paperPlaneTransit'

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
    {
      path: '/paper/:id',
      name: 'paper-exam',
      component: () => import('../views/PaperExamView.vue'),
      meta: { title: '试卷作答', requiresAuth: true },
    },
    {
      path: '/community/compose',
      name: 'community-compose',
      component: () => import('../views/community/CommunityComposeView.vue'),
      meta: { title: '发布帖子', requiresAuth: true },
    },
    {
      path: '/community/post/:id',
      name: 'community-post',
      component: () => import('../views/community/CommunityPostView.vue'),
      meta: { title: '帖子详情', requiresAuth: true },
    },
    {
      path: '/community/u/:userId',
      name: 'community-profile',
      component: () => import('../views/community/CommunityProfileView.vue'),
      meta: { title: '个人主页', requiresAuth: true },
    },
    { path: '/practice', redirect: { path: '/console', hash: '#dashboard' } },
  ],
})

router.beforeEach(async (to, from) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { path: '/home', query: { login: '1', redirect: to.fullPath } }
  }
  if (to.meta.guest && auth.isLoggedIn && to.path === '/login') {
    markConsoleDashboardEntry()
    return consoleLocation('dashboard')
  }

  const dir = resolvePaperPlaneDirection(from.path, to.path)
  if (dir) {
    await playPaperPlaneTransit(dir)
  }
  return true
})

export default router
