package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.mapper.SiteVaccineStockMapper;
import com.tjut.edu.vaccine_system.model.dto.SiteVaccineStockSummaryDTO;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.vo.SiteStockBatchVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockVO;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 接种点库存（按批次）Service 实现
 */
@Service
@RequiredArgsConstructor
public class SiteVaccineStockServiceImpl extends ServiceImpl<SiteVaccineStockMapper, SiteVaccineStock> implements SiteVaccineStockService {

    @Override
    public int getAvailableStock(Long vaccineId, Long siteId) {
        if (vaccineId == null || siteId == null) return 0;
        Integer sum = baseMapper.sumAvailableStockBySiteAndVaccine(siteId, vaccineId);
        return sum != null ? sum : 0;
    }

    @Override
    public SiteVaccineStock getFefoStockRow(Long siteId, Long vaccineId) {
        if (siteId == null || vaccineId == null) return null;
        return baseMapper.selectFefoBySiteAndVaccine(siteId, vaccineId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean lockStock(Long siteVaccineStockId) {
        if (siteVaccineStockId == null) return false;
        int rows = baseMapper.lockStock(siteVaccineStockId);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void unlockStock(Long siteId, Long batchId) {
        if (siteId == null || batchId == null) return;
        SiteVaccineStock one = getOne(new LambdaQueryWrapper<SiteVaccineStock>()
                .eq(SiteVaccineStock::getSiteId, siteId)
                .eq(SiteVaccineStock::getBatchId, batchId));
        if (one != null && one.getLockedStock() != null && one.getLockedStock() > 0) {
            baseMapper.unlockStock(one.getId());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deductOnVerify(Long siteId, Long batchId) {
        if (siteId == null || batchId == null) return false;
        int rows = baseMapper.deductOnVerify(siteId, batchId);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addAvailableStock(Long siteId, Long batchId, int quantity) {
        if (siteId == null || batchId == null || quantity <= 0) return;
        SiteVaccineStock one = getOne(new LambdaQueryWrapper<SiteVaccineStock>()
                .eq(SiteVaccineStock::getSiteId, siteId)
                .eq(SiteVaccineStock::getBatchId, batchId));
        if (one == null) {
            one = SiteVaccineStock.builder()
                    .siteId(siteId)
                    .batchId(batchId)
                    .availableStock(quantity)
                    .lockedStock(0)
                    .build();
            save(one);
        } else {
            int rows = baseMapper.addAvailableStock(siteId, batchId, quantity);
            if (rows == 0) {
                throw new IllegalStateException("调拨入库更新接种点库存失败");
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean reduceAvailableStock(Long siteId, Long batchId, int quantity) {
        if (siteId == null || batchId == null || quantity <= 0) return false;
        int rows = baseMapper.reduceAvailableStock(siteId, batchId, quantity);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int zeroOutByBatchId(Long batchId) {
        if (batchId == null) return 0;
        return baseMapper.zeroOutByBatchId(batchId);
    }

    @Override
    public List<SiteVaccineStock> listBySiteId(Long siteId) {
        if (siteId == null) return List.of();
        return list(new LambdaQueryWrapper<SiteVaccineStock>()
                .eq(SiteVaccineStock::getSiteId, siteId)
                .orderByAsc(SiteVaccineStock::getBatchId));
    }

    @Override
    public List<SiteStockVO> listAvailableStockByVaccineForSite(Long siteId) {
        if (siteId == null) return List.of();
        List<SiteVaccineStockSummaryDTO> list = baseMapper.listAvailableStockGroupByVaccine(siteId);
        return list.stream()
                .map(dto -> SiteStockVO.builder()
                        .id(null)
                        .siteId(siteId)
                        .vaccineId(dto.getVaccineId())
                        .vaccineName(dto.getVaccineName())
                        .quantity(dto.getQuantity() != null ? dto.getQuantity() : 0)
                        .warningThreshold(0)
                        .build())
                .toList();
    }

    @Override
    public List<SiteStockBatchVO> listBySiteIdWithBatchInfo(Long siteId) {
        if (siteId == null) return List.of();
        return baseMapper.listBySiteIdWithBatchInfo(siteId);
    }
}
