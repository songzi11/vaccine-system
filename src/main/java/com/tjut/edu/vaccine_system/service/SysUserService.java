package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.vo.UserDetailVO;
import com.tjut.edu.vaccine_system.model.vo.UserListVO;

import java.util.Optional;

/**
 * 系统用户 Service
 */
public interface SysUserService extends IService<SysUser> {

    /**
     * 登录：根据用户名和密码校验，成功返回用户信息（仅 status=正常 可登录）
     */
    Optional<SysUser> login(String username, String password);

    /**
     * 校验用户名是否存在且为正常状态（用于登录页实时提示）
     */
    boolean isUsernameValid(String username);

    /**
     * 注册：角色为家长/医生/管理员；被注销过的用户名不能再次使用
     */
    SysUser register(com.tjut.edu.vaccine_system.model.dto.RegisterDTO dto);

    /**
     * 分页查询用户（返回 VO，含状态标签、创建时间、最后登录时间）
     */
    IPage<UserListVO> pageUserVOs(long current, long size, String username, String role, Integer status);

    /**
     * 根据 ID 获取用户列表项 VO（含状态标签等）
     */
    UserListVO getUserListVO(Long id);

    /**
     * 用户详情（含关联儿童、预约、接种记录等，用于管理员深度管理）
     */
    UserDetailVO getUserDetail(Long userId);

    /**
     * 校验管理员登录密码（用于二次验证，如指派医生、注销用户等）
     *
     * @param adminUserId  当前管理员用户 ID
     * @param adminPassword 管理员当前登录密码
     * @throws com.tjut.edu.vaccine_system.common.exception.BizException 密码错误时抛出 ADMIN_PASSWORD_WRONG
     */
    void verifyAdminPassword(Long adminUserId, String adminPassword);

    /**
     * 管理员注销用户：校验管理员密码，状态改为已注销，不可恢复
     *
     * @param targetUserId 被注销用户 ID
     * @param adminUserId  当前管理员用户 ID（请求头或上下文）
     * @param adminPassword 管理员当前登录密码
     */
    void deactivateUser(Long targetUserId, Long adminUserId, String adminPassword);

    /**
     * 管理员禁用用户：status=已禁用，可恢复
     */
    void disableUser(Long userId);

    /**
     * 管理员恢复用户：status=正常（仅对已禁用有效，已注销不可恢复）
     */
    void enableUser(Long userId);

    /**
     * 保存或更新用户（密码明文存储）
     */
    void saveOrUpdateUser(SysUser user);
}
