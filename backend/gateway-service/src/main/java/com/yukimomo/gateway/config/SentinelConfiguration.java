package com.yukimomo.gateway.config;

import cn.hutool.json.JSONUtil;
import com.alibaba.csp.sentinel.adapter.spring.webmvc_v6x.callback.BlockExceptionHandler;
import com.alibaba.csp.sentinel.adapter.web.common.UrlCleaner;
import com.alibaba.csp.sentinel.slots.block.RuleConstant;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRule;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRuleManager;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.ErrorCode;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Sentinel：Dashboard 对接 + {@code /api/**} 合并为资源 {@code ul-api} 的基础 QPS 限流。
 */
@Configuration
public class SentinelConfiguration {

    /** 网关统一 API 资源名（由 UrlCleaner 将 /api/** 归一） */
    public static final String API_RESOURCE = "ul-api";

    /** 本机开发默认 QPS；可在 Dashboard 热更新覆盖 */
    private static final double DEFAULT_API_QPS = 200D;

    @PostConstruct
    public void initFlowRules() {
        FlowRule rule = new FlowRule(API_RESOURCE);
        rule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        rule.setCount(DEFAULT_API_QPS);
        FlowRuleManager.loadRules(List.of(rule));
    }

    @Bean
    public UrlCleaner ulApiUrlCleaner() {
        return originUrl -> {
            if (!StringUtils.hasText(originUrl)) {
                return originUrl;
            }
            String path = originUrl;
            int q = path.indexOf('?');
            if (q >= 0) {
                path = path.substring(0, q);
            }
            if (path.startsWith("/api/")) {
                return API_RESOURCE;
            }
            return path;
        };
    }

    @Bean
    public BlockExceptionHandler ulBlockExceptionHandler() {
        return (request, response, resourceName, e) -> {
            response.setStatus(429);
            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.getWriter().write(JSONUtil.toJsonStr(Result.error(ErrorCode.TOO_MANY_REQUESTS)));
        };
    }
}
