package com.yukimomo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.mapper.LangChain4jMapper;
import com.yukimomo.pojo.LangChain4j;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LangChain4jServiceImpl {

    private final LangChain4jMapper mapper;

    //添加预约信息
    public void insert(LangChain4j langChain4j){
        mapper.insert(langChain4j);
    }

    //查询预约信息-根据手机号
    public LangChain4j getByPhone(String phone){
        return mapper.selectOne(
                new LambdaQueryWrapper<LangChain4j>()
                        .eq(LangChain4j::getPhone,phone)
        );
    }
}
