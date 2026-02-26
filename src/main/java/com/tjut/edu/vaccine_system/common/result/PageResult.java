package com.tjut.edu.vaccine_system.common.result;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

/**
 * 分页结果封装，与前端表格/列表组件约定字段：records/total/current/size/pages。
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 当前页数据列表 */
    private List<T> records;
    /** 总记录数 */
    private Long total;
    /** 当前页码（从 1 开始） */
    private Long current;
    /** 每页条数 */
    private Long size;
    /** 总页数 */
    private Long pages;

    /** 空分页，用于无数据或异常时 */
    public static <T> PageResult<T> empty(long current, long size) {
        return PageResult.<T>builder()
                .records(Collections.emptyList())
                .total(0L)
                .current(current)
                .size(size)
                .pages(0L)
                .build();
    }

    /** 构造分页结果，pages 由 total 与 size 自动计算 */
    public static <T> PageResult<T> of(List<T> records, long total, long current, long size) {
        long pages = size > 0 ? (total + size - 1) / size : 0;
        return PageResult.<T>builder()
                .records(records)
                .total(total)
                .current(current)
                .size(size)
                .pages(pages)
                .build();
    }
}
