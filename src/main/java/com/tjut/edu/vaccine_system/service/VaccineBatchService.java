package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;

import java.time.LocalDate;
import java.util.List;

/**
 * 疫苗批次 Service（FEFO、保质期、销毁）
 */
public interface VaccineBatchService extends IService<VaccineBatch> {

    /**
     * FEFO 取一条可用批次（先过期先使用），不扣减库存
     */
    VaccineBatch selectFefoBatch(Long vaccineId);

    /**
     * 扣减批次库存 1，用于预约成功时锁定
     *
     * @return 是否扣减成功
     */
    boolean decrementStock(Long batchId);

    /**
     * 扣减批次库存 quantity（调拨时总仓出库用）
     *
     * @return 影响行数，0 表示库存不足
     */
    int decrementStockByQuantity(Long batchId, int quantity);

    /**
     * 增加批次库存 1，用于预约取消时回滚
     */
    void incrementStock(Long batchId);

    /**
     * 增加批次库存 quantity，用于接种点退回总仓
     */
    void incrementStockByQuantity(Long batchId, int quantity);

    /**
     * 将 expiry_date &lt; today 的批次状态更新为过期(2)
     *
     * @return 更新条数
     */
    int markExpiredBatches(LocalDate today);

    /**
     * 查询 expiry_date &lt; today 且状态为正常/临期的批次（用于过期联动：先清零接种点库存再标过期）
     */
    List<VaccineBatch> listExpiredByDate(LocalDate today);

    /**
     * 分页查询批次，支持按疫苗、状态筛选
     */
    IPage<VaccineBatch> pageBatches(long current, long size, Long vaccineId, Integer status);

    /**
     * 管理员执行销毁：记录销毁、状态改为已销毁、库存清零
     */
    void dispose(Long batchId, String disposalReason, LocalDate disposalDate, Long operatorId, String remark);

    /**
     * 查询临期/过期批次（用于管理端筛选）
     */
    List<VaccineBatch> listByStatus(Integer status);

    /**
     * 总仓可调拨批次（stock>0、未过期、状态正常/临期），按效期升序，供调拨下拉选择
     */
    List<VaccineBatch> listWarehouseBatchesForTransfer();

    /**
     * 总仓按疫苗汇总剩余数量（未过期、正常/临期批次），用于疫苗管理实时展示
     */
    List<VaccineStockVO> listWarehouseStockByVaccine();
}
