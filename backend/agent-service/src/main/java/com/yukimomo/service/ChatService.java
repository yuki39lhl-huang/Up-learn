package com.yukimomo.service;

import dev.langchain4j.service.MemoryId;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import dev.langchain4j.service.spring.AiService;
import dev.langchain4j.service.spring.AiServiceWiringMode;
import reactor.core.publisher.Flux;

/**
 * 一点通多轮答疑（记忆 + 备考档案 + Tool：院校/考纲/真题/知识库）。
 * 主观题打分请用 {@link ScoreService}。
 */
@AiService(
        wiringMode = AiServiceWiringMode.EXPLICIT,
        chatModel = "openAiChatModel",
        streamingChatModel = "openAiStreamingChatModel",
        chatMemoryProvider = "chatMemoryProvider",
        contentRetriever = "contentRetriever",
        tools = {"upLearnQueryTools", "knowledgeSearchTools"}
)
public interface ChatService {

    @SystemMessage(fromResource = "system.txt")
    Flux<String> fluChat(
            @MemoryId String memoryId,
            @V("profileContext") String profileContext,
            @UserMessage String message);
}
