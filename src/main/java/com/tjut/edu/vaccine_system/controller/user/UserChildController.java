package com.tjut.edu.vaccine_system.controller.user;

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
 * 用户端-我的宝宝
 */
@RestController
@RequestMapping(value = {"/user/child", "/child"})
@RequiredArgsConstructor
@Tag(name = "用户-儿童档案")
public class UserChildController {

    private final ChildProfileService childProfileService;

    @Operation(summary = "分页查询儿童档案（parentId 选填，居民查自家）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<ChildProfile>> list(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long parentId) {
        IPage<ChildProfile> page = childProfileService.pageProfiles(current, size, parentId);
        return Results.page(page);
    }

    @Operation(summary = "详情")
    @GetMapping("/{id}")
    public Result<ChildProfile> getById(@PathVariable Long id) {
        return Optional.ofNullable(childProfileService.getById(id))
                .map(Result::ok)
                .orElse(Result.fail(ResultCode.NOT_FOUND.getCode(), "儿童档案不存在"));
    }

    @Operation(summary = "新增儿童档案")
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

    @Operation(summary = "删除儿童档案（居民仅能删除自己的宝宝，可传 parentId 校验）")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id, @RequestParam(required = false) Long parentId) {
        ChildProfile child = childProfileService.getById(id);
        if (child == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "儿童档案不存在");
        if (parentId != null && !parentId.equals(child.getParentId())) {
            return Result.fail(ResultCode.FORBIDDEN.getCode(), "只能删除自己的宝宝档案");
        }
        return childProfileService.removeById(id)
                ? Result.ok()
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }
}
