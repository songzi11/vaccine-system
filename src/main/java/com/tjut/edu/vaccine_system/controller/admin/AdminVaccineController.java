package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.VaccineStatusDTO;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.service.VaccineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * 管理员-疫苗管理
 */
@RestController
@RequestMapping(value = {"/admin/vaccine", "/vaccine"})
@RequiredArgsConstructor
@Tag(name = "管理员-疫苗管理")
public class AdminVaccineController {

    private final VaccineService vaccineService;

    @Operation(summary = "分页查询")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<Vaccine>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) String vaccineName,
            @RequestParam(required = false) Integer status) {
        IPage<Vaccine> page = vaccineService.pageVaccines(current, size, vaccineName, status);
        return Results.page(page);
    }

    @Operation(summary = "详情")
    @GetMapping("/{id}")
    public Result<Vaccine> getById(@PathVariable Long id) {
        return Optional.ofNullable(vaccineService.getById(id))
                .map(Result::ok)
                .orElse(Result.fail(ResultCode.NOT_FOUND.getCode(), "疫苗不存在"));
    }

    @Operation(summary = "新增")
    @PostMapping
    public Result<Vaccine> save(@Valid @RequestBody Vaccine vaccine) {
        vaccineService.save(vaccine);
        return Result.ok("新增成功", vaccineService.getById(vaccine.getId()));
    }

    @Operation(summary = "修改")
    @PutMapping("/{id}")
    public Result<Vaccine> update(@PathVariable Long id, @RequestBody Vaccine vaccine) {
        vaccine.setId(id);
        boolean ok = vaccineService.updateById(vaccine);
        return ok ? Result.ok("修改成功", vaccineService.getById(id))
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "修改失败");
    }

    @Operation(summary = "删除")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        return vaccineService.removeById(id)
                ? Result.ok()
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }

    @Operation(summary = "上架/下架")
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @Valid @RequestBody VaccineStatusDTO dto) {
        vaccineService.updateStatus(id, dto.getStatus());
        return Result.ok(dto.getStatus() == 1 ? "已上架" : "已下架");
    }
}
