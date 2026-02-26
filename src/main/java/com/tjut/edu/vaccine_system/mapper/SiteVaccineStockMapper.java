package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.dto.SiteVaccineStockSummaryDTO;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.vo.SiteStockBatchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 接种点库存（按批次）Mapper
 */
@Mapper
public interface SiteVaccineStockMapper extends BaseMapper<SiteVaccineStock> {

    /**
     * FEFO：取该接种点该疫苗下一条可用批次（未过期、available_stock>0），按 expiry_date 升序
     */
    SiteVaccineStock selectFefoBySiteAndVaccine(@Param("siteId") Long siteId, @Param("vaccineId") Long vaccineId);

    /**
     * 预约锁定：available_stock -1, locked_stock +1，仅当 available_stock > 0 时更新
     *
     * @return 影响行数
     */
    int lockStock(@Param("id") Long siteVaccineStockId);

    /**
     * 取消预约回滚：available_stock +1, locked_stock -1，仅当 locked_stock > 0 时更新
     *
     * @return 影响行数
     */
    int unlockStock(@Param("id") Long siteVaccineStockId);

    /**
     * 核销扣减：locked_stock -1（可用已在预约锁定时减过）
     *
     * @return 影响行数
     */
    int deductOnVerify(@Param("siteId") Long siteId, @Param("batchId") Long batchId);

    /**
     * 调拨入库：available_stock += quantity（无记录则需先 insert）
     *
     * @return 影响行数
     */
    int addAvailableStock(@Param("siteId") Long siteId, @Param("batchId") Long batchId, @Param("quantity") int quantity);

    /**
     * 接种点退回总仓：available_stock -= quantity，仅当 available_stock >= quantity 时更新
     *
     * @return 影响行数
     */
    int reduceAvailableStock(@Param("siteId") Long siteId, @Param("batchId") Long batchId, @Param("quantity") int quantity);

    /**
     * 过期联动：将某批次在所有接种点的 available_stock、locked_stock 置为 0
     *
     * @return 影响行数
     */
    int zeroOutByBatchId(@Param("batchId") Long batchId);

    /**
     * 某接种点某疫苗的可用库存汇总（未过期批次的 available_stock 之和）
     */
    int sumAvailableStockBySiteAndVaccine(@Param("siteId") Long siteId, @Param("vaccineId") Long vaccineId);

    /**
     * 某接种点按疫苗汇总可用库存（未过期批次，用于用户/管理员展示与预约校验一致）
     */
    List<SiteVaccineStockSummaryDTO> listAvailableStockGroupByVaccine(@Param("siteId") Long siteId);

    /**
     * 某接种点按批次库存列表（含疫苗名、批号、效期，用于展示与退回）
     */
    List<SiteStockBatchVO> listBySiteIdWithBatchInfo(@Param("siteId") Long siteId);
}
