package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;

/**
 * 疫苗信息 Service
 */
public interface VaccineService extends IService<Vaccine> {

    /**
     * 分页查询疫苗
     */
    IPage<Vaccine> pageVaccines(long current, long size, String vaccineName, Integer status);

    /**
     * 上架/下架：更新疫苗状态（仅允许 0-下架、1-上架）
     * 下架后已有预约仍有效，但不允许新预约、不显示在用户/接种点可选列表、不可录入接种记录。
     */
    void updateStatus(Long id, Integer status);
}
