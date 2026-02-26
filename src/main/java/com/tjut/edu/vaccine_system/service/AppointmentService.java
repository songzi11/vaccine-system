package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.dto.CreateAppointmentDTO;
import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.vo.AppointmentListVO;

/**
 * 预约接种 Service（排班先行：选排班→已预约→签到→预检→完成接种）
 */
public interface AppointmentService extends IService<Appointment> {

    IPage<Appointment> pageAppointments(long current, long size, Long userId, Long vaccineId, Long siteId, Integer status, java.util.List<Integer> statusIn, java.time.LocalDate appointmentDate);

    IPage<Appointment> pagePendingBySiteIds(long current, long size, java.util.List<Long> siteIds);

    IPage<Appointment> pageTodayScheduled(long current, long size, Long siteId, Long doctorId);

    IPage<Appointment> pageFutureScheduled(long current, long size, Long siteId, Long doctorId, java.time.LocalDate fromDateInclusive, java.time.LocalDate toDateInclusive);

    /** 预约创建：校验排班、库存，事务内增加 schedule.current_count 并生成订单，状态=已预约(1) */
    Appointment createOrderWithStockCheck(CreateAppointmentDTO dto);

    java.util.List<Appointment> listByDoctorId(Long doctorId);

    long countTodayByDoctorId(Long doctorId);

    long countTodayBySiteId(Long siteId);

    IPage<AppointmentListVO> pageForUser(long current, long size, Long userId, Long childId, String statusType);

    /** 将已预约(1)且超过时段结束+指定小时未核销的预约标记为已过期(4) */
    int expireScheduledAfterSlotEndHours(int hoursAfterSlotEnd);

    /** 用户取消预约：仅本人、且状态为可取消(1/6/7/9/10)时允许，已预约(1)时回退排班名额 */
    void cancelByUser(Long appointmentId, Long userId);
}
