package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.entity.VaccinationReminderLog;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.mapper.VaccinationReminderLogMapper;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import com.tjut.edu.vaccine_system.service.VaccinationReminderService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 智能提醒：未完成脊灰第3剂等儿童提前72小时推送预约链接
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class VaccinationReminderServiceImpl implements VaccinationReminderService {

    private final VaccineService vaccineService;
    private final ChildProfileService childProfileService;
    private final VaccinationRecordService vaccinationRecordService;
    private final VaccinationReminderLogMapper reminderLogMapper;

    /** 提前多少天内视为“72小时窗口”（含当日） */
    private static final int REMIND_DAYS_AHEAD = 4;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int send72hReminders(String vaccineNameKeyword, int doseNumber, String baseAppointmentUrl) {
        if (vaccineNameKeyword == null || vaccineNameKeyword.isBlank()) return 0;
        List<Vaccine> vaccines = vaccineService.list(new LambdaQueryWrapper<Vaccine>()
                .like(Vaccine::getVaccineName, vaccineNameKeyword));
        if (vaccines.isEmpty()) return 0;
        List<Long> vaccineIds = vaccines.stream().map(Vaccine::getId).collect(Collectors.toList());
        String vaccineName = vaccines.get(0).getVaccineName();
        LocalDate now = LocalDate.now();
        LocalDate end = now.plusDays(REMIND_DAYS_AHEAD);
        int count = 0;
        List<ChildProfile> children = childProfileService.list();
        for (ChildProfile child : children) {
            for (Long vaccineId : vaccineIds) {
                VaccinationRecord last = vaccinationRecordService.getLastRecordByChildAndVaccine(child.getId(), vaccineId);
                if (last == null) continue; // 未接种过该疫苗，不纳入“第3剂”提醒
                if (last.getDoseNumber() >= doseNumber) continue; // 已完成该剂次
                LocalDate nextDose = last.getNextDoseDate();
                if (nextDose == null) continue;
                if (nextDose.isBefore(now) || nextDose.isAfter(end)) continue; // 不在72小时窗口
                // 避免重复推送：同一 child+vaccine+dose 今日已推送过则跳过
                long already = reminderLogMapper.selectCount(new LambdaQueryWrapper<VaccinationReminderLog>()
                        .eq(VaccinationReminderLog::getChildId, child.getId())
                        .eq(VaccinationReminderLog::getVaccineId, vaccineId)
                        .eq(VaccinationReminderLog::getDoseNumber, doseNumber)
                        .ge(VaccinationReminderLog::getPushTime, now.atStartOfDay()));
                if (already > 0) continue;
                String link = (baseAppointmentUrl != null ? baseAppointmentUrl : "/pages/appointment/index") + "?vaccineId=" + vaccineId;
                VaccinationReminderLog reminderLog = VaccinationReminderLog.builder()
                        .childId(child.getId())
                        .userId(child.getParentId())
                        .vaccineId(vaccineId)
                        .vaccineName(vaccineName)
                        .doseNumber(doseNumber)
                        .remindType(VaccinationReminderLog.REMIND_TYPE_SCHEDULE_72H)
                        .appointmentLink(link)
                        .pushChannel(VaccinationReminderLog.PUSH_CHANNEL_WECHAT)
                        .pushTime(LocalDateTime.now())
                        .build();
                reminderLogMapper.insert(reminderLog);
                count++;
            }
        }
        return count;
    }

    @Override
    public List<VaccinationReminderLog> listRecentReminders(int limit) {
        LambdaQueryWrapper<VaccinationReminderLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(VaccinationReminderLog::getPushTime).last("LIMIT " + Math.max(1, limit));
        return reminderLogMapper.selectList(wrapper);
    }
}
