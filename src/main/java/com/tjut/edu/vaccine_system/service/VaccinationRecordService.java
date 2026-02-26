package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.dto.CreateRecordDTO;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;

import java.time.LocalDateTime;

/**
 * 接种记录 Service
 */
public interface VaccinationRecordService extends IService<VaccinationRecord> {

    /**
     * 分页查询接种记录（支持按家长 userId 或儿童 childId 查时间线）
     */
    IPage<VaccinationRecord> pageRecords(long current, long size, Long userId, Long childId, Long vaccineId, Long siteId);

    /**
     * 查询某儿童某疫苗的最近一次接种记录（用于间隔天数校验）
     *
     * @param childId   儿童档案ID
     * @param vaccineId 疫苗ID
     * @return 最近一条记录，无则 null
     */
    VaccinationRecord getLastRecordByChildAndVaccine(Long childId, Long vaccineId);

    /**
     * 查询某儿童某疫苗的第一次接种记录（用于同疫苗后续针只能由首针医生接种的校验）
     *
     * @param childId   儿童档案ID
     * @param vaccineId 疫苗ID
     * @return 第一次接种记录，无则 null
     */
    VaccinationRecord getFirstRecordByChildAndVaccine(Long childId, Long vaccineId);

    /**
     * 接种核销：根据预约 ID 将预约状态改为 COMPLETED，并插入一条接种记录（仅医生/管理员）
     *
     * @param dto 含 appointmentId、operatorUserId
     * @return 新增的接种记录
     */
    VaccinationRecord createRecordByAppointment(CreateRecordDTO dto);

    /**
     * 按医生 ID 分页查询接种记录（供医生工作台「接种过的宝宝记录」）
     */
    IPage<VaccinationRecord> pageByDoctorId(long current, long size, Long doctorId);
}
