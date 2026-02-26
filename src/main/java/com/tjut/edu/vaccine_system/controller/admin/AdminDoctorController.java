package com.tjut.edu.vaccine_system.controller.admin;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.AppointmentSimpleVO;
import com.tjut.edu.vaccine_system.model.vo.DoctorStatsVO;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 管理员-医生账号统计
 */
@RestController
@RequestMapping("/admin/doctor")
@RequiredArgsConstructor
@Tag(name = "管理员-医生统计")
public class AdminDoctorController {

    private final SysUserService sysUserService;
    private final AppointmentService appointmentService;
    private final RecordService recordService;

    @Operation(summary = "医生账号统计（排班、今日预约数、历史接种数）")
    @GetMapping("/{id}/stats")
    public Result<DoctorStatsVO> stats(@PathVariable Long id) {
        SysUser user = sysUserService.getById(id);
        if (user == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        if (!"DOCTOR".equalsIgnoreCase(user.getRole())) {
            return Result.fail(400, "该用户不是医生账号");
        }
        List<Appointment> scheduleList = appointmentService.listByDoctorId(id);
        List<AppointmentSimpleVO> scheduleVO = scheduleList.stream()
                .map(a -> AppointmentSimpleVO.builder()
                        .id(a.getId())
                        .userId(a.getUserId())
                        .childId(a.getChildId())
                        .vaccineId(a.getVaccineId())
                        .siteId(a.getSiteId())
                        .appointmentDate(a.getAppointmentDate())
                        .timeSlot(a.getTimeSlot())
                        .status(a.getStatus())
                        .statusLabel(com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum.fromCode(a.getStatus()) != null
                                ? com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum.fromCode(a.getStatus()).getDesc() : "")
                        .doctorId(a.getDoctorId())
                        .remark(a.getRemark())
                        .createTime(a.getCreateTime())
                        .updateTime(a.getUpdateTime())
                        .build())
                .collect(Collectors.toList());
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(user.getStatus());
        DoctorStatsVO vo = DoctorStatsVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .realName(user.getRealName())
                .role(user.getRole())
                .status(user.getStatus())
                .statusLabel(statusEnum != null ? statusEnum.getDesc() : "")
                .createTime(user.getCreateTime())
                .lastLoginTime(user.getLastLoginTime())
                .scheduleList(scheduleVO)
                .todayAppointmentCount(appointmentService.countTodayByDoctorId(id))
                .historyRecordCount(recordService.countByDoctorId(id))
                .build();
        return Result.ok(vo);
    }
}
