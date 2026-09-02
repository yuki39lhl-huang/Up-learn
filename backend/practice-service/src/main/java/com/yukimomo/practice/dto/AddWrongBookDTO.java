package com.yukimomo.practice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 手动加入错题本。
 */
@Data
public class AddWrongBookDTO {

    @NotNull
    private Long questionId;

    /** 用户当时选择的答案（如 A/B/C/D）。 */
    @NotBlank
    private String userAnswer;
}
