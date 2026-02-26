package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理员-预约列表（排班先行：家长选排班预约，无管理员排期流程）
 */
@RestController
@RequestMapping(value = {"/admin/appointment", "/api/admin/appointment"})
@RequiredArgsConstructor
@Tag(name = "管理员-预约列表")
public class AdminAppointmentController {

    private final AppointmentService appointmentService;
    private final ChildProfileService childProfileService;
    private final SysUserService sysUserService;

    @Operation(summary = "预约列表（管理员，可查全部，status：1已预约 6已签到 7预检通过 9预检未通过 10留观中 2已完成 3已取消 4已过期）")
    @GetMapping(value = {"/page", "/appointments"})
    public Result<PageResult<Appointment>> listAppointments(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long siteId) {
        IPage<Appointment> page = appointmentService.pageAppointments(current, size, userId, null, siteId, status, null, null);
        return Results.page(page);
    }

    @Operation(summary = "儿童档案列表（管理员查看所有宝宝）")
    @GetMapping("/children")
    public Result<PageResult<ChildProfile>> listChildren(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) Long parentId) {
        IPage<ChildProfile> page = childProfileService.pageProfiles(current, size, parentId);
        return Results.page(page);
    }

    @Operation(summary = "医生列表（用于排班选择等，仅返回状态为正常的医生）")
    @GetMapping("/doctors")
    public Result<List<SysUser>> listDoctors() {
        List<SysUser> list = sysUserService.lambdaQuery()
                .eq(SysUser::getRole, "DOCTOR")
                .eq(SysUser::getStatus, UserStatusEnum.NORMAL.getCode())
                .list();
        list.forEach(u -> u.setPassword(null));
        return Result.ok(list);
    }
}
