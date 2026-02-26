package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.BatchDisposeDTO;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 管理员-疫苗批次管理（查看所有批次、筛选临期/过期、执行销毁）
 */
@RestController
@RequestMapping(value = {"/admin/batch", "/api/admin/batch"})
@RequiredArgsConstructor
@Tag(name = "管理员-疫苗批次管理")
public class AdminBatchController {

    private final VaccineBatchService vaccineBatchService;

    @Operation(summary = "分页查询批次，支持按疫苗、状态筛选（0正常 1临期 2过期 3已销毁）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<VaccineBatch>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long vaccineId,
            @RequestParam(required = false) Integer status) {
        IPage<VaccineBatch> page = vaccineBatchService.pageBatches(current, size, vaccineId, status);
        return Results.page(page);
    }

    @Operation(summary = "按状态查询批次列表（用于筛选临期/过期）")
    @GetMapping("/by-status")
    public Result<List<VaccineBatch>> listByStatus(@RequestParam(required = false) Integer status) {
        List<VaccineBatch> list = vaccineBatchService.listByStatus(status);
        return Result.ok(list);
    }

    @Operation(summary = "批次详情")
    @GetMapping("/{id}")
    public Result<VaccineBatch> getById(@PathVariable Long id) {
        VaccineBatch batch = vaccineBatchService.getById(id);
        return batch != null ? Result.ok(batch) : Result.fail(404, "批次不存在");
    }

    @Operation(summary = "新增批次（入库时使用）")
    @PostMapping
    public Result<VaccineBatch> save(@RequestBody VaccineBatch batch) {
        if (batch.getStatus() == null) batch.setStatus(0);
        if (batch.getStock() == null) batch.setStock(0);
        if (batch.getWarningDays() == null) batch.setWarningDays(30);
        LocalDateTime now = LocalDateTime.now();
        if (batch.getCreatedAt() == null) batch.setCreatedAt(now);
        if (batch.getUpdatedAt() == null) batch.setUpdatedAt(now);
        vaccineBatchService.save(batch);
        return Result.ok("新增成功", vaccineBatchService.getById(batch.getId()));
    }

    @Operation(summary = "执行销毁：记录销毁、状态改为已销毁、库存清零（仅过期/临期批次可销毁）")
    @PostMapping("/dispose")
    public Result<Void> dispose(@Valid @RequestBody BatchDisposeDTO dto) {
        vaccineBatchService.dispose(
                dto.getBatchId(),
                dto.getDisposalReason() != null ? dto.getDisposalReason() : "过期销毁",
                dto.getDisposalDate() != null ? dto.getDisposalDate() : LocalDate.now(),
                dto.getOperatorId(),
                dto.getRemark());
        return Result.ok("销毁记录已提交，批次状态已更新为已销毁");
    }
}
