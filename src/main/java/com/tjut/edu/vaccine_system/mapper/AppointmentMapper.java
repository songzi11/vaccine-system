package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import org.apache.ibatis.annotations.Mapper;

/**
 * 预约接种 Mapper
 */
@Mapper
public interface AppointmentMapper extends BaseMapper<Appointment> {
}
