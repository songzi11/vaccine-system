package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.model.dto.AdminPasswordDTO;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.vo.UserDetailVO;
import com.tjut.edu.vaccine_system.model.vo.UserListVO;
import com.tjut.edu.vaccine_system.service.SysUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理员-用户管理（含注销、禁用、恢复、用户详情）
 */
@RestController
@RequestMapping(value = {"/admin/user", "/api/users"})
@RequiredArgsConstructor
@Tag(name = "管理员-用户管理")
public class AdminUserController {

    private final SysUserService sysUserService;

    @Operation(summary = "分页查询用户列表（含状态标签、创建时间、最后登录时间）")
    @GetMapping(value = {"/page", ""})
    public Result<PageResult<UserListVO>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) Integer status) {
        IPage<UserListVO> page = sysUserService.pageUserVOs(current, size, username, role, status);
        return Results.page(page);
    }

    @Operation(summary = "根据ID查询（简单信息，不含关联）")
    @GetMapping("/{id}")
    public Result<UserListVO> getById(@PathVariable Long id) {
        UserListVO vo = sysUserService.getUserListVO(id);
        if (vo == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        return Result.ok(vo);
    }

    @Operation(summary = "用户详情（含关联儿童、预约、接种记录；医生含排班与统计）")
    @GetMapping("/detail/{id}")
    public Result<UserDetailVO> detail(@PathVariable Long id) {
        UserDetailVO vo = sysUserService.getUserDetail(id);
        if (vo == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        return Result.ok(vo);
    }

    @Operation(summary = "新增用户（密码明文存储）")
    @PostMapping
    public Result<SysUser> save(@Valid @RequestBody SysUser user) {
        sysUserService.saveOrUpdateUser(user);
        SysUser saved = sysUserService.getById(user.getId());
        if (saved != null) saved.setPassword(null);
        return Result.ok("新增成功", saved);
    }

    @Operation(summary = "更新用户（若传密码则明文更新）")
    @PutMapping("/{id}")
    public Result<SysUser> update(@PathVariable Long id, @RequestBody SysUser user) {
        user.setId(id);
        SysUser existing = sysUserService.getById(id);
        if (existing == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        if (user.getPassword() == null || user.getPassword().isBlank()) {
            user.setPassword(existing.getPassword());
        }
        sysUserService.saveOrUpdateUser(user);
        SysUser updated = sysUserService.getById(id);
        if (updated != null) updated.setPassword(null);
        return Result.ok("更新成功", updated);
    }

    @Operation(summary = "重置密码（请求体含 password，明文存储）")
    @PutMapping("/{id}/reset-password")
    public Result<Void> resetPassword(@PathVariable Long id, @RequestBody SysUser body) {
        if (body.getPassword() == null || body.getPassword().isBlank()) {
            return Result.fail(ResultCode.BAD_REQUEST.getCode(), "请输入新密码");
        }
        SysUser user = sysUserService.getById(id);
        if (user == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        user.setPassword(body.getPassword());
        sysUserService.saveOrUpdateUser(user);
        return Result.ok("密码已重置");
    }

    @Operation(summary = "注销用户（不可恢复，需校验管理员密码）")
    @PostMapping("/deactivate/{id}")
    public Result<String> deactivate(
            @PathVariable Long id,
            @RequestHeader(value = "X-User-Id", required = false) Long adminUserId,
            @Valid @RequestBody AdminPasswordDTO dto) {
        if (adminUserId == null) {
            return Result.fail(400, "请携带当前登录用户ID（请求头 X-User-Id）");
        }
        sysUserService.deactivateUser(id, adminUserId, dto.getAdminPassword());
        return Result.ok("该账号已注销，不可恢复；记录已保留用于审计。");
    }

    @Operation(summary = "禁用用户（可恢复）")
    @PostMapping("/disable/{id}")
    public Result<String> disable(@PathVariable Long id) {
        sysUserService.disableUser(id);
        return Result.ok("已禁用，该用户将无法登录；可通过「恢复」重新启用。");
    }

    @Operation(summary = "恢复用户（仅对已禁用有效）")
    @PostMapping("/enable/{id}")
    public Result<String> enable(@PathVariable Long id) {
        sysUserService.enableUser(id);
        return Result.ok("已恢复为正常状态。");
    }

    @Operation(summary = "删除用户（逻辑删除）")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        boolean ok = sysUserService.removeById(id);
        return ok ? Result.ok() : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }

    @Operation(summary = "批量删除用户（逻辑删除）")
    @DeleteMapping("/batch")
    public Result<Void> removeBatch(@RequestBody List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Result.fail(ResultCode.BAD_REQUEST.getCode(), "请选择要删除的ID");
        }
        sysUserService.removeByIds(ids);
        return Result.ok("删除成功");
    }
}
