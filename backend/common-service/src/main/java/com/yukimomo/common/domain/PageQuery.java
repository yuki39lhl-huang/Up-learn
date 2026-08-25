package com.yukimomo.common.domain;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.Data;

/**
 * 分页查询入参（通常作为 Controller 查询参数或 POST body 的字段）。
 * <p>
 * 与 MyBatis-Plus 的 {@link Page} 配合：先 {@link #toMpPage()} 再交给 Mapper 分页查询，
 * 查询结果再用 {@link PageDTO#of(Page)} 转成对外 VO。
 */
@Data
public class PageQuery {
    //起始页计算公式(页码-1)*每页条数

    /** 默认每页条数 */
    public static final int DEFAULT_PAGE_SIZE = 10;
    /** 单页最大条数，防止恶意大 pageSize 拖垮数据库 */
    public static final int MAX_PAGE_SIZE = 100;

    /** 页码，从 1 开始；null 或 &lt;1 时按 1 处理 */
    private Integer pageNo = 1;
    /** 每页条数；null 或非法值时回退默认值，超过上限则截断 */
    private Integer pageSize = DEFAULT_PAGE_SIZE;

    /** 安全页码（至少为 1） */
    public int safePageNo() {
        return pageNo == null || pageNo < 1 ? 1 : pageNo;
    }

    /** 安全每页条数（1～{@link #MAX_PAGE_SIZE}） */
    public int safePageSize() {
        if (pageSize == null || pageSize < 1) {
            return DEFAULT_PAGE_SIZE;
        }
        return Math.min(pageSize, MAX_PAGE_SIZE);
    }

    /** 转为 MP 分页对象，不含排序 */
    public <T> Page<T> toMpPage() {
        return new Page<>(safePageNo(), safePageSize());
    }

    /**
     * 转为 MP 分页对象，并附加排序字段。
     *
     * @param orderBy 数据库列名或实体字段名（与 MP 配置一致）
     * @param asc     true 升序，false 降序
     */
    public <T> Page<T> toMpPage(String orderBy, boolean asc) {
        Page<T> page = toMpPage();
        if (orderBy != null && !orderBy.isBlank()) {
            page.addOrder(asc ? com.baomidou.mybatisplus.core.metadata.OrderItem.asc(orderBy)
                    : com.baomidou.mybatisplus.core.metadata.OrderItem.desc(orderBy));
        }
        return page;
    }
}
