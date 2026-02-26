package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.mapper.ChildProfileMapper;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 儿童档案 Service 实现
 */
@Service
@RequiredArgsConstructor
public class ChildProfileServiceImpl extends ServiceImpl<ChildProfileMapper, ChildProfile> implements ChildProfileService {

    @Override
    public IPage<ChildProfile> pageProfiles(long current, long size, Long parentId) {
        Page<ChildProfile> page = new Page<>(current, size);
        LambdaQueryWrapper<ChildProfile> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(parentId != null, ChildProfile::getParentId, parentId)
                .orderByDesc(ChildProfile::getCreateTime);
        return page(page, wrapper);
    }
}
