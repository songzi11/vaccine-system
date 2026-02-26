package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.DoctorSchedule;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.vo.DoctorScheduleListVO;
import com.tjut.edu.vaccine_system.service.DoctorScheduleService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 管理员-医生排班（排班先行）
 */
@RestController
@RequestMapping(value = {"/admin/doctor-schedule", "/api/admin/doctor-schedule"})
@RequiredArgsConstructor
@Tag(name = "管理员-医生排班")
public class AdminDoctorScheduleController {

    private final DoctorScheduleService doctorScheduleService;
    private final SysUserService sysUserService;

    @Operation(summary = "分页查询排班（含医生状态，注销/禁用医生的排班不显示操作按钮）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<DoctorScheduleListVO>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) Long doctorId,
            @RequestParam(required = false) Long siteId,
            @RequestParam(required = false) LocalDate scheduleDate,
            @RequestParam(required = false) Integer status) {
        IPage<DoctorSchedule> page = doctorScheduleService.page(current, size, doctorId, siteId, scheduleDate, status);
        List<DoctorScheduleListVO> voList = page.getRecords().stream()
                .map(s -> toListVO(s))
                .collect(Collectors.toList());
        return Results.page(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    private DoctorScheduleListVO toListVO(DoctorSchedule s) {
        Integer doctorStatus = null;
        if (s.getDoctorId() != null) {
            SysUser user = sysUserService.getById(s.getDoctorId());
            doctorStatus = user != null && user.getStatus() != null ? user.getStatus() : 2;
        } else {
            doctorStatus = 2;
        }
        return DoctorScheduleListVO.builder()
                .id(s.getId())
                .doctorId(s.getDoctorId())
                .siteId(s.getSiteId())
                .scheduleDate(s.getScheduleDate())
                .timeSlot(s.getTimeSlot())
                .maxCapacity(s.getMaxCapacity())
                .currentCount(s.getCurrentCount())
                .status(s.getStatus())
                .createTime(s.getCreateTime())
                .updateTime(s.getUpdateTime())
                .doctorStatus(doctorStatus)
                .build();
    }

    @Operation(summary = "排班详情")
    @GetMapping("/{id}")
    public Result<DoctorSchedule> getById(@PathVariable Long id) {
        DoctorSchedule one = doctorScheduleService.getById(id);
        return one != null ? Result.ok(one) : Result.fail(404, "排班不存在");
    }

    @Operation(summary = "新增排班")
    @PostMapping
    public Result<DoctorSchedule> save(@RequestBody DoctorSchedule entity) {
        if (entity.getCurrentCount() == null) entity.setCurrentCount(0);
        if (entity.getStatus() == null) entity.setStatus(1);
        doctorScheduleService.save(entity);
        return Result.ok("新增成功", doctorScheduleService.getById(entity.getId()));
    }

    @Operation(summary = "更新排班")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody DoctorSchedule entity) {
        entity.setId(id);
        doctorScheduleService.updateById(entity);
        return Result.ok();
    }

    @Operation(summary = "删除排班")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        doctorScheduleService.removeById(id);
        return Result.ok();
    }
}
