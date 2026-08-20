package com.yukimomo.service;

import dev.langchain4j.service.MemoryId;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import dev.langchain4j.service.spring.AiService;
import dev.langchain4j.service.spring.AiServiceWiringMode;
import reactor.core.publisher.Flux;

@AiService(
        wiringMode = AiServiceWiringMode.EXPLICIT,//手动装配,自动有风险
        chatModel = "openAiChatModel",//指定模型
        streamingChatModel = "openAiStreamingChatModel",//流式模型
        //chatMemory = "chatMemory"//配置会话记忆对象
        chatMemoryProvider = "chatMemoryProvider",//配置会话记忆存储的对象
        contentRetriever = "contentRetriever",//配置向量数据库检索对象
        tools = "langChainTool"//工具方法
)
public interface ChatService {
    //聊天方法
    String  chat(String message);

    //@SystemMessage("你是柚希的助手梦梦,人美心善又多金")
    @SystemMessage(fromResource = "system.txt")
    //@UserMessage("你是柚希的助手梦梦,人美心善又多金{{it}}")
    //@UserMessage("你是柚希的助手梦梦,人美心善又多金{{msg}}")
    //Flux<String> fluChat(@V("msg") String message);
    Flux<String> fluChat(@MemoryId String memoryId,@UserMessage String message);
}
