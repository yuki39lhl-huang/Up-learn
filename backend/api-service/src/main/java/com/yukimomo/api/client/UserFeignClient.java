package com.yukimomo.api.client;

import com.yukimomo.api.feign.FeignUserIdConfig;
import com.yukimomo.api.user.vo.UserBriefVO;
import com.yukimomo.api.user.vo.UserExamPreferenceVO;
import com.yukimomo.api.user.vo.UserPublicProfileVO;
import com.yukimomo.api.user.vo.UserTargetVO;
import com.yukimomo.common.domain.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 调用 user-service：备考设置、目标院校、用户简要资料。
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

    @GetMapping("/briefs")
    Result<List<UserBriefVO>> listBriefs(@RequestParam("ids") List<Long> ids);

    @GetMapping("/public/{userId}")
    Result<UserPublicProfileVO> getPublicProfile(@PathVariable("userId") Long userId);
}
