package com.tjut.edu.vaccine_system.common.result;

import com.baomidou.mybatisplus.core.metadata.IPage;

import java.util.List;

/**
 * 统一响应工具类：封装分页等常用返回，减少 Controller 层重复代码。
 */
public final class Results {

    private Results() {
    }

    /**
     * 将 MyBatis-Plus 分页结果包装为 Result&lt;PageResult&lt;T&gt;&gt;
     */
    public static <T> Result<PageResult<T>> page(IPage<T> page) {
        return Result.ok(PageResult.of(
                page.getRecords(),
                page.getTotal(),
                page.getCurrent(),
                page.getSize()));
    }

    /**
     * 将自定义分页数据包装为 Result&lt;PageResult&lt;T&gt;&gt;（如 Service 返回 VO 列表 + 分页信息）
     */
    public static <T> Result<PageResult<T>> page(List<T> records, long total, long current, long size) {
        return Result.ok(PageResult.of(records, total, current, size));
    }
}
