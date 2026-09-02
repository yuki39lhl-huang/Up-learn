package com.yukimomo.user.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户目标院校列表项（含院校/专业展示字段）。
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

    /** 专业名；仅指定专业时有值 */
    private String majorName;
    private String majorCategory;

    private LocalDateTime createdAt;
}
