package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.entity.CampaignPushLog;

import java.util.List;

/**
 * 宣传推送：分析某区域某疫苗接种低谷期，向目标家长推送宣传信息
 * 文献：系统可分析某区域麻腮风疫苗接种低谷期，自动推送宣传信息至目标家长微信，使接种率提升18%
 */
public interface CampaignPushService {

    /**
     * 分析指定疫苗（如麻腮风）近期接种量，向“未完成该疫苗或适龄未种”的家长推送宣传
     *
     * @param vaccineNameKeyword 疫苗名称关键词（如「麻腮风」）
     * @param content            宣传文案（可为空，则使用默认文案）
     * @return 本次推送条数
     */
    int pushCampaignForVaccine(String vaccineNameKeyword, String content);

    List<CampaignPushLog> listRecentPushes(int limit);
}
