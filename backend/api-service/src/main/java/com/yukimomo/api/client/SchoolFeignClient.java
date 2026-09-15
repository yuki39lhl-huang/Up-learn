package com.yukimomo.api.client;

import com.yukimomo.api.feign.FeignUserIdConfig;
import com.yukimomo.api.school.vo.SchoolMajorVO;
import com.yukimomo.api.school.vo.SchoolVO;
import com.yukimomo.api.school.vo.SyllabusOptionsVO;
import com.yukimomo.api.school.vo.SyllabusVO;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 调用 school-service：院校列表、某校专业、考纲。
 */
@FeignClient(
        name = "school-service",
        contextId = "schoolFeignClient",
        configuration = FeignUserIdConfig.class
)
public interface SchoolFeignClient {

    @GetMapping("/api/school/list")
    Result<PageDTO<SchoolVO>> listSchools(
            @RequestParam(required = false) String kw,
            @RequestParam(required = false) String province,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Long majorDictId,
            @RequestParam(required = false) String discipline,
            @RequestParam(required = false) String majorCategory,
            @RequestParam(required = false) Boolean preferPublic,
            @RequestParam(required = false) Integer pageNo,
            @RequestParam(required = false) Integer pageSize);

    /** 院校详情；不存在时 code = {@code ErrorCode.SCHOOL_NOT_FOUND}。 */
    @GetMapping("/api/school/{id}")
    Result<SchoolVO> getSchool(@PathVariable("id") Long schoolId);

    @GetMapping("/api/school/{id}/majors")
    Result<List<SchoolMajorVO>> listMajors(
            @PathVariable("id") Long schoolId,
            @RequestParam(required = false) Long majorDictId,
            @RequestParam(required = false) String majorCategory);

    @GetMapping("/api/syllabus/options")
    Result<SyllabusOptionsVO> listSyllabusOptions();

    @GetMapping("/api/syllabus")
    Result<SyllabusVO> getSyllabus(
            @RequestParam String province,
            @RequestParam Integer year,
            @RequestParam String subject);
}
