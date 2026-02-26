package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.model.entity.DoctorSchedule;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.ScheduleStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.mapper.DoctorScheduleMapper;
import com.tjut.edu.vaccine_system.service.DoctorScheduleService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DoctorScheduleServiceImpl extends ServiceImpl<DoctorScheduleMapper, DoctorSchedule> implements DoctorScheduleService {

    private final SysUserService sysUserService;

    @Override
    public List<DoctorSchedule> listAvailable(Long siteId, LocalDate fromDate, LocalDate toDate) {
        if (siteId == null) return List.of();
        LambdaQueryWrapper<DoctorSchedule> w = new LambdaQueryWrapper<>();
        w.eq(DoctorSchedule::getSiteId, siteId)
                .eq(DoctorSchedule::getStatus, ScheduleStatusEnum.ENABLED.getCode())
                .apply("current_count < max_capacity");
        if (fromDate != null) w.ge(DoctorSchedule::getScheduleDate, fromDate);
        if (toDate != null) w.le(DoctorSchedule::getScheduleDate, toDate);
        w.orderByAsc(DoctorSchedule::getScheduleDate).orderByAsc(DoctorSchedule::getTimeSlot);
        List<DoctorSchedule> list = list(w);
        return filterByDoctorStatus(list);
    }

    @Override
    public List<DoctorSchedule> listBySiteAndDateRange(Long siteId, LocalDate fromDate, LocalDate toDate) {
        if (siteId == null) return List.of();
        LambdaQueryWrapper<DoctorSchedule> w = new LambdaQueryWrapper<>();
        w.eq(DoctorSchedule::getSiteId, siteId)
                .eq(DoctorSchedule::getStatus, ScheduleStatusEnum.ENABLED.getCode());
        if (fromDate != null) w.ge(DoctorSchedule::getScheduleDate, fromDate);
        if (toDate != null) w.le(DoctorSchedule::getScheduleDate, toDate);
        w.orderByAsc(DoctorSchedule::getScheduleDate).orderByAsc(DoctorSchedule::getTimeSlot);
        List<DoctorSchedule> list = list(w);
        return filterByDoctorStatus(list);
    }

    /** 仅保留医生状态为正常的排班（注销/禁用医生的排班不在预约排班中显示、不可选） */
    private List<DoctorSchedule> filterByDoctorStatus(List<DoctorSchedule> list) {
        if (list == null || list.isEmpty()) return list;
        Set<Long> normalDoctorIds = list.stream()
                .map(DoctorSchedule::getDoctorId)
                .distinct()
                .filter(doctorId -> {
                    SysUser user = sysUserService.getById(doctorId);
                    return user != null && Integer.valueOf(UserStatusEnum.NORMAL.getCode()).equals(user.getStatus());
                })
                .collect(Collectors.toSet());
        return list.stream().filter(s -> normalDoctorIds.contains(s.getDoctorId())).collect(Collectors.toList());
    }

    @Override
    public IPage<DoctorSchedule> page(long current, long size, Long doctorId, Long siteId, LocalDate scheduleDate, Integer status) {
        Page<DoctorSchedule> page = new Page<>(current, size);
        LambdaQueryWrapper<DoctorSchedule> w = new LambdaQueryWrapper<>();
        w.eq(doctorId != null, DoctorSchedule::getDoctorId, doctorId)
                .eq(siteId != null, DoctorSchedule::getSiteId, siteId)
                .eq(scheduleDate != null, DoctorSchedule::getScheduleDate, scheduleDate)
                .eq(status != null, DoctorSchedule::getStatus, status)
                .orderByDesc(DoctorSchedule::getScheduleDate)
                .orderByAsc(DoctorSchedule::getTimeSlot);
        return page(page, w);
    }

    @Override
    public boolean incrementCurrentCount(Long scheduleId) {
        if (scheduleId == null) return false;
        DoctorSchedule schedule = getById(scheduleId);
        if (schedule == null) return false;
        if (!ScheduleStatusEnum.isEnabled(schedule.getStatus())) return false;
        if (schedule.getCurrentCount() == null) schedule.setCurrentCount(0);
        if (schedule.getMaxCapacity() == null || schedule.getCurrentCount() >= schedule.getMaxCapacity()) return false;
        boolean ok = update(new LambdaUpdateWrapper<DoctorSchedule>()
                .eq(DoctorSchedule::getId, scheduleId)
                .eq(DoctorSchedule::getStatus, ScheduleStatusEnum.ENABLED.getCode())
                .apply("current_count < max_capacity")
                .setSql("current_count = current_count + 1"));
        return ok;
    }

    @Override
    public boolean decrementCurrentCount(Long scheduleId) {
        if (scheduleId == null) return false;
        DoctorSchedule schedule = getById(scheduleId);
        if (schedule == null) return false;
        if (schedule.getCurrentCount() == null || schedule.getCurrentCount() <= 0) return false;
        return update(new LambdaUpdateWrapper<DoctorSchedule>()
                .eq(DoctorSchedule::getId, scheduleId)
                .apply("current_count > 0")
                .setSql("current_count = current_count - 1"));
    }
}
