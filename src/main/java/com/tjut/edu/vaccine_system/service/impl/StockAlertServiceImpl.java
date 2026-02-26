package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tjut.edu.vaccine_system.model.entity.StockAlertLog;
import com.tjut.edu.vaccine_system.model.entity.SupplierSyncLog;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.entity.VaccineInventory;
import com.tjut.edu.vaccine_system.mapper.StockAlertLogMapper;
import com.tjut.edu.vaccine_system.mapper.SupplierSyncLogMapper;
import com.tjut.edu.vaccine_system.service.StockAlertService;
import com.tjut.edu.vaccine_system.service.VaccineInventoryService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 库存/效期预警与补货提醒、同步供应商实现
 * 文献：当某批次百白破疫苗剩余量低于10%时，自动触发补货提醒并同步至供应商系统
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class StockAlertServiceImpl implements StockAlertService {

    private final VaccineInventoryService vaccineInventoryService;
    private final VaccineService vaccineService;
    private final StockAlertLogMapper stockAlertLogMapper;
    private final SupplierSyncLogMapper supplierSyncLogMapper;
    private final RestTemplate restTemplate = new RestTemplate();

    /** 供应商补货接口地址，为空则仅写库不真实请求 */
    @Value("${vaccine.supplier.restock-url:}")
    private String supplierRestockUrl;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int checkBatchRemainingAndAlert(String vaccineNameKeyword, double remainingRatioPercent) {
        if (vaccineNameKeyword == null || vaccineNameKeyword.isBlank()) return 0;
        List<VaccineInventory> batches = vaccineInventoryService.listByVaccineNameLike(vaccineNameKeyword);
        int count = 0;
        for (VaccineInventory inv : batches) {
            double ratio = inv.getRemainingRatioPercent();
            if (ratio >= remainingRatioPercent) continue;
            if (ratio <= 0) continue; // 已用完不重复预警
            Vaccine vaccine = vaccineService.getById(inv.getVaccineId());
            StockAlertLog alert = StockAlertLog.builder()
                    .alertType(StockAlertLog.ALERT_TYPE_LOW_STOCK)
                    .vaccineId(inv.getVaccineId())
                    .vaccineName(vaccine != null ? vaccine.getVaccineName() : null)
                    .siteId(inv.getSiteId())
                    .inventoryId(inv.getId())
                    .batchNo(inv.getBatchNo())
                    .quantity(inv.getQuantity())
                    .usedQuantity(inv.getUsedQuantity())
                    .remainingRatio(BigDecimal.valueOf(ratio))
                    .expiryDate(inv.getExpiryDate())
                    .syncedToSupplier(0)
                    .createTime(LocalDateTime.now())
                    .build();
            stockAlertLogMapper.insert(alert);
            count++;
        }
        return count;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int checkExpiryAndAlert(int withinDays) {
        List<VaccineInventory> batches = vaccineInventoryService.listExpiringWithinDays(withinDays);
        int count = 0;
        for (VaccineInventory inv : batches) {
            Vaccine vaccine = vaccineService.getById(inv.getVaccineId());
            StockAlertLog alert = StockAlertLog.builder()
                    .alertType(StockAlertLog.ALERT_TYPE_EXPIRY)
                    .vaccineId(inv.getVaccineId())
                    .vaccineName(vaccine != null ? vaccine.getVaccineName() : null)
                    .siteId(inv.getSiteId())
                    .inventoryId(inv.getId())
                    .batchNo(inv.getBatchNo())
                    .quantity(inv.getQuantity())
                    .usedQuantity(inv.getUsedQuantity())
                    .remainingRatio(BigDecimal.valueOf(inv.getRemainingRatioPercent()))
                    .expiryDate(inv.getExpiryDate())
                    .syncedToSupplier(0)
                    .createTime(LocalDateTime.now())
                    .build();
            stockAlertLogMapper.insert(alert);
            count++;
        }
        return count;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void syncPendingAlertsToSupplier() {
        LambdaQueryWrapper<StockAlertLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StockAlertLog::getSyncedToSupplier, 0).orderByAsc(StockAlertLog::getCreateTime);
        List<StockAlertLog> pending = stockAlertLogMapper.selectList(wrapper);
        for (StockAlertLog alert : pending) {
            try {
                int responseCode = 0;
                String responseBody = "";
                if (supplierRestockUrl != null && !supplierRestockUrl.isBlank()) {
                    Map<String, Object> body = new HashMap<>();
                    body.put("alertId", alert.getId());
                    body.put("vaccineId", alert.getVaccineId());
                    body.put("vaccineName", alert.getVaccineName());
                    body.put("siteId", alert.getSiteId());
                    body.put("batchNo", alert.getBatchNo());
                    body.put("remainingRatio", alert.getRemainingRatio());
                    body.put("alertType", alert.getAlertType());
                    HttpHeaders headers = new HttpHeaders();
                    headers.setContentType(MediaType.APPLICATION_JSON);
                    ResponseEntity<String> resp = restTemplate.exchange(
                            supplierRestockUrl,
                            HttpMethod.POST,
                            new HttpEntity<>(body, headers),
                            String.class);
                    responseCode = resp.getStatusCode().value();
                    responseBody = resp.getBody() != null ? resp.getBody() : "";
                } else {
                    responseBody = "supplier URL not configured, log only";
                }
                SupplierSyncLog syncLog = SupplierSyncLog.builder()
                        .stockAlertLogId(alert.getId())
                        .supplierEndpoint(supplierRestockUrl)
                        .requestBody("{\"alertId\":" + alert.getId() + "}")
                        .responseCode(responseCode)
                        .responseBody(responseBody)
                        .syncTime(LocalDateTime.now())
                        .build();
                supplierSyncLogMapper.insert(syncLog);
                alert.setSyncedToSupplier(1);
                stockAlertLogMapper.updateById(alert);
            } catch (Exception e) {
                log.warn("sync alert to supplier failed, alertId={}", alert.getId(), e);
                SupplierSyncLog syncLog = SupplierSyncLog.builder()
                        .stockAlertLogId(alert.getId())
                        .supplierEndpoint(supplierRestockUrl)
                        .requestBody("{}")
                        .responseCode(-1)
                        .responseBody(e.getMessage())
                        .syncTime(LocalDateTime.now())
                        .build();
                supplierSyncLogMapper.insert(syncLog);
            }
        }
    }

    @Override
    public List<StockAlertLog> listRecentAlerts(int limit) {
        LambdaQueryWrapper<StockAlertLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(StockAlertLog::getCreateTime).last("LIMIT " + Math.max(1, limit));
        return stockAlertLogMapper.selectList(wrapper);
    }
}
