package com.yukimomo.school.dto;

import com.yukimomo.common.domain.PageQuery;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 院校统一查询入参（{@code GET /api/school/list}）。
 * <p>
 * 专业筛选：Combobox 选中后传 {@code majorDictId}（精确）；不要再对专业名模糊。
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "院校查询参数（GET Query）")
public class SchoolQuery extends PageQuery {

    @Schema(description = "院校名模糊（搜索框）", example = "深圳")
    private String kw;
    @Schema(description = "省份（与库一致，如广东）", example = "广东")
    private String province;
    @Schema(description = "公办 / 民办 等", example = "公办")
    private String type;
    @Schema(description = "招生年份（按 school_major.year）", example = "2025")
    private Integer year;
    @Schema(description = "专业词典 ID（来自 /api/major/options 选中项）", example = "1")
    private Long majorDictId;
    @Schema(description = "专业类精确匹配（可选，一般有 majorDictId 可不传）", example = "计算机类")
    private String majorCategory;
    @Schema(description = "true 时仅公办", example = "true")
    private Boolean preferPublic;
}
