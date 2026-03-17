package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.dto.CreateAppointmentDTO;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.DoctorSchedule;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.ScheduleStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.AppointmentListVO;
import com.tjut.edu.vaccine_system.model.vo.ScheduleVO;
import com.tjut.edu.vaccine_system.model.enums.SiteStatusEnum;
import com.tjut.edu.vaccine_system.mapper.AppointmentMapper;
import com.tjut.edu.vaccine_system.mapper.VaccinationRecordMapper;
import com.tjut.edu.vaccine_system.mapper.VaccinationSiteMapper;
import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.engine.RuleEngine;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.DoctorScheduleService;
import com.tjut.edu.vaccine_system.service.NoticeService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.VaccineBatchService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import com.tjut.edu.vaccine_system.model.entity.SiteVaccineStock;
import com.tjut.edu.vaccine_system.model.entity.VaccineBatch;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 预约接种 Service 实现
 * 排班先行：家长选 doctor_schedule_id 预约 → 状态=已预约(1) → 签到(6)→预检(7/9)→完成接种(写记录、扣库存、状态=10留观→2已完成)
 */
@Service
@RequiredArgsConstructor
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment> implements AppointmentService {

    private final SysUserService sysUserService;
    private final ChildProfileService childProfileService;
    private final VaccineService vaccineService;
    private final VaccinationSiteMapper vaccinationSiteMapper;
    private final VaccinationRecordMapper vaccinationRecordMapper;
    private final DoctorScheduleService doctorScheduleService;
    private final VaccineSiteStockService vaccineSiteStockService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final VaccineBatchService vaccineBatchService;
    private final NoticeService noticeService;
    private final RuleEngine ruleEngine;

    @Override
    public IPage<Appointment> pageAppointments(long current, long size, Long userId, Long vaccineId, Long siteId, Integer status, List<Integer> statusIn, LocalDate appointmentDate) {
        Page<Appointment> page = new Page<>(current, size);
        LambdaQueryWrapper<Appointment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(userId != null, Appointment::getUserId, userId)
                .eq(vaccineId != null, Appointment::getVaccineId, vaccineId)
                .eq(siteId != null, Appointment::getSiteId, siteId)
                .eq(appointmentDate != null, Appointment::getAppointmentDate, appointmentDate);
        if (statusIn != null && !statusIn.isEmpty()) {
            wrapper.in(Appointment::getStatus, statusIn);
        } else if (status != null) {
            wrapper.eq(Appointment::getStatus, status);
        }
        wrapper.orderByDesc(Appointment::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    public IPage<Appointment> pagePendingBySiteIds(long current, long size, List<Long> siteIds) {
        if (siteIds == null || siteIds.isEmpty()) {
            Page<Appointment> empty = new Page<>(current, size);
            empty.setRecords(List.of());
            empty.setTotal(0);
            return empty;
        }
        Page<Appointment> page = new Page<>(current, size);
        LambdaQueryWrapper<Appointment> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(Appointment::getSiteId, siteIds)
                .eq(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode())
                .orderByDesc(Appointment::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    public IPage<Appointment> pageTodayScheduled(long current, long size, Long siteId, Long doctorId) {
        Page<Appointment> page = new Page<>(current, size);
        LambdaQueryWrapper<Appointment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode())
                .eq(Appointment::getAppointmentDate, LocalDate.now())
                .eq(siteId != null, Appointment::getSiteId, siteId)
                .eq(doctorId != null, Appointment::getDoctorId, doctorId);
        wrapper.orderByAsc(Appointment::getTimeSlot).orderByDesc(Appointment::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    public IPage<Appointment> pageFutureScheduled(long current, long size, Long siteId, Long doctorId, LocalDate fromDateInclusive, LocalDate toDateInclusive) {
        if (fromDateInclusive == null || toDateInclusive == null || !fromDateInclusive.isBefore(toDateInclusive)) {
            Page<Appointment> empty = new Page<>(current, size);
            empty.setRecords(List.of());
            empty.setTotal(0);
            return empty;
        }
        Page<Appointment> page = new Page<>(current, size);
        LambdaQueryWrapper<Appointment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode())
                .ge(Appointment::getAppointmentDate, fromDateInclusive)
                .le(Appointment::getAppointmentDate, toDateInclusive)
                .eq(siteId != null, Appointment::getSiteId, siteId)
                .eq(doctorId != null, Appointment::getDoctorId, doctorId);
        wrapper.orderByAsc(Appointment::getAppointmentDate)
                .orderByAsc(Appointment::getTimeSlot)
                .orderByDesc(Appointment::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Appointment createOrderWithStockCheck(CreateAppointmentDTO dto) {
        Long userId = dto.getUserId();
        if (userId == null) throw new BizException(BizErrorCode.LOGIN_REQUIRED);
        SysUser user = sysUserService.getById(userId);
        if (user == null || !"RESIDENT".equals(user.getRole())) {
            throw new BizException(BizErrorCode.ROLE_NOT_RESIDENT);
        }
        if (user.getReservationBanUntil() != null && LocalDateTime.now().isBefore(user.getReservationBanUntil())) {
            throw new BizException(BizErrorCode.RESERVATION_BANNED,
                    "因爽约次数过多，三十日内不可预约。解禁时间：" + user.getReservationBanUntil().toLocalDate());
        }

        Long doctorScheduleId = dto.getDoctorScheduleId();
        if (doctorScheduleId == null) throw new BizException(BizErrorCode.SCHEDULE_REQUIRED);

        DoctorSchedule schedule = doctorScheduleService.getById(doctorScheduleId);
        if (schedule == null) throw new BizException(BizErrorCode.SCHEDULE_NOT_FOUND);
        if (!ScheduleStatusEnum.isEnabled(schedule.getStatus())) {
            throw new BizException(BizErrorCode.SCHEDULE_NOT_AVAILABLE);
        }
        // 一个排班只能被一个预约使用
        int maxCap = schedule.getMaxCapacity() != null ? schedule.getMaxCapacity() : 1;
        int curCount = schedule.getCurrentCount() != null ? schedule.getCurrentCount() : 0;
        if (curCount >= maxCap) {
            throw new BizException(BizErrorCode.SCHEDULE_NOT_AVAILABLE, "该时段已被预约，请选择其他时段");
        }
        // 额外检查：是否已有进行中的预约使用了这个排班（包括已完成的，已完成也不能再预约）
        boolean alreadyBooked = count(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getDoctorScheduleId, doctorScheduleId)
                .in(Appointment::getStatus,
                        AppointmentStatusEnum.BOOKED.getCode(),
                        AppointmentStatusEnum.CHECKED_IN.getCode(),
                        AppointmentStatusEnum.PRE_CHECK_PASS.getCode(),
                        AppointmentStatusEnum.OBSERVING.getCode(),
                        AppointmentStatusEnum.COMPLETED.getCode())) > 0;
        if (alreadyBooked) {
            throw new BizException(BizErrorCode.SCHEDULE_NOT_AVAILABLE, "该时段已被预约，请选择其他时段");
        }

        Long siteId = schedule.getSiteId();
        Long doctorId = schedule.getDoctorId();
        LocalDate appointmentDate = schedule.getScheduleDate();
        String timeSlot = schedule.getTimeSlot() != null ? schedule.getTimeSlot() : "";

        // 检查时段是否已过期（当天且当前时间已超过时段结束时间）
        if (appointmentDate.equals(LocalDate.now())) {
            if (isTimeSlotExpired(timeSlot, LocalDateTime.now())) {
                throw new BizException(BizErrorCode.SCHEDULE_NOT_AVAILABLE, "该时段已过期，请选择其他时段");
            }
        }

        VaccinationSite site = vaccinationSiteMapper.selectById(siteId);
        if (site == null || !Integer.valueOf(SiteStatusEnum.ENABLED.getCode()).equals(site.getStatus())) {
            throw new BizException(BizErrorCode.SITE_DISABLED);
        }

        Long vaccineId = dto.getVaccineId();
        Long childId = dto.getChildId();
        if (childId == null) throw new BizException(BizErrorCode.CHILD_REQUIRED);
        ChildProfile child = childProfileService.getById(childId);
        if (child == null) throw new BizException(BizErrorCode.CHILD_NOT_FOUND);
        if (!child.getParentId().equals(userId)) throw new BizException(BizErrorCode.CHILD_NOT_OWNED);

        List<Appointment> pendingForChild = list(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getChildId, childId)
                .in(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode(), AppointmentStatusEnum.CHECKED_IN.getCode(),
                        AppointmentStatusEnum.PRE_CHECK_PASS.getCode(), AppointmentStatusEnum.OBSERVING.getCode()));
        if (!pendingForChild.isEmpty()) {
            throw new BizException(BizErrorCode.DUPLICATE_PENDING_APPOINTMENT);
        }

        List<Appointment> sameDaySameVaccine = list(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getChildId, childId)
                .eq(Appointment::getVaccineId, vaccineId)
                .eq(Appointment::getAppointmentDate, appointmentDate)
                .in(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode(), AppointmentStatusEnum.CHECKED_IN.getCode(),
                        AppointmentStatusEnum.PRE_CHECK_PASS.getCode(), AppointmentStatusEnum.OBSERVING.getCode()));
        if (!sameDaySameVaccine.isEmpty()) {
            throw new BizException(BizErrorCode.DUPLICATE_SAME_DAY_VACCINE);
        }

        Vaccine vaccine = vaccineService.getById(vaccineId);
        if (vaccine == null || !VaccineStatusEnum.isUp(vaccine.getStatus())) {
            throw new BizException(BizErrorCode.VACCINE_NOT_AVAILABLE, "该疫苗已下架，无法预约");
        }

        // 查询同疫苗上次接种记录（用于间隔校验）
        List<VaccinationRecord> lastList = vaccinationRecordMapper.selectList(
                new LambdaQueryWrapper<VaccinationRecord>()
                        .eq(VaccinationRecord::getChildId, childId)
                        .eq(VaccinationRecord::getVaccineId, vaccineId)
                        .orderByDesc(VaccinationRecord::getVaccinationDate)
                        .last("LIMIT 1"));
        VaccinationRecord lastRecord = lastList.isEmpty() ? null : lastList.get(0);
        LocalDate lastVaccinationDate = lastRecord != null ? lastRecord.getVaccinationDate().toLocalDate() : null;

        // 使用规则引擎进行校验（年龄、间隔、禁忌症）
        AppointmentRuleContext ruleContext = AppointmentRuleContext.builder()
                .childId(childId)
                .birthDate(child.getBirthDate())
                .vaccineId(vaccineId)
                .applicableAgeMonths(vaccine.getApplicableAgeMonths())
                .intervalDays(vaccine.getIntervalDays())
                .contraindicationAllergy(child.getContraindicationAllergy())
                .vaccineDescription(vaccine.getDescription())
                .adverseReactionDesc(vaccine.getAdverseReactionDesc())
                .appointmentDate(appointmentDate)
                .lastVaccinationDate(lastVaccinationDate)
                .build();

        RuleResult ruleResult = ruleEngine.validate("APPOINTMENT", ruleContext);
        if (!ruleResult.isPassed()) {
            throw new BizException(BizErrorCode.BAD_REQUEST, ruleResult.getErrorMessage());
        }

        // 从接种点库存（site_vaccine_stock）查可用量，FEFO 锁定
        int stock = siteVaccineStockService.getAvailableStock(vaccineId, siteId);
        if (stock <= 0) throw new BizException(BizErrorCode.STOCK_INSUFFICIENT);

        SiteVaccineStock fefoRow = siteVaccineStockService.getFefoStockRow(siteId, vaccineId);
        if (fefoRow == null) throw new BizException(BizErrorCode.NO_AVAILABLE_BATCH);
        boolean locked = siteVaccineStockService.lockStock(fefoRow.getId());
        if (!locked) throw new BizException(BizErrorCode.NO_AVAILABLE_BATCH);
        Long batchId = fefoRow.getBatchId();

        boolean incremented = doctorScheduleService.incrementCurrentCount(doctorScheduleId);
        if (!incremented) {
            throw new BizException(BizErrorCode.SCHEDULE_NOT_AVAILABLE);
        }

        Appointment appointment = new Appointment();
        appointment.setUserId(userId);
        appointment.setChildId(childId);
        appointment.setVaccineId(vaccineId);
        appointment.setSiteId(siteId);
        appointment.setDoctorScheduleId(doctorScheduleId);
        appointment.setDoctorId(doctorId);
        appointment.setAppointmentDate(appointmentDate);
        appointment.setTimeSlot(timeSlot);
        appointment.setRemark(dto.getRemark());
        appointment.setStatus(AppointmentStatusEnum.BOOKED.getCode());
        appointment.setBatchId(batchId);
        save(appointment);
        return getById(appointment.getId());
    }

    @Override
    public List<Appointment> listByDoctorId(Long doctorId) {
        if (doctorId == null) return List.of();
        return list(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getDoctorId, doctorId)
                .orderByDesc(Appointment::getAppointmentDate)
                .orderByDesc(Appointment::getCreateTime));
    }

    @Override
    public long countTodayByDoctorId(Long doctorId) {
        if (doctorId == null) return 0L;
        return count(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getDoctorId, doctorId)
                .eq(Appointment::getAppointmentDate, LocalDate.now()));
    }

    @Override
    public long countTodayBySiteId(Long siteId) {
        if (siteId == null) return 0L;
        return count(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getSiteId, siteId)
                .eq(Appointment::getAppointmentDate, LocalDate.now()));
    }

    @Override
    public IPage<AppointmentListVO> pageForUser(long current, long size, Long userId, Long childId, String statusType) {
        List<Integer> statusIn = null;
        if (statusType != null && !statusType.isBlank()) {
            switch (statusType.trim().toLowerCase()) {
                case "pending":
                    statusIn = List.of(AppointmentStatusEnum.BOOKED.getCode(), AppointmentStatusEnum.CHECKED_IN.getCode(),
                            AppointmentStatusEnum.PRE_CHECK_PASS.getCode(), AppointmentStatusEnum.OBSERVING.getCode());
                    break;
                case "approved":
                    statusIn = List.of(AppointmentStatusEnum.BOOKED.getCode(), AppointmentStatusEnum.CHECKED_IN.getCode(),
                            AppointmentStatusEnum.PRE_CHECK_PASS.getCode(), AppointmentStatusEnum.OBSERVING.getCode());
                    break;
                case "rejected":
                    statusIn = List.of(AppointmentStatusEnum.PRE_CHECK_FAIL.getCode(), AppointmentStatusEnum.CANCELLED.getCode());
                    break;
                case "ended":
                    statusIn = List.of(AppointmentStatusEnum.COMPLETED.getCode(), AppointmentStatusEnum.EXPIRED.getCode());
                    break;
                case "cancelled":
                    statusIn = List.of(AppointmentStatusEnum.CANCELLED.getCode());
                    break;
                default:
                    break;
            }
        }
        IPage<Appointment> page;
        if (childId != null) {
            Page<Appointment> p = new Page<>(current, size);
            LambdaQueryWrapper<Appointment> w = new LambdaQueryWrapper<>();
            w.eq(Appointment::getUserId, userId).eq(Appointment::getChildId, childId);
            if (statusIn != null && !statusIn.isEmpty()) w.in(Appointment::getStatus, statusIn);
            w.orderByDesc(Appointment::getCreateTime);
            page = page(p, w);
        } else {
            page = pageAppointments(current, size, userId, null, null, null, statusIn, null);
        }
        List<AppointmentListVO> voList = new ArrayList<>();
        for (Appointment a : page.getRecords()) {
            Vaccine v = a.getVaccineId() != null ? vaccineService.getById(a.getVaccineId()) : null;
            ChildProfile c = a.getChildId() != null ? childProfileService.getById(a.getChildId()) : null;
            VaccinationSite s = a.getSiteId() != null ? vaccinationSiteMapper.selectById(a.getSiteId()) : null;
            // 检查医生是否可用（状态为正常）
            boolean doctorUnavailable = false;
            if (a.getDoctorId() != null) {
                SysUser doctor = sysUserService.getById(a.getDoctorId());
                doctorUnavailable = doctor == null || !Integer.valueOf(UserStatusEnum.NORMAL.getCode()).equals(doctor.getStatus());
            }
            voList.add(AppointmentListVO.builder()
                    .id(a.getId())
                    .userId(a.getUserId())
                    .childId(a.getChildId())
                    .vaccineId(a.getVaccineId())
                    .siteId(a.getSiteId())
                    .appointmentDate(a.getAppointmentDate())
                    .timeSlot(a.getTimeSlot())
                    .status(a.getStatus())
                    .statusLabel(AppointmentStatusEnum.fromCode(a.getStatus()) != null ? AppointmentStatusEnum.fromCode(a.getStatus()).getDesc() : null)
                    .doctorId(a.getDoctorId())
                    .remark(a.getRemark())
                    .createTime(a.getCreateTime())
                    .updateTime(a.getUpdateTime())
                    .vaccineName(v != null ? v.getVaccineName() : null)
                    .childName(c != null ? c.getName() : null)
                    .siteName(s != null ? s.getSiteName() : null)
                    .doctorUnavailable(doctorUnavailable)
                    .build());
        }
        Page<AppointmentListVO> result = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        result.setRecords(voList);
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int expireScheduledAfterSlotEndHours(int hoursAfterSlotEnd) {
        if (hoursAfterSlotEnd < 0) return 0;
        List<Appointment> scheduled = list(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getStatus, AppointmentStatusEnum.BOOKED.getCode()));
        LocalDateTime now = LocalDateTime.now();
        int expiredCount = 0;
        for (Appointment a : scheduled) {
            LocalDate date = a.getAppointmentDate();
            if (date == null) continue;
            LocalTime slotEndTime = parseTimeSlotEnd(a.getTimeSlot());
            LocalDateTime slotEnd = date.atTime(slotEndTime);
            LocalDateTime expireDeadline = slotEnd.plusHours(hoursAfterSlotEnd);
            if (now.isAfter(expireDeadline)) {
                a.setStatus(AppointmentStatusEnum.EXPIRED.getCode());
                updateById(a);
                expiredCount++;
                // 用户端惩罚机制：每次爽约推送警告公告（仅该用户可见、红色框）；满三次推送冻结公告；当日逾期未核销超过3次则30日禁约
                applyNoShowPunishment(a.getUserId(), date);
            }
        }
        return expiredCount;
    }

    /**
     * 爽约惩罚：1）推送一条仅该用户可见的警告公告（WARNING 红色框）；2）当日逾期未核销超过3次（≥4次）则禁约30日；3）累计爽约满3次推送冻结账号公告
     */
    private void applyNoShowPunishment(Long userId, LocalDate appointmentDate) {
        if (userId == null) return;
        // 1. 每次爽约：管理员端自动推送警告公告，仅该用户可见、红色框装饰
        noticeService.createSystemNoticeForUser(userId, "WARNING", "预约爽约警告",
                "您于" + appointmentDate + "的预约未按时核销，记爽约一次。请按时履约，累计爽约将影响预约资格。");
        // 2. 当日逾期未核销超过3次（即≥4次）则三十日内不得再次预约
        long sameDayExpired = count(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getUserId, userId)
                .eq(Appointment::getAppointmentDate, appointmentDate)
                .eq(Appointment::getStatus, AppointmentStatusEnum.EXPIRED.getCode()));
        if (sameDayExpired >= 4) {
            SysUser u = sysUserService.getById(userId);
            if (u != null) {
                u.setReservationBanUntil(LocalDateTime.now().plusDays(30));
                sysUserService.updateById(u);
            }
        }
        // 3. 累计爽约满3次：发送冻结账号功能公告（仅该用户可见）
        long totalExpired = count(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getUserId, userId)
                .eq(Appointment::getStatus, AppointmentStatusEnum.EXPIRED.getCode()));
        if (totalExpired == 3) {
            noticeService.createSystemNoticeForUser(userId, "FROZEN", "账号预约冻结通知",
                    "您已累计爽约3次，三十日内不可预约，请按时履约。");
        }
    }

    /**
     * 解析时段字符串的结束时间。格式 "HH:mm-HH:mm" 取后半段；否则按当日 23:59 计。
     */
    private static LocalTime parseTimeSlotEnd(String timeSlot) {
        if (timeSlot == null || timeSlot.isBlank()) return LocalTime.of(23, 59);
        String s = timeSlot.trim();
        int dash = s.indexOf('-');
        if (dash >= 0 && dash < s.length() - 1) {
            String endPart = s.substring(dash + 1).trim();
            if (!endPart.isEmpty()) {
                try {
                    return LocalTime.parse(endPart);
                } catch (DateTimeParseException ignored) {
                    // fallback
                }
            }
        }
        try {
            return LocalTime.parse(s);
        } catch (DateTimeParseException ignored) {
            return LocalTime.of(23, 59);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelByUser(Long appointmentId, Long userId) {
        if (appointmentId == null || userId == null) {
            throw new IllegalArgumentException("预约ID和用户ID不能为空");
        }
        Appointment a = getById(appointmentId);
        if (a == null) throw new BizException(BizErrorCode.BAD_REQUEST, "预约不存在");
        if (!userId.equals(a.getUserId())) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "只能取消本人的预约");
        }
        int status = a.getStatus() != null ? a.getStatus() : -1;
        // 可取消：1已预约 6已签到 7预检通过 9预检未通过 10留观中
        boolean canCancel = status == AppointmentStatusEnum.BOOKED.getCode()
                || status == AppointmentStatusEnum.CHECKED_IN.getCode()
                || status == AppointmentStatusEnum.PRE_CHECK_PASS.getCode()
                || status == AppointmentStatusEnum.PRE_CHECK_FAIL.getCode()
                || status == AppointmentStatusEnum.OBSERVING.getCode();
        if (!canCancel) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "当前状态不可取消（已完成/已取消/已过期）");
        }
        if (status == AppointmentStatusEnum.BOOKED.getCode() && a.getDoctorScheduleId() != null) {
            doctorScheduleService.decrementCurrentCount(a.getDoctorScheduleId());
        }
        // 取消时回滚接种点锁定库存（site_vaccine_stock: locked -1, available +1）
        if (a.getBatchId() != null && a.getSiteId() != null) {
            siteVaccineStockService.unlockStock(a.getSiteId(), a.getBatchId());
        }
        a.setStatus(AppointmentStatusEnum.CANCELLED.getCode());
        updateById(a);
    }

    private static LocalDate parseDateOrThrow(String dateStr, String fieldName) {
        if (dateStr == null || dateStr.isBlank()) {
            throw new IllegalArgumentException(fieldName + "不能为空");
        }
        String trimmed = dateStr.trim();
        if (trimmed.length() != 10 || trimmed.charAt(4) != '-' || trimmed.charAt(7) != '-') {
            throw new IllegalArgumentException(fieldName + "格式应为 yyyy-MM-dd，例如 2025-12-12");
        }
        try {
            return LocalDate.parse(trimmed);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(fieldName + "格式应为 yyyy-MM-dd，例如 2025-12-12");
        }
    }

    @Override
    public List<ScheduleVO> listSchedulesWithBookedStatus(Long siteId, LocalDate fromDate, LocalDate toDate) {
        // 1. 获取排班列表
        List<DoctorSchedule> schedules = doctorScheduleService.listBySiteAndDateRange(siteId, fromDate, toDate);
        if (schedules == null || schedules.isEmpty()) {
            return List.of();
        }

        // 2. 获取这些排班中已被预约的ID集合（状态为已预约、已签到、预检通过、留观中、已完成）
        List<Long> scheduleIds = schedules.stream()
                .map(DoctorSchedule::getId)
                .collect(Collectors.toList());

        List<Appointment> bookedAppointments = list(new LambdaQueryWrapper<Appointment>()
                .in(Appointment::getDoctorScheduleId, scheduleIds)
                .in(Appointment::getStatus,
                        AppointmentStatusEnum.BOOKED.getCode(),
                        AppointmentStatusEnum.CHECKED_IN.getCode(),
                        AppointmentStatusEnum.PRE_CHECK_PASS.getCode(),
                        AppointmentStatusEnum.OBSERVING.getCode(),
                        AppointmentStatusEnum.COMPLETED.getCode()));

        Set<Long> bookedScheduleIds = bookedAppointments.stream()
                .map(Appointment::getDoctorScheduleId)
                .collect(Collectors.toSet());

        // 3. 组装VO，标记是否已被预约和是否已过期
        LocalDateTime now = LocalDateTime.now();
        LocalDate today = LocalDate.now();

        return schedules.stream().map(s -> {
            boolean isBooked = bookedScheduleIds.contains(s.getId());
            // 判断是否已过期：当天且当前时间已超过时段结束时间
            boolean isExpired = false;
            if (s.getScheduleDate() != null && s.getTimeSlot() != null && s.getScheduleDate().equals(today)) {
                isExpired = isTimeSlotExpired(s.getTimeSlot(), now);
            }
            return ScheduleVO.builder()
                    .id(s.getId())
                    .doctorId(s.getDoctorId())
                    .doctorName(null) // 如需医生姓名，可额外查询
                    .siteId(s.getSiteId())
                    .scheduleDate(s.getScheduleDate())
                    .timeSlot(s.getTimeSlot())
                    .maxCapacity(1) // 固定为1，表示只能预约一个孩子
                    .currentCount(isBooked ? 1 : 0)
                    .booked(isBooked)
                    .expired(isExpired)
                    .status(s.getStatus())
                    .build();
        }).collect(Collectors.toList());
    }

    /**
     * 判断时段是否已过期
     * @param timeSlot 时段，格式如 "08:00-08:15"
     * @param now 当前时间
     * @return true=已过期，false=未过期
     */
    private boolean isTimeSlotExpired(String timeSlot, LocalDateTime now) {
        if (timeSlot == null || !timeSlot.contains("-")) {
            return false;
        }
        try {
            String[] parts = timeSlot.split("-");
            if (parts.length < 2) {
                return false;
            }
            // 解析时段结束时间
            String endTimeStr = parts[1].trim();
            String[] endParts = endTimeStr.split(":");
            if (endParts.length < 2) {
                return false;
            }
            int endHour = Integer.parseInt(endParts[0]);
            int endMinute = Integer.parseInt(endParts[1]);

            // 构建时段结束时间的 LocalDateTime
            LocalDateTime slotEndTime = now.withHour(endHour).withMinute(endMinute).withSecond(0).withNano(0);

            // 如果当前时间大于时段结束时间，则已过期
            return now.isAfter(slotEndTime);
        } catch (Exception e) {
            // 解析失败，默认不过期
            return false;
        }
    }

    @Override
    public int completeObservationExpired() {
        // 查询所有留观中的预约
        List<Appointment> observingList = list(new LambdaQueryWrapper<Appointment>()
                .eq(Appointment::getStatus, AppointmentStatusEnum.OBSERVING.getCode())
                .isNotNull(Appointment::getObserveStartTime));

        if (observingList == null || observingList.isEmpty()) {
            return 0;
        }

        int completedCount = 0;
        LocalDateTime now = LocalDateTime.now();

        for (Appointment appointment : observingList) {
            LocalDateTime observeStartTime = appointment.getObserveStartTime();
            Integer observeDuration = appointment.getObserveDuration();

            if (observeStartTime == null) {
                continue;
            }

            // 默认留观30分钟
            int durationMinutes = (observeDuration != null && observeDuration > 0) ? observeDuration : 30;
            LocalDateTime observeEndTime = observeStartTime.plusMinutes(durationMinutes);

            // 如果留观时间已到，更新为已完成
            if (now.isAfter(observeEndTime) || now.isEqual(observeEndTime)) {
                appointment.setStatus(AppointmentStatusEnum.COMPLETED.getCode());
                updateById(appointment);
                completedCount++;
            }
        }

        return completedCount;
    }
}
