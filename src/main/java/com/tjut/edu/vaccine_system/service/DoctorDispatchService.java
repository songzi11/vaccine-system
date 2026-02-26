package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.DoctorDispatch;
import com.tjut.edu.vaccine_system.model.vo.DoctorDispatchVO;

import java.util.List;

/**
 * 医生调遣 Service（简化：管理员指派后推送信息，医生标记已读）
 */
public interface DoctorDispatchService extends IService<DoctorDispatch> {

    /**
     * 管理员指派驻场医生时调用：向该医生推送一条派遣信息（status=已推送）
     */
    void notifyAssigned(Long doctorId, Long fromSiteId, Long toSiteId);

    /**
     * 医生标记已读
     */
    void markRead(Long id, Long doctorId);

    /**
     * 医生端：我的派遣信息列表
     */
    List<DoctorDispatchVO> listByDoctorId(Long doctorId);

    /**
     * 医生端：未读调遣通知数量（用于红点展示）
     */
    int countUnreadByDoctorId(Long doctorId);

    /**
     * 管理员：全部派遣记录列表
     */
    List<DoctorDispatchVO> listAll();

    DoctorDispatchVO getVoById(Long id);
}
