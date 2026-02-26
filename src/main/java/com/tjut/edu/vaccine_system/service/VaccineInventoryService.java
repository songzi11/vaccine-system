package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.VaccineInventory;

import java.util.List;

/**
 * 疫苗批次库存 Service（效期与剩余量监测）
 */
public interface VaccineInventoryService extends IService<VaccineInventory> {

    /**
     * 按疫苗名称模糊查询有效批次（用于百白破等剩余率预警）
     */
    List<VaccineInventory> listByVaccineNameLike(String vaccineNameLike);

    /**
     * 查询效期在指定天数内的批次（效期临近预警）
     */
    List<VaccineInventory> listExpiringWithinDays(int withinDays);
}
