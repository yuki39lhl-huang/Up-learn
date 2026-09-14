package com.yukimomo.api.client;

import com.yukimomo.api.feign.FeignUserIdConfig;
import com.yukimomo.api.practice.vo.PaperListItemVO;
import com.yukimomo.common.domain.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 调用 practice-service：历年真题列表（不含整卷题目）。
 */
@FeignClient(
        name = "practice-service",
        contextId = "practiceFeignClient",
        path = "/api/practice/papers",
        configuration = FeignUserIdConfig.class
)
public interface PracticeFeignClient {

    @GetMapping
    Result<List<PaperListItemVO>> listPapers(
            @RequestParam String province,
            @RequestParam String subject);
}
