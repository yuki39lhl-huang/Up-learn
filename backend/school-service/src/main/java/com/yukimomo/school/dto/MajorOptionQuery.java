package com.yukimomo.school.dto;

import com.yukimomo.common.domain.PageQuery;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 专业选项查询（筛选框 Combobox：可输入模糊搜，也可无关键字分页滚动）。
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "专业选项查询参数")
public class MajorOptionQuery extends PageQuery {

    @Schema(description = "专业名模糊；不传则按分页滚动浏览", example = "计算机")
    private String kw;
    @Schema(description = "专业类精确匹配（级联：先选类型再选专业）", example = "计算机类")
    private String majorCategory;
}
