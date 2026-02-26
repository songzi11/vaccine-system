package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.entity.StockAlertLog;

import java.util.List;

/**
 * 库存/效期预警与补货提醒、同步供应商
 */
public interface StockAlertService {

    /**
     * 检测百白破等指定疫苗批次剩余量低于比例阈值时，写入预警并同步供应商
     *
     * @param vaccineNameKeyword 疫苗名称关键词（如「百白破」）
     * @param remainingRatioPercent 剩余率阈值，低于此值触发（如 10 表示 10%）
     * @return 本次触发的预警条数
     */
    int checkBatchRemainingAndAlert(String vaccineNameKeyword, double remainingRatioPercent);

    /**
     * 效期临近预警（如 30 天内到期），写入预警记录
     *
     * @param withinDays 未来多少天内到期
     * @return 本次触发的预警条数
     */
    int checkExpiryAndAlert(int withinDays);

    /**
     * 将未同步的补货预警同步至供应商系统（写 supplier_sync_log）
     */
    void syncPendingAlertsToSupplier();

    List<StockAlertLog> listRecentAlerts(int limit);
}
