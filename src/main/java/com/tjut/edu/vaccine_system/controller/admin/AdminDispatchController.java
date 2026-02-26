package com.tjut.edu.vaccine_system.controller.admin;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.vo.DoctorDispatchVO;
import com.tjut.edu.vaccine_system.service.DoctorDispatchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理员-派遣记录（仅查看，指派驻场医生在接种点管理内操作，指派后自动推送）
 */
@RestController
@RequestMapping("/admin/dispatch")
@RequiredArgsConstructor
@Tag(name = "管理员-派遣记录")
public class AdminDispatchController {

    private final DoctorDispatchService doctorDispatchService;

    @Operation(summary = "全部派遣记录列表")
    @GetMapping("/list")
    public Result<List<DoctorDispatchVO>> list() {
        return Result.ok(doctorDispatchService.listAll());
    }
}
