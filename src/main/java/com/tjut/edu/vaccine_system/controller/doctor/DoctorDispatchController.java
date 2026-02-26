package com.tjut.edu.vaccine_system.controller.doctor;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.vo.DoctorDispatchVO;
import com.tjut.edu.vaccine_system.service.DoctorDispatchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 医生端-调遣通知（查看管理员推送的指派信息，标记已读）
 */
@RestController
@RequestMapping("/doctor/dispatch")
@RequiredArgsConstructor
@Tag(name = "医生-调遣通知")
public class DoctorDispatchController {

    private final DoctorDispatchService doctorDispatchService;

    @Operation(summary = "未读调遣通知数量（用于红点）")
    @GetMapping("/unreadCount")
    public Result<java.util.Map<String, Integer>> unreadCount(@RequestParam Long doctorId) {
        int count = doctorDispatchService.countUnreadByDoctorId(doctorId);
        return Result.ok(java.util.Map.of("count", count));
    }

    @Operation(summary = "我的调遣通知列表")
    @GetMapping("/list")
    public Result<List<DoctorDispatchVO>> list(@RequestParam Long doctorId) {
        List<DoctorDispatchVO> list = doctorDispatchService.listByDoctorId(doctorId);
        return Result.ok(list);
    }

    @Operation(summary = "标记已读")
    @PostMapping("/{id}/read")
    public Result<Void> markRead(@PathVariable Long id, @RequestParam Long doctorId) {
        doctorDispatchService.markRead(id, doctorId);
        return Result.ok("已标记已读");
    }
}
