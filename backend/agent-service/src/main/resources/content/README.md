# Agent 知识库（历年答案）

本目录由 `shijuan/**` 下的答案 / 解析 Markdown **复制**而来，供一点通 RAG 检索。

- 评分接口 `POST /api/agent/score` **不依赖**本目录：按请求里的题干、作答、采分点单次打分。
- 向量存现有 Redis 8（`ul.redis`，索引名形如 `ul-agent-rag-{维度}`）。
- 更新答案后：重新复制对应 md，并保持 `ul.agent.rag.ingest-on-startup=true` 重启入库（启动时会清空本索引后重写）。
- embedding：优先环境变量 `DASHSCOPE_API_KEY`（通义）；未配置则用本地 AllMiniLm（中文召回较弱）。

来源根目录：仓库 `shijuan/`。
