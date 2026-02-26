package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.AdverseReaction;
import org.apache.ibatis.annotations.Mapper;

/**
 * 不良反应上报 Mapper
 */
@Mapper
public interface AdverseReactionMapper extends BaseMapper<AdverseReaction> {
}
