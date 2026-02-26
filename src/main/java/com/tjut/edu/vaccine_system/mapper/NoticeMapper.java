package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.Notice;
import org.apache.ibatis.annotations.Mapper;

/**
 * 通知公告 Mapper
 */
@Mapper
public interface NoticeMapper extends BaseMapper<Notice> {
}
