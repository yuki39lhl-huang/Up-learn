import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    proxy: {
      // 开发期走网关，与生产一致；Token 由 Axios 注入 Authorization
      '/api': {
        target: 'http://localhost:8082',
        changeOrigin: true,
        // 一点通流式：避免中间层缓冲整段再吐出
        configure: (proxy) => {
          proxy.on('proxyRes', (proxyRes, req) => {
            const url = req.url ?? ''
            if (url.includes('/agent/chat/stream')) {
              proxyRes.headers['cache-control'] = 'no-cache, no-transform'
              proxyRes.headers['x-accel-buffering'] = 'no'
            }
          })
        },
      },
    },
  },
})
