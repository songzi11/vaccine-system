package com.tjut.edu.vaccine_system.controller.common;

import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.dto.LoginDTO;
import com.tjut.edu.vaccine_system.model.dto.RegisterDTO;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.vo.LoginUserVO;
import com.tjut.edu.vaccine_system.service.SysUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * 公共：登录、用户名校验
 */
@RestController
@RequestMapping(value = {"/common/auth", "/api/users"})
@RequiredArgsConstructor
@Slf4j
@Tag(name = "公共-登录与校验")
public class CommonAuthController {

    private final SysUserService sysUserService;

    @Operation(summary = "用户登录（返回 id、username、role，供前端顶部展示）")
    @PostMapping("/login")
    public Result<LoginUserVO> login(@Valid @RequestBody LoginDTO dto) {
        log.info("用户登录 username={}", dto.getUsername());
        Optional<SysUser> opt = sysUserService.login(dto.getUsername(), dto.getPassword());
        if (opt.isEmpty()) {
            throw new BizException(BizErrorCode.LOGIN_FAILED);
        }
        SysUser user = opt.get();
        LoginUserVO vo = LoginUserVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .role(user.getRole())
                .build();
        return Result.ok("登录成功", vo);
    }

    @Operation(summary = "校验用户名是否存在且有效（登录页实时校验）")
    @GetMapping("/check-username")
    public Result<Boolean> checkUsername(@RequestParam String username) {
        String name = username != null ? username.trim() : "";
        boolean valid = sysUserService.isUsernameValid(name);
        return Result.ok(valid);
    }

    @Operation(summary = "注册（角色：家长RESIDENT/医生DOCTOR/管理员ADMIN；被注销过的用户名不能再次使用）")
    @PostMapping("/register")
    public Result<LoginUserVO> register(@Valid @RequestBody RegisterDTO dto) {
        log.info("用户注册 username={} role={}", dto.getUsername(), dto.getRole());
        SysUser user = sysUserService.register(dto);
        LoginUserVO vo = LoginUserVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .role(user.getRole())
                .build();
        return Result.ok("注册成功", vo);
    }
}
