package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.Record;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 接种记录 Mapper（record 表）
 */
@Mapper
public interface RecordMapper extends BaseMapper<Record> {

    /**
     * 今日接种人数（record 表，未逻辑删除）
     */
    Long countToday();

    /**
     * 各疫苗接种次数（group by vaccine_id）
     */
    List<Map<String, Object>> countByVaccine();

    /**
     * 近7天每日接种数（group by date）
     */
    List<Map<String, Object>> countLast7Days();
}
