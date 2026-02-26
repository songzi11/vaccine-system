package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import org.apache.ibatis.annotations.Mapper;

/**
 * 疫苗信息 Mapper
 */
@Mapper
public interface VaccineMapper extends BaseMapper<Vaccine> {
}
