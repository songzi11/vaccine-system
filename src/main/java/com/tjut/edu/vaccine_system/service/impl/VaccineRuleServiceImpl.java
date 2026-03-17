package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.mapper.VaccineRuleMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineRule;
import com.tjut.edu.vaccine_system.service.VaccineRuleService;
import org.springframework.stereotype.Service;

/**
 * 疫苗规则 Service 实现
 */
@Service
public class VaccineRuleServiceImpl extends ServiceImpl<VaccineRuleMapper, VaccineRule> implements VaccineRuleService {
}