package com.yukimomo.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 仅更新随机刷题科目筛选。
 */
@Data
public class RandomSubjectFilterSaveDTO {

    /** all 全随机 / single 指定题库科目。 */
    @NotBlank
    private String randomSubjectMode;

    /** single 时的题库科目名，如高等数学。 */
    private String randomSubject;
}
