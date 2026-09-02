package com.yukimomo.user.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 加入目标院校请求体。
 */
@Data
public class AddUserTargetDTO {

    @NotNull(message = "schoolId 不能为空")
    private Long schoolId;

    /** 可选：{@code school_major.id} */
    private Long majorId;
}
