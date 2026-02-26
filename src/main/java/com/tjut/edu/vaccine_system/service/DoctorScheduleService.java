package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.DoctorSchedule;

import java.time.LocalDate;
import java.util.List;

/**
 * 医生排班 Service（排班先行）
 */
public interface DoctorScheduleService extends IService<DoctorSchedule> {

    /**
     * 用户端：可预约的排班列表（某接种点、日期起、启用且未满）
     */
    List<DoctorSchedule> listAvailable(Long siteId, LocalDate fromDate, LocalDate toDate);

    /**
     * 用户端：某接种点在日期范围内的全部排班（启用状态，含已约满的），用于展示驻场医生排班与“已约”状态。
     * 不按容量过滤，返回 currentCount/maxCapacity 供前端判断是否已约。
     */
    List<DoctorSchedule> listBySiteAndDateRange(Long siteId, LocalDate fromDate, LocalDate toDate);

    /**
     * 管理员：分页查询排班
     */
    IPage<DoctorSchedule> page(long current, long size, Long doctorId, Long siteId, LocalDate scheduleDate, Integer status);

    /**
     * 排班已预约数 +1（仅当 status=启用 且 current_count < max_capacity 时更新，事务内调用）
     * @return 是否更新成功
     */
    boolean incrementCurrentCount(Long scheduleId);

    /**
     * 排班已预约数 -1（用户取消预约时回退名额，仅当 current_count > 0 时更新，事务内调用）
     * @return 是否更新成功
     */
    boolean decrementCurrentCount(Long scheduleId);
}
