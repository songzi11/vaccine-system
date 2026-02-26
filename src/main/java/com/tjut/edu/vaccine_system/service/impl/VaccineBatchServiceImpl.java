package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatchDisposal;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import com.tjut.edu.vaccine_system.model.enums.BatchStatusEnum;
import com.tjut.edu.vaccine_system.mapper.VaccineBatchDisposalMapper;
import com.tjut.edu.vaccine_system.mapper.VaccineBatchMapper;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

/**
 * 疫苗批次 Service 实现
 */
@Service
@RequiredArgsConstructor
public class VaccineBatchServiceImpl extends ServiceImpl<VaccineBatchMapper, VaccineBatch> implements VaccineBatchService {

    private final VaccineBatchMapper vaccineBatchMapper;
    private final VaccineBatchDisposalMapper vaccineBatchDisposalMapper;

    @Override
    public VaccineBatch selectFefoBatch(Long vaccineId) {
        if (vaccineId == null) return null;
        return vaccineBatchMapper.selectFefoBatch(vaccineId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean decrementStock(Long batchId) {
        if (batchId == null) return false;
        int rows = vaccineBatchMapper.decrementStock(batchId);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int decrementStockByQuantity(Long batchId, int quantity) {
        if (batchId == null || quantity <= 0) return 0;
        return vaccineBatchMapper.decrementStockByQuantity(batchId, quantity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void incrementStock(Long batchId) {
        if (batchId == null) return;
        vaccineBatchMapper.incrementStock(batchId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void incrementStockByQuantity(Long batchId, int quantity) {
        if (batchId == null || quantity <= 0) return;
        vaccineBatchMapper.incrementStockByQuantity(batchId, quantity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int markExpiredBatches(LocalDate today) {
        if (today == null) return 0;
        return vaccineBatchMapper.updateStatusToExpiredWhereExpiryBefore(today);
    }

    @Override
    public List<VaccineBatch> listExpiredByDate(LocalDate today) {
        if (today == null) return List.of();
        return list(new LambdaQueryWrapper<VaccineBatch>()
                .lt(VaccineBatch::getExpiryDate, today)
                .in(VaccineBatch::getStatus, BatchStatusEnum.NORMAL.getCode(), BatchStatusEnum.NEAR_EXPIRY.getCode()));
    }

    @Override
    public IPage<VaccineBatch> pageBatches(long current, long size, Long vaccineId, Integer status) {
        Page<VaccineBatch> page = new Page<>(current, size);
        LambdaQueryWrapper<VaccineBatch> w = new LambdaQueryWrapper<>();
        w.eq(vaccineId != null, VaccineBatch::getVaccineId, vaccineId)
                .eq(status != null, VaccineBatch::getStatus, status)
                .orderByAsc(VaccineBatch::getExpiryDate)
                .orderByDesc(VaccineBatch::getCreatedAt);
        return page(page, w);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void dispose(Long batchId, String disposalReason, LocalDate disposalDate, Long operatorId, String remark) {
        if (batchId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "批次ID不能为空");
        VaccineBatch batch = getById(batchId);
        if (batch == null) throw new BizException(BizErrorCode.NOT_FOUND, "批次不存在");
        if (Objects.equals(batch.getStatus(), BatchStatusEnum.DISPOSED.getCode())) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "该批次已销毁");
        }
        VaccineBatchDisposal disposal = VaccineBatchDisposal.builder()
                .batchId(batchId)
                .disposalReason(disposalReason != null ? disposalReason : "过期销毁")
                .disposalDate(disposalDate != null ? disposalDate : LocalDate.now())
                .operatorId(operatorId)
                .remark(remark)
                .build();
        vaccineBatchDisposalMapper.insert(disposal);
        batch.setStatus(BatchStatusEnum.DISPOSED.getCode());
        batch.setStock(0);
        updateById(batch);
    }

    @Override
    public List<VaccineBatch> listByStatus(Integer status) {
        if (status == null) return list(new LambdaQueryWrapper<VaccineBatch>().orderByAsc(VaccineBatch::getExpiryDate));
        return list(new LambdaQueryWrapper<VaccineBatch>()
                .eq(VaccineBatch::getStatus, status)
                .orderByAsc(VaccineBatch::getExpiryDate));
    }

    @Override
    public List<VaccineBatch> listWarehouseBatchesForTransfer() {
        return list(new LambdaQueryWrapper<VaccineBatch>()
                .gt(VaccineBatch::getStock, 0)
                .in(VaccineBatch::getStatus, BatchStatusEnum.NORMAL.getCode(), BatchStatusEnum.NEAR_EXPIRY.getCode())
                .gt(VaccineBatch::getExpiryDate, LocalDate.now())
                .orderByAsc(VaccineBatch::getExpiryDate));
    }

    @Override
    public List<VaccineStockVO> listWarehouseStockByVaccine() {
        return vaccineBatchMapper.sumWarehouseStockGroupByVaccine();
    }
}
