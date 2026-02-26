package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.Record;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.RecordVO;
import com.tjut.edu.vaccine_system.mapper.RecordMapper;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.RecordService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 接种记录 Service 实现
 */
@Service
@RequiredArgsConstructor
public class RecordServiceImpl extends ServiceImpl<RecordMapper, Record> implements RecordService {

    private final AppointmentService appointmentService;
    private final ChildProfileService childProfileService;
    private final VaccineService vaccineService;
    private final VaccinationSiteService vaccinationSiteService;
    private final SysUserService sysUserService;
    private final VaccineSiteStockService vaccineSiteStockService;
    private final VaccinationRecordService vaccinationRecordService;

    @Override
    public PageResult<Record> pageRecords(long current, long size, Long userId, Long childId) {
        Page<Record> page = new Page<>(current, size);
        LambdaQueryWrapper<Record> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(userId != null, Record::getUserId, userId)
                .eq(childId != null, Record::getChildId, childId)
                .orderByDesc(Record::getVaccinateTime);
        IPage<Record> result = page(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), result.getCurrent(), result.getSize());
    }

    @Override
    public List<Record> listByUserId(Long userId) {
        if (userId == null) return List.of();
        return list(new LambdaQueryWrapper<Record>()
                .eq(Record::getUserId, userId)
                .orderByDesc(Record::getVaccinateTime));
    }

    @Override
    public List<RecordVO> listByUserIdWithNames(Long userId) {
        List<Record> list = listByUserId(userId);
        return list.stream().map(r -> toRecordVO(r)).toList();
    }

    @Override
    public List<RecordVO> listByChildIdWithNames(Long childId) {
        List<Record> list = listByChildId(childId);
        return list.stream().map(r -> toRecordVO(r)).toList();
    }

    @Override
    public List<RecordVO> listByUserIdMerged(Long userId) {
        if (userId == null) return List.of();
        List<RecordVO> fromRecord = listByUserIdWithNames(userId);
        List<VaccinationRecord> vrList = vaccinationRecordService.lambdaQuery()
                .eq(VaccinationRecord::getUserId, userId)
                .orderByDesc(VaccinationRecord::getVaccinationDate)
                .list();
        List<RecordVO> fromVr = vrList.stream().map(this::vaccinationRecordToVO).collect(Collectors.toList());
        return mergeAndSortByTime(fromRecord, fromVr);
    }

    @Override
    public List<RecordVO> listByChildIdMerged(Long childId) {
        if (childId == null) return List.of();
        List<RecordVO> fromRecord = listByChildIdWithNames(childId);
        List<VaccinationRecord> vrList = vaccinationRecordService.lambdaQuery()
                .eq(VaccinationRecord::getChildId, childId)
                .orderByDesc(VaccinationRecord::getVaccinationDate)
                .list();
        List<RecordVO> fromVr = vrList.stream().map(this::vaccinationRecordToVO).collect(Collectors.toList());
        return mergeAndSortByTime(fromRecord, fromVr);
    }

    private RecordVO vaccinationRecordToVO(VaccinationRecord vr) {
        Vaccine v = vr.getVaccineId() != null ? vaccineService.getById(vr.getVaccineId()) : null;
        VaccinationSite site = vr.getSiteId() != null ? vaccinationSiteService.getById(vr.getSiteId()) : null;
        SysUser doctor = vr.getDoctorId() != null ? sysUserService.getById(vr.getDoctorId()) : null;
        ChildProfile child = vr.getChildId() != null ? childProfileService.getById(vr.getChildId()) : null;
        return RecordVO.builder()
                .id(vr.getId())
                .source("vaccination_record")
                .orderId(vr.getAppointmentId())
                .userId(vr.getUserId())
                .childId(vr.getChildId())
                .childName(child != null ? child.getName() : null)
                .vaccineId(vr.getVaccineId())
                .vaccineName(v != null ? v.getVaccineName() : null)
                .doctorId(vr.getDoctorId())
                .doctorName(doctor != null ? doctor.getRealName() : null)
                .siteId(vr.getSiteId())
                .siteName(site != null ? site.getSiteName() : null)
                .vaccinateTime(vr.getVaccinationDate())
                .status("已接种")
                .remark(vr.getReaction())
                .vaccineCode(vr.getVaccineCode())
                .build();
    }

    private List<RecordVO> mergeAndSortByTime(List<RecordVO> a, List<RecordVO> b) {
        List<RecordVO> merged = new ArrayList<>(a);
        merged.addAll(b);
        merged.sort(Comparator.comparing(RecordVO::getVaccinateTime, Comparator.nullsLast(Comparator.reverseOrder())));
        return merged;
    }

    private RecordVO toRecordVO(Record r) {
        Vaccine v = r.getVaccineId() != null ? vaccineService.getById(r.getVaccineId()) : null;
        VaccinationSite site = r.getSiteId() != null ? vaccinationSiteService.getById(r.getSiteId()) : null;
        SysUser doctor = r.getDoctorId() != null ? sysUserService.getById(r.getDoctorId()) : null;
        ChildProfile child = r.getChildId() != null ? childProfileService.getById(r.getChildId()) : null;
        return RecordVO.builder()
                .id(r.getId())
                .source("record")
                .orderId(r.getOrderId())
                .userId(r.getUserId())
                .childId(r.getChildId())
                .childName(child != null ? child.getName() : null)
                .vaccineId(r.getVaccineId())
                .vaccineName(v != null ? v.getVaccineName() : null)
                .doctorId(r.getDoctorId())
                .doctorName(doctor != null ? doctor.getRealName() : null)
                .siteId(r.getSiteId())
                .siteName(site != null ? site.getSiteName() : null)
                .vaccinateTime(r.getVaccinateTime())
                .status(r.getStatus())
                .remark(r.getRemark())
                .build();
    }

    @Override
    public List<Record> listByChildId(Long childId) {
        if (childId == null) return List.of();
        return list(new LambdaQueryWrapper<Record>()
                .eq(Record::getChildId, childId)
                .orderByDesc(Record::getVaccinateTime));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Record addRecord(Record record) {
        if (record.getStatus() == null || record.getStatus().isBlank()) {
            record.setStatus(Record.STATUS_DONE);
        }
        save(record);
        if (record.getOrderId() != null) {
            Appointment order = appointmentService.getById(record.getOrderId());
            if (order != null) {
                order.setStatus(AppointmentStatusEnum.COMPLETED.getCode());
                appointmentService.updateById(order);
            }
        }
        return getById(record.getId());
    }

    @Override
    public long todayCount() {
        Long count = baseMapper.countToday();
        return count != null ? count : 0L;
    }

    @Override
    public List<Map<String, Object>> vaccineCount() {
        return baseMapper.countByVaccine();
    }

    @Override
    public List<Map<String, Object>> last7days() {
        return baseMapper.countLast7Days();
    }

    @Override
    public long countByDoctorId(Long doctorId) {
        if (doctorId == null) return 0L;
        return count(new LambdaQueryWrapper<Record>().eq(Record::getDoctorId, doctorId));
    }

    @Override
    public List<Record> listByDoctorId(Long doctorId) {
        if (doctorId == null) return List.of();
        return list(new LambdaQueryWrapper<Record>()
                .eq(Record::getDoctorId, doctorId)
                .orderByDesc(Record::getVaccinateTime));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Record finishVaccinateByOrderId(Long orderId) {
        Appointment order = appointmentService.getById(orderId);
        if (order == null) throw new IllegalArgumentException("预约不存在");
        if (!Integer.valueOf(AppointmentStatusEnum.PRE_CHECK_PASS.getCode()).equals(order.getStatus())) {
            throw new IllegalArgumentException("仅预检通过(7)的预约可完成接种，当前状态：" + order.getStatus());
        }
        Vaccine vaccine = vaccineService.getById(order.getVaccineId());
        if (vaccine == null || !VaccineStatusEnum.isUp(vaccine.getStatus())) {
            throw new BizException(BizErrorCode.VACCINE_OFF_SHELF_CANNOT_RECORD);
        }
        Long vaccineId = order.getVaccineId();
        Long siteId = order.getSiteId();
        boolean decremented = vaccineSiteStockService.decrementStock(vaccineId, siteId);
        if (!decremented) throw new IllegalStateException("该接种点该疫苗库存不足，无法完成接种");
        LocalDateTime now = LocalDateTime.now();
        Record record = Record.builder()
                .orderId(order.getId())
                .userId(order.getUserId())
                .childId(order.getChildId())
                .vaccineId(vaccineId)
                .doctorId(order.getDoctorId())
                .siteId(siteId)
                .vaccinateTime(now)
                .status(Record.STATUS_DONE)
                .remark(null)
                .build();
        save(record);
        order.setStatus(AppointmentStatusEnum.OBSERVING.getCode());
        order.setObserveStartTime(now);
        appointmentService.updateById(order);
        return getById(record.getId());
    }
}
