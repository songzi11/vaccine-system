package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.entity.VaccineSiteStock;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockVO;
import com.tjut.edu.vaccine_system.mapper.VaccinationSiteMapper;
import com.tjut.edu.vaccine_system.mapper.VaccineSiteStockMapper;
import com.tjut.edu.vaccine_system.service.VaccineService;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 疫苗按接种点库存 Service 实现
 */
@Service
@RequiredArgsConstructor
public class VaccineSiteStockServiceImpl extends ServiceImpl<VaccineSiteStockMapper, VaccineSiteStock> implements VaccineSiteStockService {

    private final VaccineService vaccineService;
    private final VaccinationSiteMapper vaccinationSiteMapper;

    @Override
    public int getAvailableStock(Long vaccineId, Long siteId) {
        if (vaccineId == null || siteId == null) return 0;
        Vaccine vaccine = vaccineService.getById(vaccineId);
        if (vaccine == null || !VaccineStatusEnum.isUp(vaccine.getStatus())) {
            return 0;
        }
        VaccineSiteStock one = getOne(new LambdaQueryWrapper<VaccineSiteStock>()
                .eq(VaccineSiteStock::getVaccineId, vaccineId)
                .eq(VaccineSiteStock::getSiteId, siteId));
        return one != null && one.getStock() != null ? one.getStock() : 0;
    }

    @Override
    public boolean decrementStock(Long vaccineId, Long siteId) {
        if (vaccineId == null || siteId == null) return false;
        // 使用 SQL：UPDATE ... SET stock = stock - 1 WHERE vaccine_id=? AND site_id=? AND stock > 0
        // 防止超卖：仅当 stock>0 时更新，影响行数>0 表示扣减成功
        int rows = baseMapper.decrementStock(vaccineId, siteId);
        return rows > 0;
    }

    @Override
    public List<LowStockVO> listStockWarning() {
        // 查询所有 stock < warning_threshold 的记录（任务书：库存预警监控）
        List<VaccineSiteStock> list = list(new LambdaQueryWrapper<VaccineSiteStock>()
                .apply("stock < warning_threshold")
                .orderByAsc(VaccineSiteStock::getStock));
        return list.stream().map(s -> {
            Vaccine v = vaccineService.getById(s.getVaccineId());
            VaccinationSite site = vaccinationSiteMapper.selectById(s.getSiteId());
            return LowStockVO.builder()
                    .vaccineId(s.getVaccineId())
                    .vaccineName(v != null ? v.getVaccineName() : "")
                    .siteId(s.getSiteId())
                    .siteName(site != null ? site.getSiteName() : "")
                    .stock(s.getStock())
                    .warningThreshold(s.getWarningThreshold())
                    .build();
        }).collect(Collectors.toList());
    }

    @Override
    public List<VaccineSiteStock> listBySiteId(Long siteId) {
        if (siteId == null) return List.of();
        return list(new LambdaQueryWrapper<VaccineSiteStock>()
                .eq(VaccineSiteStock::getSiteId, siteId)
                .orderByAsc(VaccineSiteStock::getVaccineId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addStock(Long siteId, Long vaccineId, int quantity) {
        if (siteId == null || vaccineId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "接种点ID和疫苗ID不能为空");
        if (quantity <= 0) throw new BizException(BizErrorCode.BAD_REQUEST, "增加数量必须大于0");
        VaccineSiteStock one = getOne(new LambdaQueryWrapper<VaccineSiteStock>()
                .eq(VaccineSiteStock::getSiteId, siteId)
                .eq(VaccineSiteStock::getVaccineId, vaccineId));
        if (one == null) {
            one = VaccineSiteStock.builder()
                    .siteId(siteId)
                    .vaccineId(vaccineId)
                    .stock(0)
                    .warningThreshold(10)
                    .build();
            save(one);
        }
        int rows = baseMapper.incrementStock(vaccineId, siteId, quantity);
        if (rows == 0) throw new BizException(BizErrorCode.BAD_REQUEST, "增加库存失败");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reduceStock(Long siteId, Long vaccineId, int quantity) {
        if (siteId == null || vaccineId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "接种点ID和疫苗ID不能为空");
        if (quantity <= 0) throw new BizException(BizErrorCode.BAD_REQUEST, "减少数量必须大于0");
        int rows = baseMapper.reduceStock(vaccineId, siteId, quantity);
        if (rows == 0) throw new BizException(BizErrorCode.STOCK_INSUFFICIENT, "库存不足或记录不存在");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateWarningThreshold(Long stockId, Integer warningThreshold) {
        if (stockId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "库存记录ID不能为空");
        VaccineSiteStock one = getById(stockId);
        if (one == null) throw new BizException(BizErrorCode.NOT_FOUND, "库存记录不存在");
        one.setWarningThreshold(warningThreshold != null ? warningThreshold : 0);
        updateById(one);
    }

    @Override
    public List<SiteStockVO> listSiteStockVOBySiteId(Long siteId) {
        List<VaccineSiteStock> list = listBySiteId(siteId);
        return list.stream().map(s -> {
            Vaccine v = vaccineService.getById(s.getVaccineId());
            if (v == null || !VaccineStatusEnum.isUp(v.getStatus())) return null;
            return SiteStockVO.builder()
                    .id(s.getId())
                    .siteId(s.getSiteId())
                    .vaccineId(s.getVaccineId())
                    .vaccineName(v.getVaccineName())
                    .quantity(s.getStock())
                    .warningThreshold(s.getWarningThreshold())
                    .build();
        }).filter(vo -> vo != null).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setStockQuantity(Long stockId, Integer quantity) {
        if (stockId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "库存记录ID不能为空");
        VaccineSiteStock one = getById(stockId);
        if (one == null) throw new BizException(BizErrorCode.NOT_FOUND, "库存记录不存在");
        one.setStock(quantity != null && quantity >= 0 ? quantity : 0);
        updateById(one);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void removeStock(Long siteId, Long stockId) {
        if (siteId == null || stockId == null) throw new BizException(BizErrorCode.BAD_REQUEST, "接种点ID和库存记录ID不能为空");
        VaccineSiteStock one = getById(stockId);
        if (one == null) throw new BizException(BizErrorCode.NOT_FOUND, "库存记录不存在");
        if (!siteId.equals(one.getSiteId())) throw new BizException(BizErrorCode.BAD_REQUEST, "该库存记录不属于当前接种点");
        removeById(stockId);
    }
}
