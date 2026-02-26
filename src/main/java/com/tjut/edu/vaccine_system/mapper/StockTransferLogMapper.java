package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.StockTransferLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 库存调拨日志 Mapper
 */
@Mapper
public interface StockTransferLogMapper extends BaseMapper<StockTransferLog> {

    /**
     * 分页查询调拨日志（可选 batchId、时间范围）
     */
    List<StockTransferLog> selectPageList(@Param("batchId") Long batchId,
                                          @Param("fromTime") LocalDateTime fromTime,
                                          @Param("toTime") LocalDateTime toTime,
                                          @Param("offset") long offset,
                                          @Param("size") long size);

    long countPageList(@Param("batchId") Long batchId,
                      @Param("fromTime") LocalDateTime fromTime,
                      @Param("toTime") LocalDateTime toTime);
}
