package com.tjut.edu.vaccine_system.controller.doctor;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.dto.CreateRecordDTO;
import com.tjut.edu.vaccine_system.model.entity.Record;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 医生-接种处理：完成接种（record 表）、接种核销（vaccination_record 表）
 */
@RestController
@RequestMapping(value = {"/doctor/vaccinate", "/api/doctor/vaccinate"})
@RequiredArgsConstructor
@Slf4j
@Tag(name = "医生-接种处理")
public class DoctorVaccinateController {

    private final RecordService recordService;
    private final VaccinationRecordService vaccinationRecordService;

    @Operation(summary = "完成接种：校验预约状态为已预约/已签到/预检通过等，插入 record，更新 order 为已完成")
    @PostMapping("/finish/{orderId}")
    public Result<Record> finishVaccinate(@PathVariable Long orderId) {
        Record record = recordService.finishVaccinateByOrderId(orderId);
        return Result.ok("接种完成", record);
    }

    @Operation(summary = "接种核销（更新预约状态、生成 vaccination_record、计算下次接种日）")
    @PostMapping
    public Result<VaccinationRecord> vaccinate(@Valid @RequestBody CreateRecordDTO dto) {
        VaccinationRecord record = vaccinationRecordService.createRecordByAppointment(dto);
        return Result.ok("核销成功", record);
    }
}
