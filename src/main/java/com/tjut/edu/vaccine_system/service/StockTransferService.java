package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.model.dto.BatchAllocateVaccineDTO;
import com.tjut.edu.vaccine_system.model.entity.StockTransferLog;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 库存调拨 Service
 */
public interface StockTransferService {

    /**
     * 总仓 -> 接种点 调拨（原子：扣减 vaccine_batch.stock、增加 site_vaccine_stock.available_stock、写日志）
     *
     * @param batchId    批次ID
     * @param siteId     接种点ID
     * @param quantity   数量
     * @param operatorId 操作人ID
     */
    void transferFromWarehouseToSite(Long batchId, Long siteId, int quantity, Long operatorId);

    /**
     * 分页查询调拨日志
     */
    IPage<StockTransferLog> pageLogs(long current, long size, Long batchId, LocalDateTime fromTime, LocalDateTime toTime);

    /**
     * 按疫苗分配：从总仓 FEFO 取该疫苗一批次，调拨至接种点（管理员免选批次）
     *
     * @param siteId     接种点ID
     * @param vaccineId  疫苗ID
     * @param quantity   数量
     * @param operatorId 操作人ID
     */
    void allocateByVaccine(Long siteId, Long vaccineId, int quantity, Long operatorId);

    /**
     * 按接种点批量分配多种疫苗（总仓 FEFO 自动选批，事务内逐条执行）
     *
     * @param siteId     接种点ID
     * @param items      疫苗及数量列表（vaccineId, quantity）
     * @param operatorId 操作人ID
     */
    void batchAllocateByVaccine(Long siteId, List<BatchAllocateVaccineDTO.AllocateVaccineItem> items, Long operatorId);

    /**
     * 接种点向总仓退回疫苗（按批次退可用库存，总仓批次库存增加，写调拨日志）
     *
     * @param siteId     接种点ID
     * @param batchId    批次ID
     * @param quantity   退回数量
     * @param operatorId 操作人ID
     */
    void returnToWarehouse(Long siteId, Long batchId, int quantity, Long operatorId);

    /**
     * 将接种点所有疫苗可用库存一次性退回到总仓（管理员库存）。
     * 用于接种点禁用或删除时，将其下所有批次的可用库存归还总仓并写调拨日志。
     *
     * @param siteId     接种点ID
     * @param operatorId 操作人ID，可为 null（如系统禁用/删除时）
     */
    void returnAllSiteStockToWarehouse(Long siteId, Long operatorId);
}
