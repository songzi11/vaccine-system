package com.tjut.edu.vaccine_system.controller.doctor;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.dto.ObservationExtendDTO;
import com.tjut.edu.vaccine_system.model.dto.ObservationExceptionDTO;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.ObservationChildVO;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * 医生-留观管理：查看留观中儿童、延长留观、终止留观、异常处理
 */
@RestController
@RequestMapping(value = {"/doctor/observation", "/api/doctor/observation"})
@RequiredArgsConstructor
@Tag(name = "医生-留观管理")
public class DoctorObservationController {

    private final AppointmentService appointmentService;
    private final ChildProfileService childProfileService;
    private final VaccineService vaccineService;

    @Operation(summary = "获取当日留观中儿童列表（含剩余留观时长）")
    @GetMapping("/today")
    public Result<List<ObservationChildVO>> getTodayObservingChildren(
            @RequestParam(required = false) Long siteId,
            @RequestParam(required = false) Long doctorId) {
        LocalDate today = LocalDate.now();

        LambdaQueryWrapper<Appointment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Appointment::getStatus, AppointmentStatusEnum.OBSERVING.getCode())
                .eq(Appointment::getAppointmentDate, today)
                .isNotNull(Appointment::getObserveStartTime)
                .orderByAsc(Appointment::getObserveStartTime);

        if (siteId != null) {
            wrapper.eq(Appointment::getSiteId, siteId);
        }
        if (doctorId != null) {
            wrapper.eq(Appointment::getDoctorId, doctorId);
        }

        List<Appointment> appointments = appointmentService.list(wrapper);
        List<ObservationChildVO> result = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (Appointment appointment : appointments) {
            ChildProfile child = appointment.getChildId() != null
                    ? childProfileService.getById(appointment.getChildId()) : null;
            Vaccine vaccine = appointment.getVaccineId() != null
                    ? vaccineService.getById(appointment.getVaccineId()) : null;

            // 计算剩余留观时长
            LocalDateTime observeStartTime = appointment.getObserveStartTime();
            Integer observeDuration = appointment.getObserveDuration();
            int durationMinutes = observeDuration != null && observeDuration > 0
                    ? observeDuration : 30;
            LocalDateTime observeEndTime = observeStartTime.plusMinutes(durationMinutes);

            long remainingMinutes = ChronoUnit.MINUTES.between(now, observeEndTime);
            if (remainingMinutes < 0) {
                remainingMinutes = 0;
            }

            // 转换性别：1=男，2=女，其他=未知
            String genderStr = null;
            if (child != null && child.getGender() != null) {
                genderStr = child.getGender() == 1 ? "男" : (child.getGender() == 2 ? "女" : "未知");
            }

            ObservationChildVO vo = ObservationChildVO.builder()
                    .appointmentId(appointment.getId())
                    .childId(appointment.getChildId())
                    .childName(child != null ? child.getName() : null)
                    .childGender(genderStr)
                    .birthDate(child != null ? child.getBirthDate() : null)
                    .contraindicationAllergy(child != null ? child.getContraindicationAllergy() : null)
                    .vaccineId(appointment.getVaccineId())
                    .vaccineName(vaccine != null ? vaccine.getVaccineName() : null)
                    .batchNo(null) // 可从批次表查询
                    .observeStartTime(observeStartTime)
                    .observeDuration(durationMinutes)
                    .observeEndTime(observeEndTime)
                    .remainingMinutes((int) remainingMinutes)
                    .status(remainingMinutes == 0 ? "待结束" : "留观中")
                    .siteId(appointment.getSiteId())
                    .doctorId(appointment.getDoctorId())
                    .build();

            result.add(vo);
        }

        return Result.ok(result);
    }

    @Operation(summary = "延长留观时间（增加分钟数）")
    @PostMapping("/extend")
    public Result<String> extendObservationTime(@Valid @RequestBody ObservationExtendDTO dto) {
        Appointment appointment = appointmentService.getById(dto.getAppointmentId());
        if (appointment == null) {
            return Result.fail("预约不存在");
        }
        if (!Integer.valueOf(AppointmentStatusEnum.OBSERVING.getCode())
                .equals(appointment.getStatus())) {
            return Result.fail("当前状态不是留观中，无法延长");
        }

        // 增加留观时长
        Integer currentDuration = appointment.getObserveDuration();
        int baseDuration = currentDuration != null && currentDuration > 0 ? currentDuration : 30;
        int newDuration = baseDuration + dto.getExtendMinutes();

        appointment.setObserveDuration(newDuration);
        appointmentService.updateById(appointment);

        return Result.ok("留观时间已延长" + dto.getExtendMinutes() + "分钟，当前总时长" + newDuration + "分钟");
    }

    @Operation(summary = "正常结束留观（状态变为已完成）")
    @PostMapping("/complete/{appointmentId}")
    public Result<String> completeObservation(@PathVariable Long appointmentId) {
        Appointment appointment = appointmentService.getById(appointmentId);
        if (appointment == null) {
            return Result.fail("预约不存在");
        }
        if (!Integer.valueOf(AppointmentStatusEnum.OBSERVING.getCode())
                .equals(appointment.getStatus())) {
            return Result.fail("当前状态不是留观中");
        }

        appointment.setStatus(AppointmentStatusEnum.COMPLETED.getCode());
        appointmentService.updateById(appointment);

        return Result.ok("留观结束，状态已更新为已完成");
    }

    @Operation(summary = "异常终止留观（状态变为已完成，备注中标记异常原因）")
    @PostMapping("/exception")
    public Result<String> exceptionObservation(@Valid @RequestBody ObservationExceptionDTO dto) {
        Appointment appointment = appointmentService.getById(dto.getAppointmentId());
        if (appointment == null) {
            return Result.fail("预约不存在");
        }
        if (!Integer.valueOf(AppointmentStatusEnum.OBSERVING.getCode())
                .equals(appointment.getStatus())) {
            return Result.fail("当前状态不是留观中");
        }

        // 状态变为已完成，但在备注中标记异常原因
        appointment.setStatus(AppointmentStatusEnum.COMPLETED.getCode());
        String originalRemark = appointment.getRemark() != null ? appointment.getRemark() : "";
        appointment.setRemark(originalRemark + " [异常结束:" + dto.getReason() + "]");
        appointmentService.updateById(appointment);

        return Result.ok("已记录异常并终止接种流程");
    }
}
