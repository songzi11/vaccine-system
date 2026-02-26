package com.tjut.edu.vaccine_system.controller.admin;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.vo.DailyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.HeatmapCellVO;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.MonthlyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.StatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员-统计报表
 */
@RestController
@RequestMapping(value = {"/admin/stats", "/api/stats"})
@RequiredArgsConstructor
@Tag(name = "管理员-统计报表")
public class AdminStatsController {

    private final StatsService statsService;
    private final RecordService recordService;

    @Operation(summary = "今日接种人数统计")
    @GetMapping("/today-vaccination")
    public Result<Long> todayVaccination() {
        long count = statsService.countTodayVaccination();
        return Result.ok(count);
    }

    @Operation(summary = "今日接种人数（record 表）")
    @GetMapping("/todayCount")
    public Result<Map<String, Object>> todayCount() {
        long count = recordService.todayCount();
        return Result.ok(Map.of("count", count));
    }

    @Operation(summary = "各疫苗接种次数（record 表）")
    @GetMapping("/vaccineCount")
    public Result<List<Map<String, Object>>> vaccineCount() {
        return Result.ok(recordService.vaccineCount());
    }

    @Operation(summary = "近7天接种趋势（record 表）")
    @GetMapping("/last7days")
    public Result<List<Map<String, Object>>> last7days() {
        return Result.ok(recordService.last7days());
    }

    @Operation(summary = "各疫苗库存统计")
    @GetMapping("/vaccine-stock")
    public Result<List<VaccineStockVO>> vaccineStock() {
        List<VaccineStockVO> list = statsService.listVaccineStock();
        return Result.ok(list);
    }

    @Operation(summary = "每月接种趋势统计")
    @GetMapping("/monthly-trend")
    public Result<List<MonthlyTrendVO>> monthlyTrend(@RequestParam(required = false) Integer year) {
        List<MonthlyTrendVO> list = statsService.listMonthlyTrend(year);
        return Result.ok(list);
    }

    @Operation(summary = "低库存预警")
    @GetMapping("/low-stock")
    public Result<List<LowStockVO>> lowStock(@RequestParam(defaultValue = "5") int threshold) {
        List<LowStockVO> list = statsService.listLowStock(threshold);
        return Result.ok(list);
    }

    @Operation(summary = "近7天每日接种趋势")
    @GetMapping("/trend-7days")
    public Result<List<DailyTrendVO>> trend7Days() {
        List<DailyTrendVO> list = statsService.listTrendLast7Days();
        return Result.ok(list);
    }

    @Operation(summary = "多维热力图")
    @GetMapping("/heatmap")
    public Result<List<HeatmapCellVO>> heatmap(
            @RequestParam(required = false) LocalDate dateFrom,
            @RequestParam(required = false) LocalDate dateTo) {
        List<HeatmapCellVO> list = statsService.listHeatmap(dateFrom, dateTo);
        return Result.ok(list);
    }

    @Operation(summary = "统计大屏聚合数据（今日接种、近7日趋势、各疫苗库存、低库存预警）")
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard(
            @Parameter(description = "低库存预警阈值，低于此值列入预警") @RequestParam(defaultValue = "5") int lowStockThreshold) {
        Map<String, Object> data = new HashMap<>();
        data.put("todayVaccination", statsService.countTodayVaccination());
        data.put("lowStock", statsService.listLowStock(lowStockThreshold));
        data.put("trend7Days", statsService.listTrendLast7Days());
        data.put("vaccineStock", statsService.listVaccineStock());
        return Result.ok(data);
    }
}
