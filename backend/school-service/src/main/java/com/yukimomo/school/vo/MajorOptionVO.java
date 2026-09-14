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
    /** 门类，如工学 */
    private String discipline;
    /** 专业类，如计算机类 */
    private String majorCategory;
    /** 统考/校考/混合 */
    private String examTrack;
}
