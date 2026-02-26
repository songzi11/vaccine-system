package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatchDisposal;
import org.apache.ibatis.annotations.Mapper;

/**
 * 疫苗批次销毁记录 Mapper
 */
@Mapper
public interface VaccineBatchDisposalMapper extends BaseMapper<VaccineBatchDisposal> {
}
