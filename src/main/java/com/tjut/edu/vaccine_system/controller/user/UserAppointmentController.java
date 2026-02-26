package com.tjut.edu.vaccine_system.controller.user;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.CreateAppointmentDTO;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.DoctorSchedule;
import com.tjut.edu.vaccine_system.model.vo.AppointmentListVO;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.DoctorScheduleService;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * 用户端-预约（排班先行：选排班→创建预约，状态=已预约）
 */
@RestController
@RequestMapping(value = {"/user/appointment", "/order", "/api/appointment"})
@RequiredArgsConstructor
@Tag(name = "用户-预约")
public class UserAppointmentController {

    private final AppointmentService appointmentService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final DoctorScheduleService doctorScheduleService;

    @Operation(summary = "某接种点驻场医生排班列表（仅未来30天内；含已约满时段，前端用 currentCount>=maxCapacity 显示已约不可选）")
    @GetMapping("/schedules")
    public Result<List<DoctorSchedule>> listSchedules(
            @RequestParam Long siteId,
            @RequestParam(required = false) LocalDate fromDate,
            @RequestParam(required = false) LocalDate toDate) {
        if (fromDate == null) fromDate = LocalDate.now();
        if (toDate == null) toDate = fromDate.plusDays(30);
        LocalDate maxEnd = fromDate.plusDays(30);
        if (toDate.isAfter(maxEnd)) toDate = maxEnd;
        List<DoctorSchedule> list = doctorScheduleService.listBySiteAndDateRange(siteId, fromDate, toDate);
        return Result.ok(list);
    }

    @Operation(summary = "查询某疫苗在某接种点的可用库存（预约前校验用，与预约创建时按批次 FEFO 一致）")
    @GetMapping("/stock")
    public Result<Integer> getStock(@RequestParam Long vaccineId, @RequestParam Long siteId) {
        int stock = siteVaccineStockService.getAvailableStock(vaccineId, siteId);
        return Result.ok(stock);
    }

    @Operation(summary = "创建预约（智能检查：年龄/禁忌症/间隔/防重复/库存）")
    @PostMapping(value = {"", "/create"})
    public Result<Appointment> create(@Valid @RequestBody CreateAppointmentDTO dto) {
        Appointment appointment = appointmentService.createOrderWithStockCheck(dto);
        return Result.ok("预约成功", appointment);
    }

    @Operation(summary = "分页查询我的预约（支持按宝宝childId、状态分类statusType：all|pending|approved|rejected|ended，返回疫苗名/宝宝名/接种点名）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<AppointmentListVO>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long childId,
            @RequestParam(required = false) String statusType,
            @RequestParam(required = false) Long vaccineId,
            @RequestParam(required = false) Long siteId) {
        IPage<AppointmentListVO> page = appointmentService.pageForUser(current, size, userId, childId, statusType);
        return Results.page(page);
    }

    @Operation(summary = "预约详情")
    @GetMapping("/{id}")
    public Result<Appointment> getById(@PathVariable Long id) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment == null) {
            return Result.fail(404, "预约不存在");
        }
        return Result.ok(appointment);
    }

    @Operation(summary = "用户取消预约（任意时刻可取消未完成/未过期的预约，已预约状态会回退排班名额）")
    @PostMapping(value = {"/{id}/cancel", "/cancel/{id}"})
    public Result<Void> cancel(@PathVariable Long id, @RequestParam(required = false) Long userId) {
        appointmentService.cancelByUser(id, userId);
        return Result.ok("已取消预约");
    }
}
