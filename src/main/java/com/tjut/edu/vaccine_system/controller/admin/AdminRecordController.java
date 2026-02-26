package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.CreateRecordDTO;
import com.tjut.edu.vaccine_system.model.entity.Record;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * 管理员-接种记录管理（record 表分页/CRUD + vaccination_record 表分页/核销）
 */
@RestController
@RequestMapping("/admin/record")
@RequiredArgsConstructor
@Tag(name = "管理员-接种记录管理")
public class AdminRecordController {

    private final RecordService recordService;
    private final VaccinationRecordService vaccinationRecordService;

    @Operation(summary = "分页查询 record 表记录")
    @GetMapping("/page")
    public Result<PageResult<Record>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long childId) {
        PageResult<Record> page = recordService.pageRecords(current, size, userId, childId);
        return Result.ok(page);
    }

    @Operation(summary = "分页查询 vaccination_record 表记录")
    @GetMapping("/vaccination/page")
    public Result<PageResult<VaccinationRecord>> vaccinationPage(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long childId,
            @RequestParam(required = false) Long vaccineId,
            @RequestParam(required = false) Long siteId) {
        IPage<VaccinationRecord> page = vaccinationRecordService.pageRecords(current, size, userId, childId, vaccineId, siteId);
        return Results.page(page);
    }

    @Operation(summary = "vaccination_record 详情")
    @GetMapping("/vaccination/{id}")
    public Result<VaccinationRecord> getVaccinationById(@PathVariable Long id) {
        return Optional.ofNullable(vaccinationRecordService.getById(id))
                .map(Result::ok)
                .orElse(Result.fail(ResultCode.NOT_FOUND.getCode(), "接种记录不存在"));
    }

    @Operation(summary = "接种核销（写入 vaccination_record）")
    @PostMapping("/vaccination")
    public Result<VaccinationRecord> saveVaccination(@Valid @RequestBody CreateRecordDTO dto) {
        try {
            VaccinationRecord record = vaccinationRecordService.createRecordByAppointment(dto);
            return Result.ok("核销成功", record);
        } catch (IllegalArgumentException e) {
            return Result.fail(ResultCode.BAD_REQUEST.getCode(), e.getMessage());
        }
    }

    @Operation(summary = "新增 record 表记录")
    @PostMapping
    public Result<Record> add(@Valid @RequestBody Record record) {
        Record saved = recordService.addRecord(record);
        return Result.ok("新增成功", saved);
    }

    @Operation(summary = "修改 record 表记录")
    @PutMapping("/{id}")
    public Result<Record> update(@PathVariable Long id, @RequestBody Record record) {
        record.setId(id);
        boolean ok = recordService.updateById(record);
        return ok ? Result.ok("修改成功", recordService.getById(id))
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "修改失败");
    }

    @Operation(summary = "删除 record 表记录")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        return recordService.removeById(id)
                ? Result.ok()
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }
}
