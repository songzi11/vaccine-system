package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.model.entity.Record;
import com.tjut.edu.vaccine_system.model.vo.RecordVO;

import java.util.List;
import java.util.Map;

/**
 * 接种记录 Service（record 表）
 */
public interface RecordService extends IService<Record> {

    /**
     * 分页查询记录
     */
    PageResult<Record> pageRecords(long current, long size, Long userId, Long childId);

    /**
     * 根据用户查询接种记录（列表，不分页）
     */
    List<Record> listByUserId(Long userId);

    /**
     * 根据用户查询接种记录（含疫苗名、接种点名、医生名，供前端「我的接种记录」）
     */
    List<RecordVO> listByUserIdWithNames(Long userId);

    /**
     * 根据宝宝查询接种记录（列表，不分页）
     */
    List<Record> listByChildId(Long childId);

    /**
     * 根据宝宝查询接种记录（含疫苗名、接种点名、医生名、宝宝名，供接种证/记录页）
     */
    List<RecordVO> listByChildIdWithNames(Long childId);

    /**
     * 用户端：合并 record 与 vaccination_record，按接种时间倒序（实时同步两种来源的接种记录）
     */
    List<RecordVO> listByUserIdMerged(Long userId);

    /**
     * 用户端：按宝宝合并 record 与 vaccination_record，按接种时间倒序
     */
    List<RecordVO> listByChildIdMerged(Long childId);

    /**
     * 新增记录，并自动将关联的 order(appointment) 状态更新为已完成
     *
     * @param record 接种记录
     * @return 新增后的记录
     */
    Record addRecord(Record record);

    /**
     * 医生完成接种：根据预约ID校验状态=已预约/已签到/预检通过等，插入 record，更新 order 为已完成（可预留库存扣减）
     *
     * @param orderId 预约ID（appointment.id）
     * @return 新增的接种记录
     */
    Record finishVaccinateByOrderId(Long orderId);

    /**
     * 今日接种人数（record 表，供 Dashboard）
     */
    long todayCount();

    /**
     * 各疫苗接种次数（group by vaccine_id，供 Echarts）
     */
    List<Map<String, Object>> vaccineCount();

    /**
     * 近7天每日接种数（供 Echarts 折线图）
     */
    List<Map<String, Object>> last7days();

    /**
     * 按医生 ID 统计接种记录数（历史接种数）
     */
    long countByDoctorId(Long doctorId);

    /**
     * 按医生 ID 查询接种记录列表（不分页）
     */
    List<Record> listByDoctorId(Long doctorId);
}
