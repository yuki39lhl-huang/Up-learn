package com.yukimomo.school.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 专业词典选项（Combobox）。
 * <p>
 * 选中后把 {@link #id} 作为 {@code majorDictId} 传给 {@code /api/school/list}。
 */
@Data
@Schema(description = "专业词典选项")
public class MajorOptionVO {

    /** 词典 ID → list.majorDictId */
    private Long id;
    private String name;
    private String majorCategory;
}
