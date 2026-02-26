package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;

/**
 * 儿童档案 Service
 */
public interface ChildProfileService extends IService<ChildProfile> {

    /**
     * 分页查询（可按家长ID筛选）
     */
    IPage<ChildProfile> pageProfiles(long current, long size, Long parentId);
}
