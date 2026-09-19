# 升学通 · up-learn

面向专升本考生的招生查询与备考控制台：**查招生 · 对真题 · 刷题巩固 · 社区互助 · AI 一点通**。

> 工程名 `up-learn`，产品对外名 **升学通**。

---

## 功能概览

| 模块 | 说明 |
|------|------|
| 官网落地页 | 品牌 Hero、招生/真题/刷题预览入口 |
| 控制台 | Gmail 式侧栏工作台（主题 / 壁纸 / 中英） |
| 院校查询 | 省份筛选、目标院校、专业开设 |
| 考纲查询 | 省 + 年 + 科目考纲正文 |
| 随机刷题 / 每日一练 | 间隔复习、错题本、备忘录 |
| 历年真题 | 卷面作答、客观机判、主观 AI 评分 |
| 社区 | Feed、发帖配图、二级评论、关注、B 站式通知 |
| 一点通 | DeepSeek 对话 + RAG（服务端持有 API Key） |

---

## 技术栈

**后端**：Java 25 · Spring Boot 4 · Spring Cloud / SCA · Gateway · Nacos · MyBatis-Plus · Redis · RabbitMQ · Elasticsearch（可选）· 阿里云 OSS  

**前端**：Vue 3 · Vite · TypeScript · Pinia · Vue Router · Element Plus · Axios  

**中间件（本机 Docker）**：MySQL · Nacos · Redis 哨兵 · RabbitMQ · ES（按需）

详细版本与接口约定见 [`markdown/技术栈基线备忘.md`](markdown/技术栈基线备忘.md)，进度见 [`markdown/分期开发计划.md`](markdown/分期开发计划.md)。

---

## 仓库结构

```text
up-learn/
├── backend/                 # 微服务
│   ├── gateway-service/     # 8082 网关 + JWT
│   ├── user-service/        # 8081 登录 / 资料 / OSS
│   ├── school-service/      # 8083 院校 / 考纲
│   ├── practice-service/    # 8084 刷题 / 真题
│   ├── agent-service/       # 8085 AI
│   ├── community-service/   # 8086 社区
│   ├── api-service/         # Feign DTO（jar）
│   ├── common-service/      # 公共工具（jar）
│   └── nacos-config/        # 可版本化的 Nacos 配置源 + publish.ps1
├── frontend/                # Vue 控制台与官网
├── docker/                  # Compose / 中间件说明
├── sql/phase1/              # 库表与种子
└── markdown/                # 开发文档
```

---

## 本地快速开始

### 1. 中间件

见 [`docker/README.md`](docker/README.md)、[`markdown/docker.md`](markdown/docker.md)。  
一期常驻：MySQL（宿主机 `3308`）、Nacos（`8858` / 控制台 `8088`）、Redis（`6380`）。  
社区通知 / 异步发码需要 RabbitMQ；院校与社区搜索可开 ES（也可 MySQL 降级）。

### 2. Nacos 配置

首次或改配置后发布：

```powershell
powershell -ExecutionPolicy Bypass -File backend/nacos-config/publish.ps1
```

说明：[`backend/nacos-config/README.md`](backend/nacos-config/README.md)。  
**密钥**（OSS、SMTP、DeepSeek Key）只写本机 `application-local.yml` 或 Nacos 控制台，**不要提交 Git**。

### 3. 后端

IDEA 中各服务使用 profile **`local`** 启动（顺序建议：gateway → user → school → practice → agent → community）。  
父工程：`backend/pom.xml`。

### 4. 前端

```bash
cd frontend
npm install
npm run dev
```

默认 http://localhost:5173 ，API 代理到 gateway `8082`。

---

## 环境变量 / 本机密钥（勿入库）

| 项 | 用途 |
|----|------|
| `application-local.yml` 中 `ul.oss.*` | 头像 / 社区配图 |
| `spring.mail.*` | QQ 验证码邮件 |
| `ul.agent.deepseek-api-key` | 一点通 / 主观评分（服务端持有） |
| `DASHSCOPE_API_KEY`（可选） | RAG embedding；未配置则本地 AllMiniLm |

---

## 文档索引

| 文档 | 内容 |
|------|------|
| [分期开发计划](markdown/分期开发计划.md) | 一期 / 二期任务与完成状态 |
| [技术栈基线备忘](markdown/技术栈基线备忘.md) | 版本与接口基准 |
| [配置文件](markdown/配置文件.md) | profile / Nacos / OSS / 邮件 |
| [docker](markdown/docker.md) | 本机 Docker 端口与编排 |
| [主观题评分与 Agent 边界](markdown/主观题评分与Agent边界.md) | AI 评分边界 |

---

## 许可与说明

个人 / 学习项目。Issues 与 PR 欢迎围绕专升本备考场景讨论。
