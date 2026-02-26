package com.tjut.edu.vaccine_system.task;

import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.StockAlertService;
import com.tjut.edu.vaccine_system.service.VaccinationReminderService;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 定时任务：库存/效期预警、补货同步供应商、智能提醒（脊灰第3剂提前72小时）
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StockAndReminderTask {

    private final StockAlertService stockAlertService;
    private final VaccinationReminderService vaccinationReminderService;
    private final AppointmentService appointmentService;
    private final VaccineBatchService vaccineBatchService;
    private final SiteVaccineStockService siteVaccineStockService;

    @Value("${vaccine.reminder.appointment-base-url:/pages/appointment/index}")
    private String appointmentBaseUrl;

    /** 每天 8:00 执行：百白破批次剩余量低于10%预警并同步供应商，效期30天内预警 */
    @Scheduled(cron = "${vaccine.alert.cron:0 0 8 * * ?}")
    public void runStockAlert() {
        try {
            int low = stockAlertService.checkBatchRemainingAndAlert("百白破", 10.0);
            int expiry = stockAlertService.checkExpiryAndAlert(30);
            if (low > 0 || expiry > 0) {
                stockAlertService.syncPendingAlertsToSupplier();
            }
            log.info("stock alert: low_stock={}, expiry={}", low, expiry);
        } catch (Exception e) {
            log.error("stock alert task failed", e);
        }
    }

    /** 每天 9:00 执行：未完成脊灰第3剂的儿童提前72小时推送预约链接 */
    @Scheduled(cron = "${vaccine.reminder.cron:0 0 9 * * ?}")
    public void run72hReminder() {
        try {
            int count = vaccinationReminderService.send72hReminders("脊灰", 3, appointmentBaseUrl);
            log.info("72h reminder: sent={}", count);
        } catch (Exception e) {
            log.error("72h reminder task failed", e);
        }
    }

    /** 每天凌晨 0:05 执行：过期联动——先清零各接种点该批次库存，再将 expiry_date&lt;今日 的批次状态更新为过期(2) */
    @Scheduled(cron = "${vaccine.batch.expire.cron:0 5 0 * * ?}")
    public void runBatchExpire() {
        try {
            java.time.LocalDate today = java.time.LocalDate.now();
            java.util.List<VaccineBatch> toExpire = vaccineBatchService.listExpiredByDate(today);
            for (VaccineBatch b : toExpire) {
                int zeroed = siteVaccineStockService.zeroOutByBatchId(b.getId());
                if (zeroed > 0) {
                    log.info("batch expire: zeroed site_vaccine_stock for batchId={}, rows={}", b.getId(), zeroed);
                }
            }
            int updated = vaccineBatchService.markExpiredBatches(today);
            if (updated > 0 || !toExpire.isEmpty()) {
                log.info("batch expire: marked_expired_count={}, batches_zerod={}", updated, toExpire.size());
            }
        } catch (Exception e) {
            log.error("batch expire task failed", e);
        }
    }

    /** 定时执行：预约时间段结束 8 小时后未核销的自动标记为已过期（默认每 10 分钟执行一次） */
    @Scheduled(cron = "${vaccine.appointment.expire.cron:0 */10 * * * ?}")
    public void runAppointmentExpire() {
        try {
            int expired = appointmentService.expireScheduledAfterSlotEndHours(8);
            if (expired > 0) {
                log.info("appointment expire: marked_expired={}", expired);
            }
        } catch (Exception e) {
            log.error("appointment expire task failed", e);
        }
    }
}
