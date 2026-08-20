package com.yukimomo;

import com.yukimomo.pojo.LangChain4j;
import com.yukimomo.service.impl.LangChain4jServiceImpl;
import dev.langchain4j.model.openai.OpenAiChatModel;
import jakarta.annotation.Resource;
import lombok.RequiredArgsConstructor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;

@SpringBootTest
class AgentServiceApplicationTests {

    @Autowired
    private LangChain4jServiceImpl langChain4jService;


    @Test
    void contextLoads() {
        IO.println("Hi! Transform");
    }

    static void main() {
        //构建 OpenAiChatModel对象
        OpenAiChatModel llm = OpenAiChatModel.builder()
                .baseUrl("https://api.deepseek.com")
                //直接从系统环境变量获取
                .apiKey(System.getenv("ANTHROPIC_AUTH_TOKEN"))
                .modelName("deepseek-v4-flash")
                .logRequests(true)
                .logResponses(true)
                .build();

        //调用chat方法,交互
        String handsome = llm.chat("柚希帅不帅");
        IO.println(handsome);
    }

    //添加
    @Test
    void testInsert(){
        LangChain4j langChain4j = new LangChain4j(null, "yuki", "男", "18307675254", LocalDateTime.now(), "广东", 440);
        langChain4jService.insert(langChain4j);
    }

    //查询
    @Test
    void testFindByPhone(){
        String phone = "18307675254";
        LangChain4j byPhone = langChain4jService.getByPhone(phone);
        IO.println(byPhone);
    }
}
