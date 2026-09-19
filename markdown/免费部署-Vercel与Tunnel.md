# 免费部署：前端 Vercel + 本机后端 Cloudflare Tunnel

目标：别人打开你的网站，接口打到**你电脑上的 gateway `8082`**。  
费用：Vercel / Cloudflare Tunnel 个人免费档即可；你的电脑要开机并跑着后端。

```text
别人浏览器 → Vercel（前端）→ /api/* 反代 → Cloudflare Tunnel → 你本机 :8082 → 各微服务
```

---

## 一、本机准备

1. Docker 中间件已起（MySQL / Nacos / Redis；社区通知还要 RabbitMQ）。
2. IDEA 用 profile `local` 启动：
   - `gateway-service`（8082）
   - `user-service` / `school-service` / `practice-service` / `agent-service` / `community-service`（按需）
3. 浏览器本机访问 `http://localhost:5173` 能登录、能调接口。

---

## 二、打通本机网关公网入口（Cloudflare Tunnel）

### 1. 安装 cloudflared

- Windows：到 [Cloudflare cloudflared 发布页](https://github.com/cloudflare/cloudflared/releases) 下载，或：

```powershell
winget install --id Cloudflare.cloudflared
```

### 2. 快速隧道（最快试通，URL 每次可能变）

在本机开一个**常驻终端**（关掉就断）：

```powershell
cloudflared tunnel --url http://localhost:8082
```

输出里会有类似：

```text
https://xxxx-xxxx.trycloudflare.com
```

先浏览器打开：

```text
https://xxxx-xxxx.trycloudflare.com/api/school/list?province=广东&page=1&size=1
```

若返回 JSON（哪怕业务码非 200），说明隧道已打到网关。

> 正式演示建议用「命名隧道 + 固定域名」（见文末），避免每次改 Vercel。

---

## 三、部署前端到 Vercel

### 1. 改反代地址

编辑仓库里 [`frontend/vercel.json`](../frontend/vercel.json)，把：

```text
https://REPLACE_WITH_YOUR_TUNNEL.trycloudflare.com
```

换成你上一步拿到的隧道域名（**不要**末尾斜杠）。

### 2. 推送到 GitHub（若 vercel.json 有改动）

```powershell
git add frontend/vercel.json
git commit -m "配置 Vercel 将 /api 反代到本机 Tunnel"
git push
```

### 3. 在 Vercel 导入项目

1. 打开 [vercel.com](https://vercel.com) → 用 GitHub 登录  
2. Import 仓库 `Up-learn`  
3. 设置：
   - **Root Directory**：`frontend`
   - **Framework Preset**：Vite  
   - **Build Command**：`npm run build`  
   - **Output Directory**：`dist`  
4. Deploy  

部署完成后会有 `https://xxx.vercel.app`。

### 4. （可选）绑阿里云域名

1. Vercel 项目 → Domains → 添加 `www.你的域名.com`（或根域）  
2. 阿里云 DNS 按 Vercel 提示加 **CNAME**（或 A 记录）  
3. 等解析生效即可 HTTPS  

---

## 四、验收

1. 本机：`cloudflared` 窗口在跑，gateway 在跑。  
2. 手机流量或另一台电脑打开 Vercel / 你的域名。  
3. 能打开落地页 → 进控制台 → 登录 / 查院校。  

若前端正常、接口全挂：多半是隧道关了、网关没起，或 `vercel.json` 里隧道域名写错 / 没重新部署。

---

## 五、日常怎么用

每次要给别人演示：

1. 开 Docker + 各后端服务  
2. 开 `cloudflared tunnel --url http://localhost:8082`  
3. 若换了新的 `trycloudflare.com` 地址 → 改 `vercel.json` → push → 等 Vercel 自动部署  
4. 分享前端链接  

不用演示时：可关掉 cloudflared 和后端（省电）；别人仍能看到静态页，但接口会失败。

---

## 六、固定域名隧道（可选，少改 vercel.json）

1. `cloudflared tunnel login`（浏览器授权 Cloudflare 账号）  
2. `cloudflared tunnel create up-learn-api`  
3. 配置文件把 `localhost:8082` 绑到该 tunnel  
4. 在 Cloudflare 给隧道绑 `api.你的域名.com`（域名 DNS 需在 Cloudflare，或按官方说明做 CNAME）  
5. `vercel.json` 的 destination 写成稳定的 `https://api.你的域名.com`，以后不用每次改  

详细以 [Cloudflare Tunnel 文档](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) 为准。

---

## 注意

- **不要**把 OSS / DeepSeek / 邮箱密钥推到 Git。  
- 隧道等于把本机网关暴露到公网，仅用于演示；不要在隧道环境用生产库真金。  
- 一点通 SSE 流式：经 Vercel 反代一般可用；若遇缓冲异常，再考虑把 `VITE_API_BASE` 指到隧道并给网关加 CORS（当前默认用反代，通常不必）。
