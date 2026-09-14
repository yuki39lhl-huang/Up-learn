package com.yukimomo.api.client;

import com.yukimomo.api.feign.FeignUserIdConfig;
import com.yukimomo.api.user.vo.UserExamPreferenceVO;
import com.yukimomo.api.user.vo.UserTargetVO;
import com.yukimomo.common.domain.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

/**
 * 调用 user-service：备考设置与目标院校。
 */
@FeignClient(
        name = "user-service",
        contextId = "userFeignClient",
        path = "/api/user",
        configuration = FeignUserIdConfig.class
)
public interface UserFeignClient {

    @GetMapping("/exam-preference")
    Result<UserExamPreferenceVO> getExamPreference();

    @GetMapping("/targets")
    Result<List<UserTargetVO>> listTargets();
}
