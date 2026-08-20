package com.yukimomo.tools;

import com.yukimomo.pojo.LangChain4j;
import com.yukimomo.service.impl.LangChain4jServiceImpl;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class LangChainTool {

    @Autowired
    private LangChain4jServiceImpl langChain4jService;

    //工具方法:添加预约信息
    @Tool("预约志愿填报服务")
    public void addLangChain4j(
            @P("考生姓名")String name,
            @P("考生性别")String gender,
            @P("考生手机号")String phone,
            @P("预约沟通时间,格式为:yyyy-MM-dd'T'HH:mm")String communicationTime,
            @P("考生所在城市")String province,
            @P("考生所估分数")Integer estimatedScore
    ){
        LangChain4j langChain4j = new LangChain4j(null, name, gender, phone, LocalDateTime.parse(communicationTime), province, estimatedScore);
        langChain4jService.insert(langChain4j);
    }

    //工具方法:查询预约信息
    public LangChain4j findLangChain4j(@P("考生手机号")String phone){
        return langChain4jService.getByPhone(phone);
    }
}
