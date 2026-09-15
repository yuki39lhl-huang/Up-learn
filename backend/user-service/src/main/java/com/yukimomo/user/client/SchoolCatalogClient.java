package com.yukimomo.user.client;

import com.yukimomo.api.client.SchoolFeignClient;
import com.yukimomo.api.school.vo.SchoolMajorVO;
import com.yukimomo.api.school.vo.SchoolVO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

/**
 * user → school 院校/专业目录（Feign）。
 * <p>
 * 取代早期在 user-service 内直读 {@code school / school_major / major_dict} 表的做法，
 * user 域不再耦合 school 域表结构。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SchoolCatalogClient {

    private final SchoolFeignClient schoolFeignClient;

    /** 院校详情；不存在时返回 {@code null}。 */
    public SchoolVO findSchool(Long schoolId) {
        Result<SchoolVO> result = call(() -> schoolFeignClient.getSchool(schoolId), "school detail");
        if (result.getCode() == ErrorCode.SCHOOL_NOT_FOUND.getCode()) {
            return null;
        }
        ensureSuccess(result, "school detail");
        return result.getData();
    }

    /** 某校全部开设专业；院校不存在时返回空列表。 */
    public List<SchoolMajorVO> listMajors(Long schoolId) {
        Result<List<SchoolMajorVO>> result =
                call(() -> schoolFeignClient.listMajors(schoolId, null, null), "school majors");
        if (result.getCode() == ErrorCode.SCHOOL_NOT_FOUND.getCode()) {
            return Collections.emptyList();
        }
        ensureSuccess(result, "school majors");
        return result.getData() == null ? Collections.emptyList() : result.getData();
    }

    private <T> Result<T> call(java.util.function.Supplier<Result<T>> supplier, String what) {
        try {
            Result<T> result = supplier.get();
            if (result == null) {
                throw new BizException(ErrorCode.SCHOOL_SERVICE_UNAVAILABLE, "空响应");
            }
            return result;
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            log.warn("school-service {} Feign failed: {}", what, e.getMessage());
            throw new BizException(ErrorCode.SCHOOL_SERVICE_UNAVAILABLE);
        }
    }

    private void ensureSuccess(Result<?> result, String what) {
        if (result.getCode() != ErrorCode.SUCCESS.getCode()) {
            log.warn("school-service {} business fail: {}", what, result.getMsg());
            throw new BizException(ErrorCode.SCHOOL_SERVICE_UNAVAILABLE, result.getMsg());
        }
    }
}
