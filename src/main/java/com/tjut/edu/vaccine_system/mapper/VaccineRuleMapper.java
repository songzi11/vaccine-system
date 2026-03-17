package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineRule;
import org.apache.ibatis.annotations.Mapper;

/**
 * 疫苗规则 Mapper
 */
@Mapper
public interface VaccineRuleMapper extends BaseMapper<VaccineRule> {
}