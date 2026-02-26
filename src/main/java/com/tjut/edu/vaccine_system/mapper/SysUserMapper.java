package com.tjut.edu.vaccine_system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 系统用户 Mapper
 */
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {

    /** 按用户名查询ID（含已注销/逻辑删除，用于注册与添加用户时校验用户名不可复用） */
    @Select("SELECT id FROM sys_user WHERE username = #{username} LIMIT 1")
    Long selectIdByUsernameAny(@Param("username") String username);
}
