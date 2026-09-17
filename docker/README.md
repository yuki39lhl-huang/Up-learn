# up-learn Docker 中间件

本目录存放 **可版本化** 的 Compose；实机数据目录在 WSL：`/root/up-learn/`（需 `sudo`）。

| 阶段 | 现状 | Compose |
|------|------|---------|
| 一期（常驻） | `ul-mysql` / `ul-nacos` / Redis 主从哨兵 | [docker.md](../markdown/docker.md) |
| 二期（按需） | RabbitMQ / ES / Kibana / Sentinel / Seata | [`compose.phase2.yml`](./compose.phase2.yml) |
| 不做 | 社区 | — |

> **内存提醒**：二期不要和一期长期全开，Docker 易卡死。ES / Sentinel / Kibana / Seata / RabbitMQ **用到再起、用完就停**。

## 二期按需启动

```bash
# 只创建、不启动（省内存，避免 Docker 爆）
docker compose -f /root/up-learn/phase2/compose.yml create ul-rabbitmq
docker compose -f /root/up-learn/phase2/compose.yml create ul-sentinel
docker compose -f /root/up-learn/phase2/compose.yml create ul-seata
docker compose -f /root/up-learn/phase2/compose.yml create ul-elasticsearch
docker compose -f /root/up-learn/phase2/compose.yml --profile kibana create ul-kibana

# 用到再单个启动（一次只开一个）
docker start ul-rabbitmq
docker start ul-sentinel
docker start ul-elasticsearch
# Kibana 依赖 ES 已 healthy
docker start ul-kibana
docker start ul-seata

# 用完关掉
docker stop ul-kibana ul-elasticsearch ul-seata ul-sentinel ul-rabbitmq
```

当前 Docker 内存约 **3.7GB** 时，**不要**同时起 ES+Kibana+其它。建议 Settings 里内存 ≥ **6GB** 再玩搜索栈。

**不要** `docker compose up -d` 无参数全开。

## 库表恢复（MySQL 数据目录空了时）

本机 MySQL 监听 `localhost:3308` 时，可跑：

```powershell
powershell -ExecutionPolicy Bypass -File docker/restore-dbs.ps1
```

会建 `nacos` + `up_learn` 并导入 `sql/phase1`。然后 `docker start ul-nacos`。

## 宿主机端口与联调账号（二期 · 仅启动时占用）

| 服务 | 端口 | 账号 / 说明 |
|------|------|-------------|
| RabbitMQ | `5672`（AMQP）/ `15672`（管理台） | `uplearn` / `1234`；user-service 队列 `ul.login.code.dispatch` |
| Elasticsearch | `9200` | 无账号（本机开发）；索引 `ul_school`；school-service `ul.school.es-enabled` |
| Kibana | `5601` | 需 `--profile kibana`；**联调可不启** |
| Sentinel Dashboard | `8718` | 控制台默认账号看镜像说明；应用侧 `spring.cloud.sentinel.transport.dashboard=localhost:8718`；网关资源 `ul-api` |
| Seata | `8091` / `7091` | **容器就绪，本轮业务不接**；联调可不启 |

### 业务接入要点（2026-09-17）

1. **Gateway + Sentinel**：限流拒绝返回统一 JSON（HTTP 429 / `TOO_MANY_REQUESTS`）。
2. **user-service + RabbitMQ**：验证码仍同步写 Redis；投递失败自动降级同步打日志（`ul.login.mq-enabled`）。
3. **school-service + ES**：`kw` 优先 ES，停 ES 后 MySQL LIKE 仍可用。
4. **Seata**：不要在业务代码引入 Seata API；需要时再单开容器。

联调最小集：`ul-rabbitmq` + `ul-sentinel` + `ul-elasticsearch`（不必 Kibana/Seata）。

详操作见 [`markdown/docker.md`](../markdown/docker.md)。
