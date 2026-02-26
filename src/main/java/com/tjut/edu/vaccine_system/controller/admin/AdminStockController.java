package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.AllocateVaccineDTO;
import com.tjut.edu.vaccine_system.model.dto.BatchAllocateVaccineDTO;
import com.tjut.edu.vaccine_system.model.dto.ReturnToWarehouseDTO;
import com.tjut.edu.vaccine_system.model.dto.TransferDTO;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.entity.StockAlertLog;
import com.tjut.edu.vaccine_system.model.entity.StockTransferLog;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockBatchVO;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.StockAlertService;
import com.tjut.edu.vaccine_system.service.StockTransferService;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 管理员-库存预警、总仓/接种点库存、调拨与调拨日志
 */
@RestController
@RequestMapping("/admin/stock")
@RequiredArgsConstructor
@Tag(name = "管理员-库存预警与调拨")
public class AdminStockController {

    private final VaccineSiteStockService vaccineSiteStockService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final StockTransferService stockTransferService;
    private final StockAlertService stockAlertService;
    private final VaccineBatchService vaccineBatchService;

    @Operation(summary = "库存预警列表（stock < 预警阈值）")
    @GetMapping("/warning")
    public Result<List<LowStockVO>> warning() {
        List<LowStockVO> list = vaccineSiteStockService.listStockWarning();
        return Result.ok(list);
    }

    @Operation(summary = "批次/效期预警记录")
    @GetMapping("/alerts")
    public Result<List<StockAlertLog>> listAlerts(@RequestParam(defaultValue = "50") int limit) {
        return Result.ok(stockAlertService.listRecentAlerts(limit));
    }

    @Operation(summary = "手动执行：检测百白破剩余率<10%与效期临近，并同步供应商")
    @PostMapping("/check-and-sync")
    public Result<Map<String, Object>> checkAndSync() {
        int low = stockAlertService.checkBatchRemainingAndAlert("百白破", 10.0);
        int expiry = stockAlertService.checkExpiryAndAlert(30);
        stockAlertService.syncPendingAlertsToSupplier();
        return Result.ok(Map.of("lowStockAlerts", low, "expiryAlerts", expiry));
    }

    // ---------- 库存联动：接种点库存（site_vaccine_stock）、调拨、调拨日志 ----------

    @Operation(summary = "接种点库存列表（按批次：可用+锁定）")
    @GetMapping("/site-stock")
    public Result<List<SiteVaccineStock>> listSiteStock(@RequestParam Long siteId) {
        List<SiteVaccineStock> list = siteVaccineStockService.listBySiteId(siteId);
        return Result.ok(list);
    }

    @Operation(summary = "接种点按批次库存详情（含疫苗名、批号，用于展示与退回）")
    @GetMapping("/site-stock-detail")
    public Result<List<SiteStockBatchVO>> listSiteStockDetail(@RequestParam Long siteId) {
        List<SiteStockBatchVO> list = siteVaccineStockService.listBySiteIdWithBatchInfo(siteId);
        return Result.ok(list);
    }

    @Operation(summary = "总仓按疫苗剩余数量（实时，未过期批次汇总）")
    @GetMapping("/warehouse-summary")
    public Result<List<VaccineStockVO>> warehouseSummary() {
        return Result.ok(vaccineBatchService.listWarehouseStockByVaccine());
    }

    @Operation(summary = "总仓调拨至接种点（选择批次、接种点、数量，原子执行）")
    @PostMapping("/transfer")
    public Result<Void> transfer(@Valid @RequestBody TransferDTO dto, @RequestParam(required = false) Long operatorId) {
        stockTransferService.transferFromWarehouseToSite(
                dto.getBatchId(), dto.getSiteId(), dto.getQuantity(), operatorId);
        return Result.ok("调拨成功");
    }

    @Operation(summary = "按疫苗分配至接种点（免选批次，总仓 FEFO 自动选批，推荐使用）")
    @PostMapping("/allocate-vaccine")
    public Result<Void> allocateByVaccine(@Valid @RequestBody AllocateVaccineDTO dto, @RequestParam(required = false) Long operatorId) {
        stockTransferService.allocateByVaccine(dto.getSiteId(), dto.getVaccineId(), dto.getQuantity(), operatorId);
        return Result.ok("分配成功");
    }

    @Operation(summary = "按接种点批量分配多种疫苗（一次选择接种点与多种疫苗及数量）")
    @PostMapping("/allocate-batch")
    public Result<Void> batchAllocate(@Valid @RequestBody BatchAllocateVaccineDTO dto, @RequestParam(required = false) Long operatorId) {
        stockTransferService.batchAllocateByVaccine(dto.getSiteId(), dto.getItems(), operatorId);
        return Result.ok("批量分配成功");
    }

    @Operation(summary = "接种点向总仓退回疫苗（按批次退可用库存）")
    @PostMapping("/return-to-warehouse")
    public Result<Void> returnToWarehouse(@Valid @RequestBody ReturnToWarehouseDTO dto, @RequestParam(required = false) Long operatorId) {
        stockTransferService.returnToWarehouse(dto.getSiteId(), dto.getBatchId(), dto.getQuantity(), operatorId);
        return Result.ok("退回成功");
    }

    @Operation(summary = "总仓可调拨批次列表（stock>0、未过期），供调拨/分配时下拉选择")
    @GetMapping("/warehouse-batches")
    public Result<List<VaccineBatch>> warehouseBatches() {
        return Result.ok(vaccineBatchService.listWarehouseBatchesForTransfer());
    }

    @Operation(summary = "调拨日志分页")
    @GetMapping("/transfer-logs")
    public Result<com.tjut.edu.vaccine_system.common.result.PageResult<StockTransferLog>> transferLogs(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) Long batchId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fromTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime toTime) {
        IPage<StockTransferLog> page = stockTransferService.pageLogs(current, size, batchId, fromTime, toTime);
        return Results.page(page);
    }
}
