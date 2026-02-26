package com.tjut.edu.vaccine_system.controller.doctor;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.vo.DoctorAppointmentDetailVO;
import com.tjut.edu.vaccine_system.model.vo.RecordVO;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * 医生-待接种（今日+未来三个月）、预约详情（宝宝/家长/过往接种）
 */
@RestController
@RequestMapping(value = {"/doctor/appointment", "/api/doctor/appointment", "/api/doctor/appointments"})
@RequiredArgsConstructor
@Tag(name = "医生-预约与档案")
public class DoctorAppointmentController {

    private static final int FUTURE_MONTHS = 3;

    private final AppointmentService appointmentService;
    private final ChildProfileService childProfileService;
    private final SysUserService sysUserService;
    private final RecordService recordService;
    private final VaccineService vaccineService;
    private final VaccinationSiteService vaccinationSiteService;

    @Operation(summary = "今日已预约列表（status=1 且 appointmentDate=今日，供待接种-今日）")
    @GetMapping(value = {"", "/", "/scheduled"})
    public Result<PageResult<Appointment>> listScheduled(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) Long siteId,
            @RequestParam(required = false) Long doctorId) {
        IPage<Appointment> page = appointmentService.pageTodayScheduled(current, size, siteId, doctorId);
        return Results.page(page);
    }

    @Operation(summary = "未来三个月已预约列表（status=1 且 明日起至三个月内，供待接种-未来三个月）")
    @GetMapping("/scheduled/future")
    public Result<PageResult<Appointment>> listScheduledFuture(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) Long siteId,
            @RequestParam(required = false) Long doctorId) {
        LocalDate from = LocalDate.now().plusDays(1);
        LocalDate to = LocalDate.now().plusMonths(FUTURE_MONTHS);
        IPage<Appointment> page = appointmentService.pageFutureScheduled(current, size, siteId, doctorId, from, to);
        return Results.page(page);
    }

    @Operation(summary = "待接种预约详情（含宝宝档案、所属家长、该宝宝过往接种记录）")
    @GetMapping("/scheduled/detail/{id}")
    public Result<DoctorAppointmentDetailVO> getScheduledDetail(@PathVariable Long id) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment == null || !Integer.valueOf(1).equals(appointment.getStatus())) {
            return Result.fail(ResultCode.NOT_FOUND.getCode(), "预约不存在或非已预约状态");
        }
        ChildProfile child = appointment.getChildId() != null ? childProfileService.getById(appointment.getChildId()) : null;
        SysUser parent = appointment.getUserId() != null ? sysUserService.getById(appointment.getUserId()) : null;
        List<RecordVO> pastRecords = child != null ? recordService.listByChildIdWithNames(child.getId()) : List.of();
        Vaccine vaccine = appointment.getVaccineId() != null ? vaccineService.getById(appointment.getVaccineId()) : null;
        VaccinationSite site = appointment.getSiteId() != null ? vaccinationSiteService.getById(appointment.getSiteId()) : null;
        DoctorAppointmentDetailVO vo = DoctorAppointmentDetailVO.builder()
                .appointment(appointment)
                .child(child)
                .parentName(parent != null ? parent.getRealName() : null)
                .parentPhone(parent != null ? parent.getPhone() : null)
                .vaccineName(vaccine != null ? vaccine.getVaccineName() : null)
                .siteName(site != null ? site.getSiteName() : null)
                .pastRecords(pastRecords)
                .build();
        return Result.ok(vo);
    }

    @Operation(summary = "查看宝宝健康档案")
    @GetMapping("/child/{id}")
    public Result<ChildProfile> getChild(@PathVariable Long id) {
        ChildProfile child = childProfileService.getById(id);
        if (child == null) {
            return Result.fail(ResultCode.NOT_FOUND.getCode(), "儿童档案不存在");
        }
        return Result.ok(child);
    }
}
