package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 疫苗批次 Mapper（FEFO 查询、库存扣减/回滚）
 */
@Mapper
public interface VaccineBatchMapper extends BaseMapper<VaccineBatch> {

    /**
     * FEFO：先过期先使用，取一条可用批次
     * WHERE vaccine_id=? AND stock>0 AND expiry_date>NOW() AND status IN (0,1) ORDER BY expiry_date ASC LIMIT 1
     */
    VaccineBatch selectFefoBatch(@Param("vaccineId") Long vaccineId);

    /**
     * 扣减批次库存 1，仅当 stock > 0 时更新，返回影响行数
     */
    int decrementStock(@Param("batchId") Long batchId);

    /**
     * 扣减批次库存 quantity，仅当 stock >= quantity 时更新，返回影响行数（调拨用）
     */
    int decrementStockByQuantity(@Param("batchId") Long batchId, @Param("quantity") int quantity);

    /**
     * 增加批次库存 1（取消预约回滚用）
     */
    int incrementStock(@Param("batchId") Long batchId);

    /**
     * 增加批次库存 quantity（接种点退回总仓用）
     */
    int incrementStockByQuantity(@Param("batchId") Long batchId, @Param("quantity") int quantity);

    /**
     * 将过期批次状态更新为 2（过期）
     */
    int updateStatusToExpiredWhereExpiryBefore(@Param("date") java.time.LocalDate date);

    /**
     * 总仓按疫苗汇总剩余数量（未过期、正常/临期批次的 stock 之和）
     */
    List<VaccineStockVO> sumWarehouseStockGroupByVaccine();
}
