package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tjut.edu.vaccine_system.model.entity.CampaignPushLog;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.mapper.CampaignPushLogMapper;
import com.tjut.edu.vaccine_system.service.CampaignPushService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 宣传推送：麻腮风等疫苗接种低谷期向目标家长推送
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CampaignPushServiceImpl implements CampaignPushService {

    private final VaccineService vaccineService;
    private final ChildProfileService childProfileService;
    private final VaccinationRecordService vaccinationRecordService;
    private final CampaignPushLogMapper campaignPushLogMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int pushCampaignForVaccine(String vaccineNameKeyword, String content) {
        if (vaccineNameKeyword == null || vaccineNameKeyword.isBlank()) return 0;
        List<Vaccine> vaccines = vaccineService.list(new LambdaQueryWrapper<Vaccine>()
                .like(Vaccine::getVaccineName, vaccineNameKeyword));
        if (vaccines.isEmpty()) return 0;
        Vaccine vaccine = vaccines.get(0);
        String defaultContent = "【接种提醒】" + vaccine.getVaccineName() + "是儿童必种疫苗，当前为接种适宜期，请及时为宝宝预约接种。";
        String finalContent = (content != null && !content.isBlank()) ? content : defaultContent;
        Set<Long> targetUserIds = new HashSet<>();
        List<ChildProfile> children = childProfileService.list();
        for (ChildProfile child : children) {
            VaccinationRecord last = vaccinationRecordService.getLastRecordByChildAndVaccine(child.getId(), vaccine.getId());
            int totalDoses = vaccine.getTotalDoses() != null ? vaccine.getTotalDoses() : 1;
            boolean needPush = last == null || (last.getDoseNumber() != null && last.getDoseNumber() < totalDoses);
            if (needPush) {
                targetUserIds.add(child.getParentId());
            }
        }
        int count = 0;
        LocalDateTime now = LocalDateTime.now();
        for (Long userId : targetUserIds) {
            long already = campaignPushLogMapper.selectCount(new LambdaQueryWrapper<CampaignPushLog>()
                    .eq(CampaignPushLog::getVaccineId, vaccine.getId())
                    .eq(CampaignPushLog::getTargetUserId, userId)
                    .ge(CampaignPushLog::getPushTime, now.toLocalDate().atStartOfDay()));
            if (already > 0) continue;
            CampaignPushLog pushLog = CampaignPushLog.builder()
                    .vaccineId(vaccine.getId())
                    .vaccineName(vaccine.getVaccineName())
                    .siteId(null)
                    .targetUserId(userId)
                    .content(finalContent)
                    .pushChannel("WECHAT")
                    .pushTime(now)
                    .build();
            campaignPushLogMapper.insert(pushLog);
            count++;
        }
        return count;
    }

    @Override
    public List<CampaignPushLog> listRecentPushes(int limit) {
        LambdaQueryWrapper<CampaignPushLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(CampaignPushLog::getPushTime).last("LIMIT " + Math.max(1, limit));
        return campaignPushLogMapper.selectList(wrapper);
    }
}
