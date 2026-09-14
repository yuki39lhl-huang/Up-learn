package com.yukimomo.vo;

import lombok.Data;

/**
 * 一点通能力状态（供前端状态条展示）。
 */
@Data
public class AgentStatusVO {

    /** 向量检索是否启用 */
    private boolean ragEnabled;
    /** 启动时是否会入库（启用且配置了 ingest） */
    private boolean ragIngestOnStartup;
    /** embedding 后端：dashscope / local / off */
    private String ragEmbedding;
}
