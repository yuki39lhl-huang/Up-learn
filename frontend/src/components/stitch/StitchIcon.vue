<script setup lang="ts">
defineProps<{
  name:
    | 'filter'
    | 'school'
    | 'trend'
    | 'practice'
    | 'code'
    | 'cpu'
    | 'layers'
    | 'flame'
    | 'paper'
    | 'spark'
    | 'community'
    | 'settings'
    | 'bell'
    | 'daily'
    | 'menu'
    | 'agent'
    | 'home'
    | 'syllabus'
}>()
</script>

<template>
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <!-- 精准筛选 -->
    <template v-if="name === 'filter'">
      <path d="M4 6h16M7 12h10M10 18h4" />
    </template>
    <!-- 权威分类 -->
    <template v-else-if="name === 'school'">
      <path d="M3 21h18M5 21V7l7-4 7 4v14M9 21v-6h6v6" />
    </template>
    <!-- 分数趋势 -->
    <template v-else-if="name === 'trend'">
      <path d="M4 18l4-6 4 3 5-8 3 5" />
      <path d="M4 20h16" />
    </template>
    <!-- 沉浸练习 -->
    <template v-else-if="name === 'practice'">
      <path d="M12 20h9" />
      <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z" />
    </template>
    <!-- 软件工程 -->
    <template v-else-if="name === 'code'">
      <path d="M16 18l6-6-6-6M8 6l-6 6 6 6" />
    </template>
    <!-- 计科 -->
    <template v-else-if="name === 'cpu'">
      <rect x="5" y="5" width="14" height="14" rx="2" />
      <path d="M9 9h6v6H9zM9 2v2M15 2v2M9 20v2M15 20v2M2 9h2M2 15h2M20 9h2M20 15h2" />
    </template>
    <!-- 计算机基础 -->
    <template v-else-if="name === 'layers'">
      <path d="M12 2 2 7l10 5 10-5-10-5Z" />
      <path d="m2 12 10 5 10-5M2 17l10 5 10-5" />
    </template>
    <!-- 连续打卡 -->
    <template v-else-if="name === 'flame'">
      <path d="M12 22c4-2.5 6-5.5 6-9a6 6 0 0 0-11-3 6 6 0 0 0-11 3c0 3.5 2 6.5 6 9Z" />
      <path d="M12 22c-1.5-2-2-3.5-2-5a3 3 0 0 1 6 0c0 1.5-.5 3-2 5Z" />
    </template>
    <!-- 试卷 -->
    <template v-else-if="name === 'paper'">
      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z" />
      <path d="M14 2v6h6M8 13h8M8 17h5" />
    </template>
    <!-- AI 评分 -->
    <template v-else-if="name === 'spark'">
      <path d="M12 3 13.5 8.5 19 10l-5.5 1.5L12 17l-1.5-5.5L5 10l5.5-1.5Z" />
      <path d="M5 3v2M19 19v2M3 19h2M21 5h2" />
    </template>
    <template v-else-if="name === 'community'">
      <path d="M17 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
      <circle cx="9.5" cy="7" r="3" />
      <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
    </template>
    <template v-else-if="name === 'settings'">
      <circle cx="12" cy="12" r="3" />
      <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
    </template>
    <template v-else-if="name === 'bell'">
      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
      <path d="M13.73 21a2 2 0 0 1-3.46 0" />
    </template>
    <template v-else-if="name === 'daily'">
      <rect x="3" y="4" width="18" height="18" rx="2" />
      <path d="M16 2v4M8 2v4M3 10h18" />
    </template>
    <template v-else-if="name === 'menu'">
      <path d="M4 7h16M4 12h16M4 17h16" />
    </template>
    <template v-else-if="name === 'agent'">
      <path d="M12 8V4H8" />
      <rect x="4" y="8" width="16" height="12" rx="2" />
      <path d="M9 13h.01M15 13h.01M9 17h6" />
    </template>
    <template v-else-if="name === 'home'">
      <path d="M3 10.5 12 3l9 7.5" />
      <path d="M5 10v10h14V10" />
    </template>
    <template v-else-if="name === 'syllabus'">
      <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
      <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z" />
      <path d="M8 7h8M8 11h6" />
    </template>
  </svg>
</template>
