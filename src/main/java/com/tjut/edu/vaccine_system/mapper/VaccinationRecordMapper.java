package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * 接种记录 Mapper
 */
@Mapper
public interface VaccinationRecordMapper extends BaseMapper<VaccinationRecord> {
}
