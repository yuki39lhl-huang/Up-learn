# up-learn 本地中间件（WSL2 + Docker Desktop）

> 数据与 Compose 放在 **WSL root**：`/root/up-learn/`，**不在** IDEA 工程目录。  
> 统一网桥：**`ul-net`**；容器名前缀：**`ul-`**。  
> **约定：每新增一个中间件，都在本文件追加一节（目录、端口、启动命令、同网段说明）。**

---

## 0. 公共准备

### 0.1 网桥（所有要互访的容器共用）

```bash
docker network create ul-net
# 已存在会报错，可忽略
docker network ls | grep ul-net
```

**要进 `ul-net`：** MySQL、Nacos、Redis 主从哨兵、以后容器化的微服务（互相用容器名访问）。  
**不必进：** Windows 上 IDEA / 浏览器 / Vite（走 `localhost:映射端口` 即可）。

### 0.2 根目录结构（当前）

```text
/root/up-learn/
  mysql/
    data/          # 数据
    conf/          # 自定义配置（可选）
    init/          # 首次初始化 SQL（挂到 docker-entrypoint-initdb.d）
  nacos/
    logs/
    data/
  redis/
    compose.yml    # Redis 成组启动
    conf/
      redis.conf
      sentinel.conf
    master/ slave1/ slave2/ slave3/
```

---

## 1. MySQL

| 项 | 值 |
|---|---|
| 容器名 | `ul-mysql` |
| 镜像 | `mysql:latest`（开发可接受；基线正式优先 8.4 / 开发曾写 9.7.x） |
| 网段 | `ul-net` |
| 宿主机端口 | **3308** → 容器 3306（避开本机已有 3306） |
| root 密码 | `1234` |
| 时区 | `Asia/Shanghai` |
| 数据卷 | `/root/up-learn/mysql/data` → `/var/lib/mysql` |
| 配置卷 | `/root/up-learn/mysql/conf` → `/etc/mysql/conf.d` |
| 初始化 | `/root/up-learn/mysql/init` → `/docker-entrypoint-initdb.d`（仅 data 为空时执行） |

### 建目录

```bash
mkdir -p /root/up-learn/mysql/{data,conf,init}
# 可将工程内 sql/phase1/*.sql 拷到 init/，首次空库自动建表
```

### 启动

```bash
docker run -d \
  --name ul-mysql \
  --network ul-net \
  -p 3308:3306 \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e TZ=Asia/Shanghai \
  -v /root/up-learn/mysql/data:/var/lib/mysql \
  -v /root/up-learn/mysql/conf:/etc/mysql/conf.d \
  -v /root/up-learn/mysql/init:/docker-entrypoint-initdb.d \
  mysql:latest
```

### 访问

- 宿主机 / IDEA：`localhost:3308`，用户 `root` / `1234`
- 同网段容器：`ul-mysql:3306`

```bash
docker exec -it ul-mysql mysql -uroot -p1234 -e "SHOW DATABASES;"
```

---

## 2. Nacos 3.1.1（standalone + MySQL 持久化）

| 项 | 值 |
|---|---|
| 容器名 | `ul-nacos` |
| 镜像 | `nacos/nacos-server:v3.1.1` |
| 网段 | `ul-net`（与 `ul-mysql` 同网，主机名用 **`ul-mysql`**） |
| 模式 | `MODE=standalone` + **外挂 MySQL**（库名 `nacos`） |
| API 端口 | 宿主机 **8858** → 8848 |
| gRPC | 宿主机 **9858** → 9848 |
| 控制台 | 宿主机 **8088** → 8080（路径 `/`） |
| 环境文件 | `/root/up-learn/nacos/custom.env` |
| 数据卷 | `logs`、`data`；**不要**挂空 `conf` |

> 从内嵌 Derby 切换到 MySQL **不会自动迁移**原有配置/服务列表，相当于空库重来。须先起好 `ul-mysql`，再起 Nacos。

### 建目录

```bash
mkdir -p /root/up-learn/nacos/{logs,data}
```

### 2.1 在 MySQL 建库并导入表结构

```bash
# 1) 建库
docker exec -it ul-mysql mysql -uroot -p1234 -e "CREATE DATABASE IF NOT EXISTS nacos DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2) 下载与 3.x 对齐的建表脚本（在 WSL 执行；优先发行包路径）
curl -fsSL -o /root/up-learn/nacos/mysql-schema.sql \
  https://raw.githubusercontent.com/alibaba/nacos/3.1.1/distribution/conf/mysql-schema.sql

# 若 3.1.1 标签 404，改用：
# curl -fsSL -o /root/up-learn/nacos/mysql-schema.sql \
#   https://raw.githubusercontent.com/alibaba/nacos/master/distribution/conf/mysql-schema.sql

# 3) 导入（进 nacos 库执行）
docker exec -i ul-mysql mysql -uroot -p1234 nacos < /root/up-learn/nacos/mysql-schema.sql

# 4) 确认有表
docker exec -it ul-mysql mysql -uroot -p1234 -e "USE nacos; SHOW TABLES;"
```

### 2.2 写 custom.env

```bash
cat >/root/up-learn/nacos/custom.env <<'EOF'
MODE=standalone
PREFER_HOST_MODE=hostname
SPRING_DATASOURCE_PLATFORM=mysql
MYSQL_SERVICE_HOST=ul-mysql
MYSQL_SERVICE_PORT=3306
MYSQL_SERVICE_DB_NAME=nacos
MYSQL_SERVICE_USER=root
MYSQL_SERVICE_PASSWORD=1234
MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
NACOS_AUTH_ENABLE=false
NACOS_AUTH_TOKEN=U2VjcmV0S2V5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU=
NACOS_AUTH_IDENTITY_KEY=nacos
NACOS_AUTH_IDENTITY_VALUE=nacos
TZ=Asia/Shanghai
JVM_XMS=256m
JVM_XMX=512m
EOF
```

注意：`MYSQL_SERVICE_HOST` / `PORT` 用的是 **容器网**（`ul-mysql:3306`），不是宿主机的 `3308`。

### 2.3 重建 Nacos 容器

```bash
docker rm -f ul-nacos

docker run -d \
  --name ul-nacos \
  --network ul-net \
  -p 8858:8848 \
  -p 9858:9848 \
  -p 8088:8080 \
  --env-file /root/up-learn/nacos/custom.env \
  -v /root/up-learn/nacos/logs:/home/nacos/logs \
  -v /root/up-learn/nacos/data:/home/nacos/data \
  nacos/nacos-server:v3.1.1

docker logs -f ul-nacos
```

日志里应出现连上 MySQL / datasource，不应再报 Derby。控制台：http://localhost:8088/

### 说明（踩过的坑）

1. Nacos 3.1.1 即使关掉鉴权，仍须带 `NACOS_AUTH_TOKEN` / `IDENTITY_*`。  
2. 浏览器用 **8088/**，不要用 `8858/nacos`。  
3. 外挂 MySQL 时 **必须先有库表**；只建空库不够。  
4. 客户端注册：宿主机 `localhost:8858`；容器内 `ul-nacos:8848`。

### 访问

- 控制台：http://localhost:8088/
- 注册/配置（宿主机）：`localhost:8858`
- 同网段容器：`ul-nacos:8848`

---

## 3. Redis 8.10（1 主 3 从 + 3 哨兵）

| 项 | 值 |
|---|---|
| 编排 | `/root/up-learn/redis/compose.yml`（Compose 项目名 `ul-redis`，Desktop 成组显示） |
| 镜像 | `redis:8.10` |
| 网段 | `ul-net`（`external: true`） |
| 主库宿主机端口 | **6380** → 6379（避开原有 6379 单例） |
| 哨兵宿主机端口 | **26380 / 26381 / 26382** → 26379 |
| 从库 | 不映射宿主机端口，仅 `ul-net` 内访问 |
| master 名（哨兵） | `mymaster` |

### 建目录与配置

```bash
mkdir -p /root/up-learn/redis/{master,slave1,slave2,slave3,conf}

cat >/root/up-learn/redis/conf/redis.conf <<'EOF'
bind 0.0.0.0
protected-mode no
port 6379
dir /data
appendonly yes
daemonize no
EOF

cat >/root/up-learn/redis/conf/sentinel.conf <<'EOF'
port 26379
bind 0.0.0.0
protected-mode no
daemonize no
dir /tmp
sentinel resolve-hostnames yes
sentinel announce-hostnames yes
sentinel monitor mymaster ul-redis-master 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 10000
EOF
```

### 哨兵注意

哨兵启动会**改写**配置文件，不能把 `sentinel.conf` 只读挂进去直接跑。Compose 里用：

`cp … /tmp/sentinel.conf && redis-sentinel /tmp/sentinel.conf`

### compose.yml（路径：`/root/up-learn/redis/compose.yml`）

```yaml
name: ul-redis

networks:
  ul-net:
    external: true

services:
  master:
    image: redis:8.10
    container_name: ul-redis-master
    restart: unless-stopped
    ports:
      - "6380:6379"
    volumes:
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf:ro
      - ./master:/data
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    networks: [ul-net]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 20

  slave-1:
    image: redis:8.10
    container_name: ul-redis-slave-1
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    volumes:
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf:ro
      - ./slave1:/data
    command: ["redis-server", "/usr/local/etc/redis/redis.conf", "--replicaof", "ul-redis-master", "6379"]
    networks: [ul-net]

  slave-2:
    image: redis:8.10
    container_name: ul-redis-slave-2
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    volumes:
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf:ro
      - ./slave2:/data
    command: ["redis-server", "/usr/local/etc/redis/redis.conf", "--replicaof", "ul-redis-master", "6379"]
    networks: [ul-net]

  slave-3:
    image: redis:8.10
    container_name: ul-redis-slave-3
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    volumes:
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf:ro
      - ./slave3:/data
    command: ["redis-server", "/usr/local/etc/redis/redis.conf", "--replicaof", "ul-redis-master", "6379"]
    networks: [ul-net]

  sentinel-1:
    image: redis:8.10
    container_name: ul-redis-sentinel-1
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    ports:
      - "26380:26379"
    volumes:
      - ./conf/sentinel.conf:/etc/redis/sentinel.conf:ro
    command: ["sh", "-c", "cp /etc/redis/sentinel.conf /tmp/sentinel.conf && redis-sentinel /tmp/sentinel.conf"]
    networks: [ul-net]

  sentinel-2:
    image: redis:8.10
    container_name: ul-redis-sentinel-2
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    ports:
      - "26381:26379"
    volumes:
      - ./conf/sentinel.conf:/etc/redis/sentinel.conf:ro
    command: ["sh", "-c", "cp /etc/redis/sentinel.conf /tmp/sentinel.conf && redis-sentinel /tmp/sentinel.conf"]
    networks: [ul-net]

  sentinel-3:
    image: redis:8.10
    container_name: ul-redis-sentinel-3
    restart: unless-stopped
    depends_on:
      master:
        condition: service_healthy
    ports:
      - "26382:26379"
    volumes:
      - ./conf/sentinel.conf:/etc/redis/sentinel.conf:ro
    command: ["sh", "-c", "cp /etc/redis/sentinel.conf /tmp/sentinel.conf && redis-sentinel /tmp/sentinel.conf"]
    networks: [ul-net]
```

写入示例：

```bash
# 将上文 YAML 保存为 /root/up-learn/redis/compose.yml 后：
cd /root/up-learn/redis
docker compose -f compose.yml up -d
```

### 启动 / 停止

```bash
cd /root/up-learn/redis
docker compose -f compose.yml up -d
docker compose -f compose.yml ps
docker compose -f compose.yml stop
docker compose -f compose.yml down   # 删容器，保留 ./master 等数据目录
```

容器名：`ul-redis-master`、`ul-redis-slave-1..3`、`ul-redis-sentinel-1..3`。

### 自检（健康标准）

期望：主库 `PONG` + `connected_slaves:3`；三从 `master_link_status:up`；哨兵能列出主且能看到另外 2 个 sentinel（刚启动几秒内可能暂时发现不全）。

```bash
echo '=== 容器状态 ==='
docker compose -f /root/up-learn/redis/compose.yml ps

echo '=== 主库 PING / 角色 ==='
docker exec ul-redis-master redis-cli ping
docker exec ul-redis-master redis-cli INFO replication | egrep 'role|connected_slaves|slave[0-9]'

echo '=== 从库是否认主 ==='
docker exec ul-redis-slave-1 redis-cli INFO replication | egrep 'role|master_link_status|master_host'
docker exec ul-redis-slave-2 redis-cli INFO replication | egrep 'role|master_link_status|master_host'
docker exec ul-redis-slave-3 redis-cli INFO replication | egrep 'role|master_link_status|master_host'

echo '=== 哨兵互相发现 ==='
docker exec ul-redis-sentinel-1 redis-cli -p 26379 SENTINEL masters | egrep 'name|ip|flags|num-slaves|num-other-sentinels'
docker exec ul-redis-sentinel-1 redis-cli -p 26379 SENTINEL sentinels mymaster

echo '=== 宿主机端口 ==='
docker exec ul-redis-master redis-cli -h host.docker.internal -p 6380 ping 2>/dev/null || true
# 在 Windows / 本机也可: redis-cli -p 6380 ping
```

### 访问

- 宿主机 / IDEA 直连主库：`localhost:6380`
- 同网段容器：`ul-redis-master:6379`
- 哨兵（宿主机）：`localhost:26380`～`26382`；master 名 `mymaster`

---

## 4. 端口速查（宿主机）

| 服务 | 宿主机 | 说明 |
|---|---|---|
| 旧 MySQL / 旧 Nacos / 旧 Redis | 3306 / 8848 / 6379 | 保留不动 |
| ul-mysql | **3308** | |
| ul-nacos API | **8858** | |
| ul-nacos gRPC | **9858** | |
| ul-nacos 控制台 | **8088** | 浏览器用这个 |
| ul-redis 主 | **6380** | |
| ul-redis 哨兵 | **26380–26382** | |

---

## 5. 后续补充模板（每加一个中间件复制一节）

```markdown
## N. <组件名> <版本>

| 项 | 值 |
|---|---|
| 容器名 | `ul-xxx` |
| 镜像 | |
| 网段 | `ul-net`（是/否） |
| 宿主机端口 | |
| 数据目录 | `/root/up-learn/...` |

### 建目录
### 启动命令 / Compose
### 访问与自检
### 备注（踩坑）
```

**已规划、尚未落容器（见基线）：** Sentinel Dashboard、Seata、RabbitMQ、Elasticsearch/Kibana 等 → 创建后按上表追加到本文件。

---

## 6. 与基线关系

版本与选型以 [`技术栈基线备忘.md`](./技术栈基线备忘.md) §四为准；本文只记录 **本机实际怎么建、怎么连**。若端口或镜像与基线有出入，以本文「当前实机」为准，并回写基线备注。
