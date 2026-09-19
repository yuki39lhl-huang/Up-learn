# Nacos 配置中心（外置 yml）

本目录为 **可版本化的配置源**；运行时由各服务 `spring.config.import: optional:nacos:...` 拉取。

| DataId | 用途 | 谁引入 |
|--------|------|--------|
| `ul-common.yaml` | JWT、Redis/RabbitMQ 占位、日志 | 全部服务 |
| `ul-datasource.yaml` | MySQL + MyBatis-Plus | user / school / practice / community |
| `{service}.yaml` | 各服务业务项 | 对应服务 |

## 发布到本机 Nacos

前提：`ul-nacos` 已启动（宿主机 `8858`，控制台 `8088`，账号 `nacos`/`nacos`）。

```powershell
powershell -ExecutionPolicy Bypass -File backend/nacos-config/publish.ps1
```

改完本目录 yaml 后重新执行 publish，再重启服务（或依赖 `refresh-enabled` 热更新，路由类建议重启）。

## 仍留在仓库本地的文件

| 文件 | 原因 |
|------|------|
| `application.yml` | 端口、服务名、Nacos 地址、`config.import` 清单 |
| `application-dev.yml` | Docker 内网主机名（`ul-mysql` 等） |
| `application-local.yml` | 本机端口 + **密钥**（OSS/SMTP），**勿提交真实密钥** |

## 注意

- **不要**把 OSS AccessKey、邮箱授权码、生产 JWT 写进本目录或推到 Nacos 公开空间。
- `optional:nacos`：Nacos 短暂不可达时仍能启动，但缺配置会导致业务失败；首次务必先 publish。
- gateway / agent **不要**引入 `ul-datasource.yaml`（无库或已排除 DataSource）。
