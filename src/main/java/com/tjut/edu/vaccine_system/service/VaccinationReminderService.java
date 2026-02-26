package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.entity.VaccinationReminderLog;

import java.util.List;

/**
 * 基于儿童电子健康档案的智能提醒（如未完成脊灰第3剂提前72小时推送预约链接）
 * 文献：使全程接种率从82%提升至95%
 */
public interface VaccinationReminderService {

    /**
     * 对未完成指定疫苗某剂次的儿童，在应种日期前72小时推送预约提醒并记录
     *
     * @param vaccineNameKeyword 疫苗名称关键词（如「脊灰」）
     * @param doseNumber          待接种剂次（如 3 表示第3剂）
     * @param baseAppointmentUrl  预约页基础 URL（如 H5/小程序路径，可带 vaccineId 参数）
     * @return 本次推送条数
     */
    int send72hReminders(String vaccineNameKeyword, int doseNumber, String baseAppointmentUrl);

    /**
     * 查询最近推送记录
     */
    List<VaccinationReminderLog> listRecentReminders(int limit);
}
