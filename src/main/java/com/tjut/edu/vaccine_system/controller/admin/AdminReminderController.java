package com.tjut.edu.vaccine_system.controller.admin;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.entity.CampaignPushLog;
import com.tjut.edu.vaccine_system.model.entity.VaccinationReminderLog;
import com.tjut.edu.vaccine_system.service.CampaignPushService;
import com.tjut.edu.vaccine_system.service.VaccinationReminderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 管理员-智能提醒与宣传推送
 */
@RestController
@RequestMapping("/admin/reminder")
@RequiredArgsConstructor
@Tag(name = "管理员-智能提醒与宣传推送")
public class AdminReminderController {

    private final VaccinationReminderService vaccinationReminderService;
    private final CampaignPushService campaignPushService;

    @Operation(summary = "智能提醒推送记录")
    @GetMapping("/logs")
    public Result<List<VaccinationReminderLog>> listReminderLogs(@RequestParam(defaultValue = "50") int limit) {
        return Result.ok(vaccinationReminderService.listRecentReminders(limit));
    }

    @Operation(summary = "手动执行：未完成脊灰第3剂儿童提前72小时推送预约链接")
    @PostMapping("/run-72h")
    public Result<Map<String, Object>> run72hReminder(
            @RequestParam(required = false, defaultValue = "/pages/appointment/index") String baseUrl) {
        int count = vaccinationReminderService.send72hReminders("脊灰", 3, baseUrl);
        return Result.ok(Map.of("sent", count));
    }

    @Operation(summary = "宣传推送记录")
    @GetMapping("/campaign-logs")
    public Result<List<CampaignPushLog>> listCampaignLogs(@RequestParam(defaultValue = "50") int limit) {
        return Result.ok(campaignPushService.listRecentPushes(limit));
    }

    @Operation(summary = "手动执行：麻腮风接种宣传推送至目标家长")
    @PostMapping("/campaign-push")
    public Result<Map<String, Object>> campaignPush(
            @RequestParam(defaultValue = "麻腮风") String vaccineName,
            @RequestParam(required = false) String content) {
        int count = campaignPushService.pushCampaignForVaccine(vaccineName, content);
        return Result.ok(Map.of("sent", count));
    }
}
