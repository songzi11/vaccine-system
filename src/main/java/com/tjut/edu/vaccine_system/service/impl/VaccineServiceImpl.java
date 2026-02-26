package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.mapper.VaccineMapper;
import com.tjut.edu.vaccine_system.service.VaccineService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

/**
 * 疫苗信息 Service 实现
 */
@Service
public class VaccineServiceImpl extends ServiceImpl<VaccineMapper, Vaccine> implements VaccineService {

    @Override
    public IPage<Vaccine> pageVaccines(long current, long size, String vaccineName, Integer status) {
        Page<Vaccine> page = new Page<>(current, size);
        LambdaQueryWrapper<Vaccine> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(vaccineName), Vaccine::getVaccineName, vaccineName)
                .eq(status != null, Vaccine::getStatus, status)
                .orderByDesc(Vaccine::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        Vaccine vaccine = getById(id);
        if (vaccine == null) {
            throw new BizException(BizErrorCode.NOT_FOUND, "疫苗不存在");
        }
        VaccineStatusEnum statusEnum = VaccineStatusEnum.fromCode(status);
        if (statusEnum == null) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "状态值无效，仅支持 0-下架、1-上架");
        }
        vaccine.setStatus(statusEnum.getCode());
        updateById(vaccine);
    }
}
