package com.yukimomo.api.user.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户目标院校（跨服务契约）。
 */
@Data
public class UserTargetVO {

    private Long id;
    private Long userId;
    private Long schoolId;
    private Long majorId;
    private String schoolName;
    private String schoolProvince;
    private String schoolCity;
    private String schoolType;
    private String majorName;
    private String majorCategory;
    private LocalDateTime createdAt;
}
