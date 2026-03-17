package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.vo.SiteStockBatchVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockVO;

import java.util.List;

/**
 * 接种点库存（按批次）Service
 * 预约锁定、核销扣减、可用库存汇总、过期清零
 */
public interface SiteVaccineStockService extends IService<SiteVaccineStock> {

    /**
     * 某接种点某疫苗的可用库存数（未过期批次的 available_stock 之和，用于预约前校验）
     */
    int getAvailableStock(Long vaccineId, Long siteId);

    /**
     * FEFO 取该接种点该疫苗的一条可锁定记录（未过期、available_stock>0），按效期升序
     */
    SiteVaccineStock getFefoStockRow(Long siteId, Long vaccineId);

    /**
     * 预约时锁定一剂：available_stock -1, locked_stock +1
     *
     * @return 是否锁定成功
     */
    boolean lockStock(Long siteVaccineStockId);

    /**
     * 取消预约时回滚：available_stock +1, locked_stock -1
     */
    void unlockStock(Long siteId, Long batchId);

    /**
     * 核销时扣减：locked_stock -1, available_stock -1
     *
     * @return 是否扣减成功
     */
    boolean deductOnVerify(Long siteId, Long batchId);

    /**
     * 调拨入库：增加该接种点该批次的可用库存（无记录则先创建）
     */
    void addAvailableStock(Long siteId, Long batchId, int quantity);

    /**
     * 接种点退回总仓：减少该接种点该批次的可用库存（仅 available_stock，不可退 locked）
     *
     * @return 是否扣减成功（available_stock 不足时 false）
     */
    boolean reduceAvailableStock(Long siteId, Long batchId, int quantity);

    /**
     * 接种点整批退回：同时扣减可用与锁定库存（删除接种点时将该点该批次全部退回总仓用）
     *
     * @return 是否扣减成功
     */
    boolean reduceAvailableAndLockedStock(Long siteId, Long batchId, int availableQty, int lockedQty);

    /**
     * 过期联动：将该批次在所有接种点的 available_stock、locked_stock 置为 0
     */
    int zeroOutByBatchId(Long batchId);

    /**
     * 按接种点查询所有批次库存（含疫苗、批号、效期等）
     */
    List<SiteVaccineStock> listBySiteId(Long siteId);

    /**
     * 某接种点按疫苗汇总可用库存（与预约校验一致，用于用户端/管理员端展示）
     */
    List<SiteStockVO> listAvailableStockByVaccineForSite(Long siteId);

    /**
     * 某接种点按批次库存列表（含疫苗名、批号、效期），用于库存管理展示与退回
     */
    List<SiteStockBatchVO> listBySiteIdWithBatchInfo(Long siteId);

    /**
     * 管理员-按疫苗减少接种点可用库存（FEFO 从多批次扣减，不退回总仓）
     *
     * @param siteId    接种点ID
     * @param vaccineId 疫苗ID
     * @param quantity  减少数量
     * @return 实际扣减的数量（可能小于 quantity 若库存不足）
     */
    int reduceAvailableStockByVaccine(Long siteId, Long vaccineId, int quantity);
}
