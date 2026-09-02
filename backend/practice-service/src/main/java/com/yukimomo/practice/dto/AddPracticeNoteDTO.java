package com.yukimomo.practice.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 添加到备忘录。
 */
@Data
public class AddPracticeNoteDTO {

    @NotNull
    private Long questionId;

    /** 用户备注，可选。 */
    private String userNote;
}
