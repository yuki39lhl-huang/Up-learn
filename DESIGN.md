---
name: 升学通 (up-learn)
description: 双层视觉 — 官网 Agent Liftoff（黑底 Antigravity 语法）+ 控制台 Academic Utility Console（绿色学术作业台）。
colors:
  # 控制台 / Operate（主系统）
  primary: "#006e2f"
  primary-hover: "#005725"
  primary-soft: "rgb(0 110 47 / 10%)"
  primary-on: "#ffffff"
  secondary: "#0058be"
  secondary-soft: "#e6f0fa"
  background: "#f9f9ff"
  bg-muted: "#f0f4f0"
  surface: "#ffffff"
  text: "#151c27"
  text-muted: "#3d4a3d"
  border: "#e1e7e1"
  divider: "#e1e7e1"
  nav-bg: "color-mix(in srgb, #ffffff 92%, transparent)"
  # 官网 / Persuade（Agent Liftoff，scoped 于 .landing-page）
  landing-bg: "#000000"
  landing-surface: "#121212"
  landing-text: "#f3f3f3"
  landing-muted: "#a3a3a3"
  landing-cta-bg: "#f5f5f5"
  landing-cta-fg: "#0a0a0a"
typography:
  display:
    fontFamily: "Figtree, 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif"
    fontSize: "clamp(2.25rem, 7vw, 4.25rem)"
    fontWeight: 500
    lineHeight: 1.12
    letterSpacing: "-0.04em"
  headline:
    fontFamily: "Figtree, 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif"
    fontSize: "clamp(1.5rem, 3vw, 2rem)"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.03em"
  title:
    fontFamily: "Figtree, 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 700
    lineHeight: 1.35
    letterSpacing: "-0.02em"
  body:
    fontFamily: "Figtree, 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.65
    letterSpacing: "normal"
  label:
    fontFamily: "Inter, 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', sans-serif"
    fontSize: "0.875rem"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "normal"
  mono:
    fontFamily: "'JetBrains Mono', ui-monospace, monospace"
    fontSize: "0.75rem"
    fontWeight: 600
    lineHeight: 1.4
    letterSpacing: "0.06em"
rounded:
  sm: "4px"
  soft: "6px"
  md: "8px"
  lg: "12px"
spacing:
  xs: "8px"
  sm: "12px"
  md: "16px"
  lg: "24px"
  xl: "32px"
  section: "64px"
  container: "1240px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-on}"
    rounded: "{rounded.md}"
    padding: "0 1.25rem"
    height: "2.75rem"
    typography: "{typography.label}"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
    textColor: "{colors.primary-on}"
    rounded: "{rounded.md}"
    padding: "0 1.25rem"
    height: "2.75rem"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "0 1.25rem"
    height: "2.75rem"
  button-ghost-hover:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "0 1.25rem"
    height: "2.75rem"
  chip:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text-muted}"
    rounded: "{rounded.soft}"
    padding: "0 0.85rem"
    height: "2.5rem"
  chip-active:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    rounded: "{rounded.soft}"
    padding: "0 0.85rem"
    height: "2.5rem"
  input-search:
    backgroundColor: "{colors.background}"
    textColor: "{colors.text-muted}"
    rounded: "{rounded.soft}"
    padding: "0 0.75rem"
    height: "2.25rem"
  nav-link:
    backgroundColor: "transparent"
    textColor: "{colors.text-muted}"
    typography: "{typography.label}"
---

# Design System: 升学通 (up-learn)

## Overview

**Creative North Star: dual surface — "Agent Liftoff" (marketing) + "Academic Utility Console" (workbench)**

官网 `/home` 采用用户选定的 Antigravity 语法：**近纯黑全屏、居中打字标题、彩虹光标、稀疏多色粒子、白底主 CTA**；滚下去才是真实招生表与刷题入口。控制台 `/console` 仍为冷静可读的绿色学术作业台（表格、筛选、卷面），气质务实、工具向。

品牌资产固定：中文主名「升学通」、`BrandLogo`。已确认拒绝：假 KPI、首屏重复 Logo、用装饰卡片替代数据表。

**Key Characteristics:**
- 官网：黑场 `#000` + Figtree/中文无衬线大标题 + 彩虹竖光标 + Canvas 粒子
- 控制台：冷纸白底 + 稀有森林绿主色 + 次级招生蓝（Stitch / Element Plus）
- 动效尊重 `prefers-reduced-motion`；官网 token 锁定在 `.landing-page`，不污染控制台主题

## Colors

调色板是冷静的学术绿系：主色稀有且有目的，中性色承担阅读与分区，次级蓝用于招生/信息类次强调。

### Primary
- **Forest Academic Green** (`#006e2f`): CTA、活动筛选、行内强调链接、事实点缀。Hover 加深为 `#005725`；软底 `rgb(0 110 47 / 10%)` 用于 ghost hover 与 tag。
- **On Primary** (`#ffffff`): 主按钮文字。

### Secondary
- **Admission Blue** (`#0058be`): 次级信息强调与控制台导航选中语义（与 Stitch `--st-secondary` 对齐）；软底 `#e6f0fa`。

### Neutral
- **Cool Paper** (`#f9f9ff`): 页面背景。
- **Muted Grove** (`#f0f4f0`): 交替区块、表头、控制台顶栏。
- **Surface White** (`#ffffff`): 卡片、表格壳、导航按钮底。
- **Ink** (`#151c27`): 标题与主文案。
- **Ink Muted** (`#3d4a3d`): 导语、元数据、次级链接默认色。
- **Hairline Border / Divider** (`#e1e7e1`): 描边与分隔。

### Named Rules
**The Rare Green Rule.** 主绿在任一屏幕上只占决策点（主 CTA、选中态、关键链接），其稀有性即权威感。  
**The Honest Data Rule.** 颜色不用于伪造信任条或 KPI；空态用中性文案说明服务未就绪即可。

## Typography

**Display Font:** Inter（中文回退 Noto Sans SC / PingFang SC / Microsoft YaHei）  
**Body Font:** 同上  
**Label/Mono Font:** JetBrains Mono（步骤号、控制台标题条、小型元标签）  
**Brand wordmark:** PingFang / YaHei 系字标（`BrandLogo`），字重约 650，字距偏宽。

**Character:** 西文 Inter 提供现代工具感；中文系统无衬线保证可读；等宽字体把「控制台」气质钉在元数据层，而不是装饰层。

### Hierarchy
- **Display** (700, `clamp(2.25rem, 5vw, 3.5rem)`, lh 1.08): 官网 hero 标题。
- **Headline** (700, `clamp(1.5rem, 3vw, 2rem)`, lh 1.2): 区块标题。
- **Title** (700, `1.0625rem`): 步骤卡、列表主名。
- **Body** (400, `1rem`–`1.0625rem`, lh ~1.6–1.65): 导语与说明；hero lead 最大宽约 32rem。
- **Label** (500–600, `0.8125rem`–`0.875rem`): 导航链接、按钮、筛选芯片。
- **Mono** (600, `0.6875rem`–`0.75rem`, tracking 偏宽): 控制台条目标题、旅程步骤号。

### Named Rules
**The Tool Type Rule.** 标题靠字重与字距表达层级，不靠装饰字体或全大写口号墙。

## Layout

空间模型是单列学术阅读流 + 宽屏双栏 hero：内容容器 `width: min(100% - 2.5rem, 1120px)`（窄屏水平内边距收至 `1.5rem`）。区块垂直 padding 约 `4rem`；区块标题区最大宽约 `36rem`。

宽屏断点习惯：导航链接 ≥900px；hero 双栏 ≥960px；旅程三列 ≥800px；筛选项与表格在小屏允许横向滚动。密度中等：表格行 padding ~0.85–1rem，筛选芯片紧凑排列。官网与控制台共享 token 语汇，但官网用 `lp-*` 表达说服层，控制台用 Stitch / Element Plus 表达作业层。

### Named Rules
**The One Job Section Rule.** 每个区块一件事：一个标题、一句说明、一组真实控件或数据。

## Elevation & Depth

默认偏平：表面靠边框与背景色阶分层。阴影只做轻量 ambient 与 hover/产品框 lift，不造戏剧性多层景深。导航使用半透明白 + `backdrop-filter` 毛玻璃，属于壳层深度而非卡片堆叠。

### Shadow Vocabulary
- **Ambient** (`0 2px 8px rgb(0 0 0 / 4%)` → `--apple-shadow`): 步骤卡 hover、轻抬起表面。
- **Lift** (`0 8px 24px rgb(0 110 47 / 8%), 0 2px 6px rgb(0 0 0 / 2%)` → `--apple-shadow-lift`): 首屏控制台产品框等焦点物件。
- **Primary CTA glow** (`0 4px 14px rgb(0 110 47 / 22%)`, hover 加深): 仅主按钮。

### Named Rules
**The Flat-By-Default Rule.** 静止表面扁平；阴影响应状态或标记唯一产品焦点，不作装饰堆叠。

## Shapes

圆角克制、功能导向：标签与小控件 `4px`；筛选/输入软角 `6px`；内容卡与表壳 `8px`；首屏控制台外框 `12px`；主按钮与主题切换为全圆角胶囊 `999px`。边框一律细发丝线（`#e1e7e1`），不使用厚描边或大圆角消费级卡片语言。

### Named Rules
**The Soft Square Rule.** 主/次按钮与主题切换用 8px 工具台圆角，不用全圆角胶囊；数据芯片保持 6px。

## Components

### Buttons
- **Shape:** 全圆角胶囊 (`999px`)；标准高 `2.75rem`，sm `2.25rem`。
- **Primary:** 背景 `{colors.primary}`，白字，轻绿色光晕；hover 用 `{colors.primary-hover}` 并略抬升。
- **Ghost:** 透明底 + 发丝边；hover 边/字转主绿，软绿底。
- **Motion:** `transform` / `box-shadow` 约 0.22s，`--landing-ease`；`prefers-reduced-motion` 下取消位移。

### Chips
- **Style:** 表面白、发丝边、软角 `6px`、muted 文字。
- **Active:** 主绿边/字 + `primary-soft` 底。用于筛选事实，不作营销徽章墙。

### Cards / Containers
- **Corner Style:** `8px`（产品框 `12px`）。
- **Background:** surface 白；交替区块用 bg-muted。
- **Shadow Strategy:** 默认无影；hover 用 ambient；首屏控制台用 lift。
- **Border:** `#e1e7e1`。
- **Internal Padding:** 约 `1.1–1.5rem`。
- **Data:** 院校/专业列表以表格壳（`.lp-table-wrap`）为主，不把数据改成装饰卡片网格。

### Inputs / Fields
- **Style:** 浅纸底、发丝边、软角 `6px`（控制台搜索示意）。
- **Focus:** 保持克制描边/主题色；卷面场景另有考试 focus ring（产品面，不上升为营销语言）。

### Navigation
- **Style:** 粘性顶栏、半透明白毛玻璃、底部分隔线；仅一处 `BrandLogo`（landing，约 40px）。
- **Links:** `0.875rem` / 500，muted；hover 转主绿。
- **Mobile:** &lt;900px 隐藏中段锚点链接，保留品牌与操作。

### BrandLogo (signature)
透明底图标 +「升学通」字标；官网 `variant="landing"`。首屏正文不再放第二枚同等 Logo。

### Console preview (signature)
首屏产品框：muted 顶栏 + mono 标题 + 工具条 + **真实院校表**。这是 Academic Utility Console 的具象签名，不是插画拼贴。

## Do's and Don'ts

### Do:
- **Do** 把主绿留给主 CTA、选中筛选与关键操作（Rare Green）。
- **Do** 用表格与筛选呈现招生/真题数据；空态诚实说明。
- **Do** 官网顶栏只放一枚 Logo；容器对齐 `1120px`。
- **Do** 动效使用 `--landing-ease`，并尊重 `prefers-reduced-motion`。
- **Do** 复用 `BrandLogo` 与现有 `/brand/logo-mark.png`，不擅自换标。

### Don't:
- **Don't** 编造 KPI、通过率、名师背书或客户评价条。
- **Don't** 在 hero 正文区再堆第二枚同等 Logo。
- **Don't** 用装饰性卡片网格替代可扫读的数据表。
- **Don't** 把官网黑场 token 泄漏进控制台作业层；控制台仍走 Academic Utility Console 绿系。
- **Don't** 在控制台照搬 Antigravity 全屏粒子 / 自定义光标（干扰作业）。
