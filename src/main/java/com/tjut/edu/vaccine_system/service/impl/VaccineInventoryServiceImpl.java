package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.model.entity.VaccineInventory;
import com.tjut.edu.vaccine_system.mapper.VaccineInventoryMapper;
import com.tjut.edu.vaccine_system.service.VaccineInventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 疫苗批次库存 Service 实现
 */
@Service
@RequiredArgsConstructor
public class VaccineInventoryServiceImpl extends ServiceImpl<VaccineInventoryMapper, VaccineInventory> implements VaccineInventoryService {

    private static final int STATUS_VALID = 1;

    @Override
    public List<VaccineInventory> listByVaccineNameLike(String vaccineNameLike) {
        if (vaccineNameLike == null || vaccineNameLike.isBlank()) return List.of();
        return baseMapper.listByVaccineNameLikeAndStatus(vaccineNameLike, STATUS_VALID);
    }

    @Override
    public List<VaccineInventory> listExpiringWithinDays(int withinDays) {
        return baseMapper.listExpiringWithinDays(withinDays, STATUS_VALID);
    }
}
