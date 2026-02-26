package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.mapper.StockTransferLogMapper;
import com.tjut.edu.vaccine_system.model.dto.BatchAllocateVaccineDTO;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.entity.StockTransferLog;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.enums.TransferTypeEnum;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.StockTransferService;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 库存调拨 Service 实现
 * 总仓 -> 接种点：校验总仓库存、扣减 vaccine_batch.stock、增加 site_vaccine_stock、写调拨日志
 */
@Service
@RequiredArgsConstructor
public class StockTransferServiceImpl implements StockTransferService {

    private final VaccineBatchService vaccineBatchService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final StockTransferLogMapper stockTransferLogMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void transferFromWarehouseToSite(Long batchId, Long siteId, int quantity, Long operatorId) {
        if (batchId == null || siteId == null || quantity <= 0) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "批次、接种点与数量必填且数量大于0");
        }
        VaccineBatch batch = vaccineBatchService.getById(batchId);
        if (batch == null) {
            throw new BizException(BizErrorCode.NOT_FOUND, "批次不存在");
        }
        Integer stock = batch.getStock();
        if (stock == null || stock < quantity) {
            throw new BizException(BizErrorCode.STOCK_INSUFFICIENT, "总仓该批次库存不足，当前库存：" + (stock != null ? stock : 0));
        }
        // 1) 扣减总仓（原子扣减 quantity）
        int decRows = vaccineBatchService.decrementStockByQuantity(batchId, quantity);
        if (decRows == 0) {
            throw new BizException(BizErrorCode.STOCK_INSUFFICIENT, "总仓库存扣减失败，可能已被并发占用");
        }
        // 2) 增加接种点该批次可用库存
        siteVaccineStockService.addAvailableStock(siteId, batchId, quantity);
        // 3) 写调拨日志（from_type=0 总仓, to_type=1 接种点）
        StockTransferLog log = StockTransferLog.builder()
                .batchId(batchId)
                .fromType(TransferTypeEnum.WAREHOUSE.getCode())
                .fromId(null)
                .toType(TransferTypeEnum.SITE.getCode())
                .toId(siteId)
                .quantity(quantity)
                .operatorId(operatorId)
                .transferTime(LocalDateTime.now())
                .build();
        stockTransferLogMapper.insert(log);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void allocateByVaccine(Long siteId, Long vaccineId, int quantity, Long operatorId) {
        if (siteId == null || vaccineId == null || quantity <= 0) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "接种点、疫苗与数量必填且数量大于0");
        }
        VaccineBatch batch = vaccineBatchService.selectFefoBatch(vaccineId);
        if (batch == null) {
            throw new BizException(BizErrorCode.STOCK_INSUFFICIENT, "总仓该疫苗暂无可用批次（无在效期内或库存为0）");
        }
        Integer stock = batch.getStock();
        if (stock == null || stock < quantity) {
            throw new BizException(BizErrorCode.STOCK_INSUFFICIENT,
                    "总仓该疫苗可用库存不足，当前可调拨最多：" + (stock != null ? stock : 0) + "，请减少数量或先入库");
        }
        transferFromWarehouseToSite(batch.getId(), siteId, quantity, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchAllocateByVaccine(Long siteId, List<BatchAllocateVaccineDTO.AllocateVaccineItem> items, Long operatorId) {
        if (siteId == null || items == null || items.isEmpty()) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "接种点与至少一条疫苗数量必填");
        }
        for (BatchAllocateVaccineDTO.AllocateVaccineItem item : items) {
            if (item.getVaccineId() == null || item.getQuantity() == null || item.getQuantity() < 1) continue;
            allocateByVaccine(siteId, item.getVaccineId(), item.getQuantity(), operatorId);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnToWarehouse(Long siteId, Long batchId, int quantity, Long operatorId) {
        if (siteId == null || batchId == null || quantity <= 0) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "接种点、批次与数量必填且数量大于0");
        }
        boolean reduced = siteVaccineStockService.reduceAvailableStock(siteId, batchId, quantity);
        if (!reduced) {
            throw new BizException(BizErrorCode.STOCK_INSUFFICIENT, "该接种点该批次可用库存不足或不存在，无法退回");
        }
        vaccineBatchService.incrementStockByQuantity(batchId, quantity);
        StockTransferLog log = StockTransferLog.builder()
                .batchId(batchId)
                .fromType(TransferTypeEnum.SITE.getCode())
                .fromId(siteId)
                .toType(TransferTypeEnum.WAREHOUSE.getCode())
                .toId(null)
                .quantity(quantity)
                .operatorId(operatorId)
                .transferTime(LocalDateTime.now())
                .build();
        stockTransferLogMapper.insert(log);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnAllSiteStockToWarehouse(Long siteId, Long operatorId) {
        if (siteId == null) return;
        List<SiteVaccineStock> list = siteVaccineStockService.listBySiteId(siteId);
        for (SiteVaccineStock row : list) {
            int available = row.getAvailableStock() != null ? row.getAvailableStock() : 0;
            if (available > 0 && row.getBatchId() != null) {
                returnToWarehouse(siteId, row.getBatchId(), available, operatorId);
            }
        }
    }

    @Override
    public IPage<StockTransferLog> pageLogs(long current, long size, Long batchId, LocalDateTime fromTime, LocalDateTime toTime) {
        long total = stockTransferLogMapper.countPageList(batchId, fromTime, toTime);
        long offset = (current - 1) * size;
        List<StockTransferLog> records = stockTransferLogMapper.selectPageList(batchId, fromTime, toTime, offset, size);
        Page<StockTransferLog> page = new Page<>(current, size, total);
        page.setRecords(records);
        return page;
    }
}
