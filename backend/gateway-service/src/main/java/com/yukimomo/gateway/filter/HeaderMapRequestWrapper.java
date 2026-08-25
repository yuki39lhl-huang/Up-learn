package com.yukimomo.gateway.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;

import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 为下游转发追加 Header（如网关鉴权后的 user-id）。
 */
public class HeaderMapRequestWrapper extends HttpServletRequestWrapper {
    //存储网关追加的请求头
    private final Map<String, String> customHeaders = new HashMap<>();

    //构造函数,传入原始请求
    public HeaderMapRequestWrapper(HttpServletRequest request) {
        super(request);
    }

    //添加请求头
    public void addHeader(String name, String value) {
        customHeaders.put(name, value);
    }

    @Override
    public String getHeader(String name) {
        String value = customHeaders.get(name);//从存储的请求头中获取值
        if (value != null) {
            return value;
        }
        return super.getHeader(name);//如果请求头不存在,则调用原始请求的getHeader方法
    }

    //合并「原请求 + 自定义」的所有 Header 名字
    @Override
    public Enumeration<String> getHeaderNames() {
        Set<String> names = new HashSet<>(customHeaders.keySet());
        Enumeration<String> original = super.getHeaderNames();
        while (original.hasMoreElements()) {
            names.add(original.nextElement());
        }
        return Collections.enumeration(names);
    }

    //按名字取 Header 所有值；自定义头走 Map，其它走原请求
    @Override
    public Enumeration<String> getHeaders(String name) {
        if (customHeaders.containsKey(name)) {
            return Collections.enumeration(Collections.singletonList(customHeaders.get(name)));
        }
        return super.getHeaders(name);
    }
}
