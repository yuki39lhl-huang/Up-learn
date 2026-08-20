package com.yukimomo.controller;

import com.yukimomo.service.ChatService;
import dev.langchain4j.model.openai.OpenAiChatModel;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequiredArgsConstructor
public class ChatController {
    /*private final OpenAiChatModel llm;

    @RequestMapping("/chat")
    public String chat(String message){
        return llm.chat(message);
    }*/
    private final ChatService chatService;

    @RequestMapping("/chat")
    String chat(String message){
        return chatService.chat(message);
    }

    @RequestMapping(value = "/fluChat", produces = "text/html;charset=utf-8")
    Flux<String> fluChat(String memoryId,String message){
        return chatService.fluChat(memoryId,message);
    }
}
