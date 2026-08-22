package com.yukimomo.common.domain;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.Data;

import java.util.Collections;
import java.util.List;

/**
 * 分页结果对外 VO，放在 {@link Result#getData()} 中返回给前端。
 * <p>
 * 字段含义与前端表格组件常见约定一致：total 总条数、pages 总页数、list 当前页数据。
 */
@Data
public class PageDTO<T> {

    /** 符合条件的总记录数 */
    private Long total;
    /** 总页数（由 MP {@link Page#getPages()} 计算） */
    private Long pages;
    /** 当前页记录列表 */
    private List<T> list;

    /** 空分页结果（total=0） */
    public static <T> PageDTO<T> empty() {
        PageDTO<T> dto = new PageDTO<>();
        dto.total = 0L;
        dto.pages = 0L;
        dto.list = Collections.emptyList();
        return dto;
    }

    /** 从 MyBatis-Plus 分页查询结果转换 */
    public static <T> PageDTO<T> of(Page<T> page) {
        PageDTO<T> dto = new PageDTO<>();
        dto.total = page.getTotal();
        dto.pages = page.getPages();
        dto.list = page.getRecords() == null ? Collections.emptyList() : page.getRecords();
        return dto;
    }

    /**
     * 手动组装（无 MP 分页时），pages 仅在 total&gt;0 时置为 1，适合简单列表。
     */
    public static <T> PageDTO<T> of(long total, List<T> list) {
        PageDTO<T> dto = new PageDTO<>();
        dto.total = total;
        dto.list = list == null ? Collections.emptyList() : list;
        dto.pages = dto.total == 0 ? 0L : 1L;
        return dto;
    }
}
