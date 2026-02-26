package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineInventory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 疫苗批次库存 Mapper（效期与剩余量监测）
 */
@Mapper
public interface VaccineInventoryMapper extends BaseMapper<VaccineInventory> {

    /**
     * 查询某疫苗名称（模糊）下的有效批次，用于剩余率预警
     */
    List<VaccineInventory> listByVaccineNameLikeAndStatus(
            @Param("vaccineNameLike") String vaccineNameLike,
            @Param("status") Integer status);

    /**
     * 查询效期在指定天数内的批次（效期临近预警）
     */
    List<VaccineInventory> listExpiringWithinDays(@Param("withinDays") int withinDays, @Param("status") Integer status);
}
