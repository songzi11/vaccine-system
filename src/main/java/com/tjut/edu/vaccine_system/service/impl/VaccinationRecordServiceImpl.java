package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.model.dto.CreateRecordDTO;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.mapper.VaccinationRecordMapper;
import com.tjut.edu.vaccine_system.mapper.VaccinationSiteMapper;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 接种记录 Service 实现
 */
@Service
@RequiredArgsConstructor
public class VaccinationRecordServiceImpl extends ServiceImpl<VaccinationRecordMapper, VaccinationRecord> implements VaccinationRecordService {

    private final AppointmentService appointmentService;
    private final SysUserService sysUserService;
    private final VaccineService vaccineService;
    private final VaccinationSiteMapper vaccinationSiteMapper;
    private final VaccineSiteStockService vaccineSiteStockService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final VaccineBatchService vaccineBatchService;

    @Override
    public IPage<VaccinationRecord> pageRecords(long current, long size, Long userId, Long childId, Long vaccineId, Long siteId) {
        Page<VaccinationRecord> page = new Page<>(current, size);
        LambdaQueryWrapper<VaccinationRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(userId != null, VaccinationRecord::getUserId, userId)
                .eq(childId != null, VaccinationRecord::getChildId, childId)
                .eq(vaccineId != null, VaccinationRecord::getVaccineId, vaccineId)
                .eq(siteId != null, VaccinationRecord::getSiteId, siteId)
                .orderByDesc(VaccinationRecord::getVaccinationDate);
        return page(page, wrapper);
    }

    @Override
    public VaccinationRecord getLastRecordByChildAndVaccine(Long childId, Long vaccineId) {
        if (childId == null || vaccineId == null) return null;
        List<VaccinationRecord> list = list(new LambdaQueryWrapper<VaccinationRecord>()
                .eq(VaccinationRecord::getChildId, childId)
                .eq(VaccinationRecord::getVaccineId, vaccineId)
                .orderByDesc(VaccinationRecord::getVaccinationDate)
                .last("LIMIT 1"));
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public VaccinationRecord getFirstRecordByChildAndVaccine(Long childId, Long vaccineId) {
        if (childId == null || vaccineId == null) return null;
        List<VaccinationRecord> list = list(new LambdaQueryWrapper<VaccinationRecord>()
                .eq(VaccinationRecord::getChildId, childId)
                .eq(VaccinationRecord::getVaccineId, vaccineId)
                .orderByAsc(VaccinationRecord::getVaccinationDate)
                .last("LIMIT 1"));
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public VaccinationRecord createRecordByAppointment(CreateRecordDTO dto) {
        // 1. 仅医生或管理员可核销
        Long operatorId = dto.getOperatorUserId();
        if (operatorId != null) {
            SysUser operator = sysUserService.getById(operatorId);
            if (operator == null || (!"DOCTOR".equals(operator.getRole()) && !"ADMIN".equals(operator.getRole()))) {
                throw new BizException(BizErrorCode.BAD_REQUEST, "仅医生或管理员可执行接种核销");
            }
        }

        Appointment appointment = appointmentService.getById(dto.getAppointmentId());
        if (appointment == null) throw new BizException(BizErrorCode.APPOINTMENT_NOT_FOUND);
        // 允许 已预约/已排班(1)、已签到(6)、预检通过(7) 的预约进行核销（与使用手册一致：已排班即可核销）
        Integer status = appointment.getStatus();
        boolean canVaccinate = Integer.valueOf(AppointmentStatusEnum.BOOKED.getCode()).equals(status)
                || Integer.valueOf(AppointmentStatusEnum.CHECKED_IN.getCode()).equals(status)
                || Integer.valueOf(AppointmentStatusEnum.PRE_CHECK_PASS.getCode()).equals(status);
        if (!canVaccinate) {
            String statusDesc = AppointmentStatusEnum.fromCode(status) != null ? AppointmentStatusEnum.fromCode(status).getDesc() : String.valueOf(status);
            throw new BizException(BizErrorCode.BAD_REQUEST, "仅已预约/已排班(1)、已签到(6)、预检通过(7)的预约可核销，当前预约状态：" + statusDesc);
        }
        Vaccine vaccine = vaccineService.getById(appointment.getVaccineId());
        if (vaccine == null || !VaccineStatusEnum.isUp(vaccine.getStatus())) {
            throw new BizException(BizErrorCode.VACCINE_OFF_SHELF_CANNOT_RECORD);
        }
        if (operatorId != null && "DOCTOR".equals(Optional.ofNullable(sysUserService.getById(operatorId)).map(SysUser::getRole).orElse(null))) {
            Long appointmentDoctorId = appointment.getDoctorId();
            boolean canVerify = appointmentDoctorId != null && operatorId.equals(appointmentDoctorId);
            if (!canVerify && appointmentDoctorId == null && appointment.getSiteId() != null) {
                VaccinationSite site = vaccinationSiteMapper.selectById(appointment.getSiteId());
                if (site != null && operatorId.equals(site.getCurrentDoctorId())) {
                    canVerify = true;
                }
            }
            if (!canVerify) {
                throw new BizException(BizErrorCode.BAD_REQUEST, "仅该预约的排班医生或该接种点驻场医生可执行核销");
            }
        }

        // 核销使用预约时已锁定的批次（FEFO 已在预约时分配），从接种点库存扣减 locked_stock、available_stock
        Long batchId = appointment.getBatchId();
        if (batchId == null) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "预约未关联批次，无法核销");
        }
        VaccineBatch batch = vaccineBatchService.getById(batchId);
        if (batch == null) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "批次不存在，无法完成核销");
        }
        boolean siteDeducted = siteVaccineStockService.deductOnVerify(appointment.getSiteId(), batchId);
        if (!siteDeducted) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "该接种点该批次锁定库存不足，无法完成核销");
        }

        appointment.setStatus(AppointmentStatusEnum.OBSERVING.getCode());
        appointment.setObserveStartTime(LocalDateTime.now());
        appointmentService.updateById(appointment);

        // 3. 根据当前接种日期 + 疫苗“下一针间隔”计算 next_vaccination_date（vaccine 已在上方校验时加载）
        int doseNumber = dto.getDoseNumber() != null ? dto.getDoseNumber() : 1;
        LocalDateTime vaccinationTime = LocalDateTime.now();
        LocalDate nextDoseDate = null;
        if (vaccine != null && vaccine.getIntervalDays() != null && vaccine.getIntervalDays() > 0) {
            int totalDoses = vaccine.getTotalDoses() != null ? vaccine.getTotalDoses() : 1;
            if (doseNumber < totalDoses) {
                nextDoseDate = vaccinationTime.toLocalDate().plusDays(vaccine.getIntervalDays());
            }
        }

        // 4. 批次与疫苗编号均由后端自动带出，不使用前端传入（batchId 即预约时锁定的批次）
        String batchNoForRecord = batch.getBatchNo();
        String vaccineCode = generateVaccineCode(vaccine, batch, vaccinationTime.toLocalDate());

        // 5. 插入接种记录（vaccineCode 仅通过 builder 写入，无 setter，不可修改）
        VaccinationRecord record = VaccinationRecord.builder()
                .childId(appointment.getChildId())
                .userId(appointment.getUserId())
                .vaccineId(appointment.getVaccineId())
                .siteId(appointment.getSiteId())
                .appointmentId(appointment.getId())
                .batchId(batchId)
                .vaccineCode(vaccineCode)
                .batchNo(batchNoForRecord)
                .vaccinationDate(vaccinationTime)
                .doctorId(operatorId)
                .doseNumber(doseNumber)
                .injectionSite(dto.getInjectionSite())
                .observationOk(dto.getObservationOk())
                .reaction(dto.getReaction())
                .nextDoseDate(nextDoseDate)
                .build();
        save(record);
        return getById(record.getId());
    }

    /**
     * 生成疫苗编号：疫苗简称-接种日期(YYYYMMDD)-批号后6位-当天序号(4位)
     * 序号按 批次+当天 统计接种数量 +1
     */
    private String generateVaccineCode(Vaccine vaccine, VaccineBatch batch, LocalDate vaccinationDate) {
        String shortName = (vaccine.getShortCode() != null && !vaccine.getShortCode().isBlank())
                ? vaccine.getShortCode().trim().toUpperCase()
                : ("V" + vaccine.getId());
        String dateStr = vaccinationDate.format(java.time.format.DateTimeFormatter.BASIC_ISO_DATE);
        String batchSuffix = batch.getBatchNo() != null && batch.getBatchNo().length() >= 6
                ? batch.getBatchNo().substring(batch.getBatchNo().length() - 6)
                : String.format("%6s", batch.getBatchNo() != null ? batch.getBatchNo() : "").replace(' ', '0');
        long todayCount = count(new LambdaQueryWrapper<VaccinationRecord>()
                .eq(VaccinationRecord::getBatchId, batch.getId())
                .apply("DATE(create_time) = {0}", vaccinationDate));
        int seq = (int) todayCount + 1;
        String seqStr = String.format("%04d", seq);
        return shortName + "-" + dateStr + "-" + batchSuffix + "-" + seqStr;
    }

    @Override
    public IPage<VaccinationRecord> pageByDoctorId(long current, long size, Long doctorId) {
        if (doctorId == null) {
            Page<VaccinationRecord> empty = new Page<>(current, size);
            empty.setRecords(List.of());
            empty.setTotal(0);
            return empty;
        }
        Page<VaccinationRecord> page = new Page<>(current, size);
        LambdaQueryWrapper<VaccinationRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(VaccinationRecord::getDoctorId, doctorId)
                .orderByDesc(VaccinationRecord::getVaccinationDate);
        return page(page, wrapper);
    }
}
