package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineSiteStock;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 疫苗按接种点库存 Mapper
 */
@Mapper
public interface VaccineSiteStockMapper extends BaseMapper<VaccineSiteStock> {

    /**
     * 扣减库存（stock = stock - 1），仅当 stock > 0 时更新，返回影响行数
     */
    int decrementStock(@Param("vaccineId") Long vaccineId, @Param("siteId") Long siteId);

    /**
     * 增加库存（stock = stock + quantity），返回影响行数
     */
    int incrementStock(@Param("vaccineId") Long vaccineId, @Param("siteId") Long siteId, @Param("quantity") int quantity);

    /**
     * 减少库存（stock = stock - quantity），仅当 stock >= quantity 时更新，返回影响行数
     */
    int reduceStock(@Param("vaccineId") Long vaccineId, @Param("siteId") Long siteId, @Param("quantity") int quantity);
}
