# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: 正在备考**普通专升本**的专科在读/应届考生，需要同时查院校招生与做真题练习。  
Current focus: **广东**专升本招录与卷面场景（产品内默认省份与预览数据以广东为主）。  
Secondary (supported, not primary): 已注册用户在控制台持续打卡刷题、查看考纲与用助手答疑。  
Not primary: 培训机构后台、教师批改工作流、家长端（仓库中无对应产品面）。

## Product Purpose

**升学通（up-learn）** 是一套面向专升本备考的 Web 产品：把「查招生」与「对真题 / 刷题巩固」放进同一控制台，用真实后端数据推进备考，而不是堆功能清单或营销 KPI。  
成功标准：考生能从官网理解价值并进入控制台；在控制台完成院校/专业查询、真题作答、每日一练与随机刷题，数据来自真实服务而非演示假数。

## Positioning

招生预览与真题练习共用一个**学术控制台（Academic Utility Console）**工作台；官网是说服层，控制台是作业层。差异在于「真实接口驱动的招录预览 + 卷面练习闭环」，而不是单独的资讯站或题库 App。

## Operating Context

- Public marketing surface: `/home` 落地页（可匿名浏览招生预览；真题目录需登录）。
- Authenticated workbench: `/console` 多模块单页（hash 切换）：dashboard（含每日一练入口）、school（招生查询）、syllabus（考纲）、papers（真题）、random/practice（随机刷题）、agent（助手）。
- Full exam sheet: `/paper/:id` 卷面作答（含 KaTeX 数学渲染）。
- Auth: 未登录访问受保护路由时引导至登录（官网 query `login=1` 或 `/login`）。
- Local/dev: Vue 前端 + 多微服务（gateway / user / school / practice / agent 等）；主题浅色/深色可切换。

## Capabilities and Constraints

Confirmed capabilities:

- 院校/专业招生库查询与筛选（省份、年份、公办优先等）。
- 历年真题列表与卷面作答/预览。
- 每日一练、随机刷题与作答记录。
- 考纲查阅；对话式 agent 助手。
- 账号与考试偏好（省份、科目等）；浅色/深色主题。

Constraints / terminology:

- 产品名：**升学通**；工程名：up-learn。
- 控制台模块用语：招生查询、考纲、真题、每日一练、随机刷题、助手。
- 官网与营销文案**不得编造**报考人数、通过率、名师背书、虚假客户评价；院校/专业/真题展示以 API 返回为准，空态说明服务未就绪即可。
- 当前数据重心为广东；扩省是产品决策，不是默认已覆盖全国。
- 前端栈已定：Vue 3 + TypeScript + Vite + Element Plus + Pinia + Vue Router；样式以项目 CSS token（含 Stitch / landing tokens）为主，官网不引入 Tailwind 依赖。

Open decisions (do not invent in UI copy):

- 全国扩省时间表与各省数据完备度。
- 商业化/定价（若有）尚未写入本记录。

## Brand Commitments

- 名称展示：**升学通**（中文主名）；英文工程名 up-learn 不作为对外主品牌。
- Logo 资产：`frontend/public/brand/logo-mark.png`（及 favicon 系列）；通过 `BrandLogo` 组件使用。**保留现有 Logo，不擅自更换图标体系。**
- 官网顶栏保留品牌标识；首屏正文区不重复堆第二个同等 Logo。
- Voice: 务实、清晰、像备考工具说明，避免「AI 模板腔」、空洞激励口号与假社会证明。
- Visual direction for marketing: `/home` 采用 **Agent Liftoff**（Antigravity 语法的黑底全屏营销页）；控制台作业层仍为 Academic Utility Console 绿色学术控制台。本文件不规定调色板细节（见 DESIGN.md / surface brief）。

## Evidence on Hand

- Real school/major list APIs（官网与控制台招生预览共用）。
- Real paper list/detail APIs（登录后）；卷面含公式渲染。
- Brand raster assets under `frontend/public/brand/`.
- **Do not fabricate:** testimonials, press quotes, “近百万考生”、机构合作徽章、未接入的省份覆盖声明。

## Product Principles

1. **真实数据优先** — 界面展示与空态诚实对应后端；宁缺毋假。
2. **控制台即产品** — 官网说服，控制台交付；深度任务不在落地页半做半不做。
3. **一条备考路径** — 查招生 → 对真题 → 刷题巩固，信息架构跟着考生任务走。
4. **品牌克制** — Logo 与名称清晰出现一次即可；不靠装饰噪点或重复标识堆信任。
5. **可扫可读** — 表格、卷面、筛选项优先于卡片秀与假 KPI 条。

## Accessibility & Inclusion

- 支持浅色/深色主题切换；动效需尊重 `prefers-reduced-motion`。
- 中文为主界面语言；部分 UI 字符串经 i18n store，扩文案时保持中文优先可读。
- 未单独约定 WCAG 等级；新 UI 至少保证可键盘聚焦的主要 CTA、有意义的按钮标签与足够对比度。
