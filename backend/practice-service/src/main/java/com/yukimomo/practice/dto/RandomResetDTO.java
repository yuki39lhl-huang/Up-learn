package com.yukimomo.practice.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 随机刷题「清空重刷」请求。
 * <p>
 * {@code scope=all}：清除用户全部备考映射科目下的复习记录；{@code scope=single}：仅清除指定科目。
 */
@Data
public class RandomResetDTO {

    /** all | single */
    @NotBlank
    private String scope;

    /** scope=single 时必填，须为用户备考范围内的题库科目名。 */
    private String subject;
}
