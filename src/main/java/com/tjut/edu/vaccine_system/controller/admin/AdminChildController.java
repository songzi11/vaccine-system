package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * 管理员-儿童档案（可替任意家长新增/修改/删除宝宝）
 */
@RestController
@RequestMapping("/admin/child")
@RequiredArgsConstructor
@Tag(name = "管理员-儿童档案")
public class AdminChildController {

    private final ChildProfileService childProfileService;

    @Operation(summary = "分页查询儿童档案（可按 parentId 筛选）")
    @GetMapping(value = {"/page", "/list", ""})
    public Result<PageResult<ChildProfile>> list(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long parentId) {
        IPage<ChildProfile> page = childProfileService.pageProfiles(current, size, parentId);
        return Results.page(page);
    }

    @Operation(summary = "儿童档案详情")
    @GetMapping("/{id}")
    public Result<ChildProfile> getById(@PathVariable Long id) {
        return Optional.ofNullable(childProfileService.getById(id))
                .map(Result::ok)
                .orElse(Result.fail(ResultCode.NOT_FOUND.getCode(), "儿童档案不存在"));
    }

    @Operation(summary = "新增儿童档案（parentId 指定家长）")
    @PostMapping
    public Result<ChildProfile> save(@RequestBody ChildProfile childProfile) {
        childProfileService.save(childProfile);
        return Result.ok("新增成功", childProfileService.getById(childProfile.getId()));
    }

    @Operation(summary = "修改儿童档案")
    @PutMapping("/{id}")
    public Result<ChildProfile> update(@PathVariable Long id, @RequestBody ChildProfile childProfile) {
        childProfile.setId(id);
        boolean ok = childProfileService.updateById(childProfile);
        return ok ? Result.ok("修改成功", childProfileService.getById(id))
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "修改失败");
    }

    @Operation(summary = "删除儿童档案")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        return childProfileService.removeById(id)
                ? Result.ok()
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }
}
