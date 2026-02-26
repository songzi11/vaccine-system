package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.Record;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.model.dto.RegisterDTO;
import com.tjut.edu.vaccine_system.model.vo.*;
import com.tjut.edu.vaccine_system.mapper.SysUserMapper;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 系统用户 Service 实现（明文密码、用户状态枚举、注销/禁用/恢复）
 */
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    private final ChildProfileService childProfileService;
    private final AppointmentService appointmentService;
    private final RecordService recordService;
    private final VaccinationSiteService vaccinationSiteService;

    public SysUserServiceImpl(ChildProfileService childProfileService,
                              @Lazy AppointmentService appointmentService, @Lazy RecordService recordService,
                              @Lazy VaccinationSiteService vaccinationSiteService) {
        this.childProfileService = childProfileService;
        this.appointmentService = appointmentService;
        this.recordService = recordService;
        this.vaccinationSiteService = vaccinationSiteService;
    }

    @Override
    public Optional<SysUser> login(String username, String password) {
        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            return Optional.empty();
        }
        SysUser user = getOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username.trim()));
        if (user == null) {
            return Optional.empty();
        }
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(user.getStatus());
        if (statusEnum == null || !statusEnum.canLogin()) {
            return Optional.empty();
        }
        String raw = password.trim();
        String dbPwd = user.getPassword();
        if (dbPwd == null || !raw.equals(dbPwd)) {
            return Optional.empty();
        }
        // 更新最后登录时间
        update(new LambdaUpdateWrapper<SysUser>()
                .eq(SysUser::getId, user.getId())
                .set(SysUser::getLastLoginTime, LocalDateTime.now()));
        user.setLastLoginTime(LocalDateTime.now());
        return Optional.of(user);
    }

    @Override
    public boolean isUsernameValid(String username) {
        if (!StringUtils.hasText(username)) return false;
        SysUser user = getOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username.trim()));
        if (user == null) return false;
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(user.getStatus());
        return statusEnum != null && statusEnum.canLogin();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SysUser register(RegisterDTO dto) {
        String username = dto.getUsername() != null ? dto.getUsername().trim() : "";
        if (!StringUtils.hasText(username)) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "用户名不能为空");
        }
        Long existingId = baseMapper.selectIdByUsernameAny(username);
        if (existingId != null) {
            throw new BizException(BizErrorCode.USERNAME_TAKEN);
        }
        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(dto.getPassword() != null ? dto.getPassword().trim() : "");
        user.setRole(dto.getRole() != null ? dto.getRole().trim().toUpperCase() : "RESIDENT");
        user.setRealName(StringUtils.hasText(dto.getRealName()) ? dto.getRealName().trim() : null);
        user.setPhone(StringUtils.hasText(dto.getPhone()) ? dto.getPhone().trim() : null);
        user.setAddress(StringUtils.hasText(dto.getAddress()) ? dto.getAddress().trim() : null);
        user.setStatus(UserStatusEnum.NORMAL.getCode());
        save(user);
        return getById(user.getId());
    }

    @Override
    public UserListVO getUserListVO(Long id) {
        SysUser u = getById(id);
        return u == null ? null : toUserListVO(u);
    }

    @Override
    public IPage<UserListVO> pageUserVOs(long current, long size, String username, String role, Integer status) {
        Page<SysUser> page = new Page<>(current, size);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(username), SysUser::getUsername, username)
                .eq(StringUtils.hasText(role), SysUser::getRole, role)
                .eq(status != null, SysUser::getStatus, status)
                .ne(SysUser::getStatus, UserStatusEnum.DEACTIVATED.getCode())
                .orderByDesc(SysUser::getCreateTime);
        IPage<SysUser> result = page(page, wrapper);
        List<UserListVO> voList = result.getRecords().stream()
                .map(this::toUserListVO)
                .collect(Collectors.toList());
        Page<UserListVO> voPage = new Page<>(result.getCurrent(), result.getSize(), result.getTotal());
        voPage.setRecords(voList);
        return voPage;
    }

    private UserListVO toUserListVO(SysUser u) {
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(u.getStatus());
        return UserListVO.builder()
                .id(u.getId())
                .username(u.getUsername())
                .realName(u.getRealName())
                .role(u.getRole())
                .gender(u.getGender())
                .phone(u.getPhone())
                .idCard(u.getIdCard())
                .address(u.getAddress())
                .avatar(u.getAvatar())
                .status(u.getStatus())
                .statusLabel(statusEnum != null ? statusEnum.getDesc() : String.valueOf(u.getStatus()))
                .createTime(u.getCreateTime())
                .lastLoginTime(u.getLastLoginTime())
                .updateTime(u.getUpdateTime())
                .build();
    }

    @Override
    public UserDetailVO getUserDetail(Long userId) {
        SysUser user = getById(userId);
        if (user == null) return null;
        UserDetailVO vo = UserDetailVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .realName(user.getRealName())
                .role(user.getRole())
                .gender(user.getGender())
                .phone(user.getPhone())
                .idCard(user.getIdCard())
                .address(user.getAddress())
                .avatar(user.getAvatar())
                .status(user.getStatus())
                .statusLabel(UserStatusEnum.fromCode(user.getStatus()) != null ? UserStatusEnum.fromCode(user.getStatus()).getDesc() : "")
                .createTime(user.getCreateTime())
                .lastLoginTime(user.getLastLoginTime())
                .updateTime(user.getUpdateTime())
                .build();
        String role = user.getRole() != null ? user.getRole().toUpperCase() : "";
        if ("RESIDENT".equals(role) || "USER".equals(role)) {
            List<ChildProfile> children = childProfileService.list(new LambdaQueryWrapper<ChildProfile>().eq(ChildProfile::getParentId, userId));
            vo.setChildList(children.stream().map(this::toChildSimpleVO).collect(Collectors.toList()));
            IPage<Appointment> appPage = appointmentService.pageAppointments(1, 100, userId, null, null, null, null, null);
            vo.setAppointmentList(appPage.getRecords().stream().map(this::toAppointmentSimpleVO).collect(Collectors.toList()));
            List<Record> records = recordService.listByUserId(userId);
            vo.setRecordList(records.stream().map(this::toRecordSimpleVO).collect(Collectors.toList()));
        }
        if ("DOCTOR".equals(role)) {
            List<Appointment> byDoctor = appointmentService.listByDoctorId(userId);
            vo.setScheduleList(byDoctor.stream().map(this::toAppointmentSimpleVO).collect(Collectors.toList()));
            vo.setTodayAppointmentCount(appointmentService.countTodayByDoctorId(userId));
            vo.setHistoryRecordCount(recordService.countByDoctorId(userId));
        }
        return vo;
    }

    private ChildProfileSimpleVO toChildSimpleVO(ChildProfile c) {
        return ChildProfileSimpleVO.builder()
                .id(c.getId())
                .parentId(c.getParentId())
                .name(c.getName())
                .birthDate(c.getBirthDate())
                .gender(c.getGender())
                .contraindicationAllergy(c.getContraindicationAllergy())
                .vaccinationCardNo(c.getVaccinationCardNo())
                .createTime(c.getCreateTime())
                .updateTime(c.getUpdateTime())
                .build();
    }

    private AppointmentSimpleVO toAppointmentSimpleVO(Appointment a) {
        AppointmentStatusEnum statusEnum = AppointmentStatusEnum.fromCode(a.getStatus());
        return AppointmentSimpleVO.builder()
                .id(a.getId())
                .userId(a.getUserId())
                .childId(a.getChildId())
                .vaccineId(a.getVaccineId())
                .siteId(a.getSiteId())
                .appointmentDate(a.getAppointmentDate())
                .timeSlot(a.getTimeSlot())
                .status(a.getStatus())
                .statusLabel(statusEnum != null ? statusEnum.getDesc() : String.valueOf(a.getStatus()))
                .doctorId(a.getDoctorId())
                .remark(a.getRemark())
                .createTime(a.getCreateTime())
                .updateTime(a.getUpdateTime())
                .build();
    }

    private RecordSimpleVO toRecordSimpleVO(Record r) {
        return RecordSimpleVO.builder()
                .id(r.getId())
                .orderId(r.getOrderId())
                .userId(r.getUserId())
                .childId(r.getChildId())
                .vaccineId(r.getVaccineId())
                .doctorId(r.getDoctorId())
                .siteId(r.getSiteId())
                .vaccinateTime(r.getVaccinateTime())
                .status(r.getStatus())
                .remark(r.getRemark())
                .createTime(r.getCreateTime())
                .build();
    }

    @Override
    public void verifyAdminPassword(Long adminUserId, String adminPassword) {
        if (adminUserId == null || !StringUtils.hasText(adminPassword)) {
            throw new BizException(BizErrorCode.ADMIN_PASSWORD_WRONG);
        }
        SysUser admin = getById(adminUserId);
        if (admin == null) {
            throw new BizException(BizErrorCode.ADMIN_PASSWORD_WRONG);
        }
        if (!"ADMIN".equals(admin.getRole())) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "仅管理员可执行此操作，请使用管理员账号");
        }
        String dbPwd = admin.getPassword();
        if (dbPwd == null || !adminPassword.trim().equals(dbPwd)) {
            throw new BizException(BizErrorCode.ADMIN_PASSWORD_WRONG);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deactivateUser(Long targetUserId, Long adminUserId, String adminPassword) {
        verifyAdminPassword(adminUserId, adminPassword);
        SysUser target = getById(targetUserId);
        if (target == null) {
            throw new BizException(BizErrorCode.NOT_FOUND.getCode(), "用户不存在");
        }
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(target.getStatus());
        if (statusEnum == UserStatusEnum.DEACTIVATED) {
            throw new BizException(BizErrorCode.USER_ALREADY_DEACTIVATED);
        }
        target.setStatus(UserStatusEnum.DEACTIVATED.getCode());
        updateById(target);
        // 医生账户注销后，其作为驻场医生的接种点自动转为禁用并清空驻场医生
        if ("DOCTOR".equals(target.getRole())) {
            vaccinationSiteService.disableSitesByResidentDoctorId(targetUserId);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void disableUser(Long userId) {
        SysUser user = getById(userId);
        if (user == null) throw new BizException(BizErrorCode.NOT_FOUND.getCode(), "用户不存在");
        if (user.getStatus() != null && user.getStatus() == UserStatusEnum.DEACTIVATED.getCode()) {
            throw new BizException(BizErrorCode.USER_ALREADY_DEACTIVATED);
        }
        user.setStatus(UserStatusEnum.DISABLED.getCode());
        updateById(user);
        // 医生账户禁用后，其作为驻场医生的接种点自动转为禁用并清空驻场医生
        if ("DOCTOR".equals(user.getRole())) {
            vaccinationSiteService.disableSitesByResidentDoctorId(userId);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enableUser(Long userId) {
        SysUser user = getById(userId);
        if (user == null) throw new BizException(BizErrorCode.NOT_FOUND.getCode(), "用户不存在");
        if (user.getStatus() != null && user.getStatus() == UserStatusEnum.DEACTIVATED.getCode()) {
            throw new BizException(BizErrorCode.USER_ALREADY_DEACTIVATED);
        }
        user.setStatus(UserStatusEnum.NORMAL.getCode());
        updateById(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveOrUpdateUser(SysUser user) {
        if (user == null) return;
        if (StringUtils.hasText(user.getPassword())) {
            user.setPassword(user.getPassword().trim());
        }
        if (StringUtils.hasText(user.getUsername())) {
            Long existingId = baseMapper.selectIdByUsernameAny(user.getUsername().trim());
            if (existingId != null && !existingId.equals(user.getId())) {
                throw new BizException(BizErrorCode.USERNAME_TAKEN);
            }
        }
        saveOrUpdate(user);
    }
}
