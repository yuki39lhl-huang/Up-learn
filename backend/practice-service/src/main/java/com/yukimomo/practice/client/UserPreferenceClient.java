package com.yukimomo.practice.client;

import com.yukimomo.api.client.UserFeignClient;
import com.yukimomo.api.user.vo.UserExamPreferenceVO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * practice → user 备考设置（Feign）。
 * <p>
 * 取代早期直读 {@code user_exam_preference} 表的做法，practice-service 不再依赖 user 域表结构。
 * 用户 ID 由 {@code FeignUserIdConfig} 透传当前请求头。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserPreferenceClient {

    private final UserFeignClient userFeignClient;

    /**
     * 当前登录用户的备考设置；未设置时返回 {@code null}。
     *
     * @throws BizException user-service 不可用或返回业务失败
     */
    public UserExamPreferenceVO getCurrentPreference() {
        try {
            Result<UserExamPreferenceVO> result = userFeignClient.getExamPreference();
            if (result == null) {
                throw new BizException(ErrorCode.USER_PREFERENCE_UNAVAILABLE, "空响应");
            }
            if (result.getCode() != ErrorCode.SUCCESS.getCode()) {
                log.warn("user exam-preference business fail: {}", result.getMsg());
                throw new BizException(ErrorCode.USER_PREFERENCE_UNAVAILABLE, result.getMsg());
            }
            return result.getData();
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            log.warn("user exam-preference Feign failed: {}", e.getMessage());
            throw new BizException(ErrorCode.USER_PREFERENCE_UNAVAILABLE);
        }
    }
}
