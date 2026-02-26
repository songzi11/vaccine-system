package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.DoctorDispatch;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.enums.DoctorDispatchStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.DoctorDispatchVO;
import com.tjut.edu.vaccine_system.mapper.DoctorDispatchMapper;
import com.tjut.edu.vaccine_system.service.DoctorDispatchService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DoctorDispatchServiceImpl extends ServiceImpl<DoctorDispatchMapper, DoctorDispatch> implements DoctorDispatchService {

    private final SysUserService sysUserService;
    private final VaccinationSiteService vaccinationSiteService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void notifyAssigned(Long doctorId, Long fromSiteId, Long toSiteId) {
        if (doctorId == null || toSiteId == null) return;
        DoctorDispatch dispatch = DoctorDispatch.builder()
                .doctorId(doctorId)
                .fromSiteId(fromSiteId)
                .toSiteId(toSiteId)
                .status(DoctorDispatchStatusEnum.NOTIFIED.getCode())
                .applyTime(LocalDateTime.now())
                .build();
        save(dispatch);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markRead(Long id, Long doctorId) {
        DoctorDispatch dispatch = getById(id);
        if (dispatch == null) throw new BizException(BizErrorCode.NOT_FOUND, "派遣信息不存在");
        if (!dispatch.getDoctorId().equals(doctorId)) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "仅本人可标记已读");
        }
        dispatch.setStatus(DoctorDispatchStatusEnum.READ.getCode());
        dispatch.setApproveTime(LocalDateTime.now());
        updateById(dispatch);
    }

    @Override
    public List<DoctorDispatchVO> listByDoctorId(Long doctorId) {
        if (doctorId == null) return List.of();
        List<DoctorDispatch> list = list(new LambdaQueryWrapper<DoctorDispatch>()
                .eq(DoctorDispatch::getDoctorId, doctorId)
                .orderByDesc(DoctorDispatch::getApplyTime));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    public int countUnreadByDoctorId(Long doctorId) {
        if (doctorId == null) return 0;
        return (int) count(new LambdaQueryWrapper<DoctorDispatch>()
                .eq(DoctorDispatch::getDoctorId, doctorId)
                .eq(DoctorDispatch::getStatus, DoctorDispatchStatusEnum.NOTIFIED.getCode()));
    }

    @Override
    public List<DoctorDispatchVO> listAll() {
        List<DoctorDispatch> list = list(new LambdaQueryWrapper<DoctorDispatch>()
                .orderByDesc(DoctorDispatch::getApplyTime));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    public DoctorDispatchVO getVoById(Long id) {
        if (id == null) return null;
        DoctorDispatch d = getById(id);
        return toVO(d);
    }

    private DoctorDispatchVO toVO(DoctorDispatch d) {
        if (d == null) return null;
        SysUser doctor = sysUserService.getById(d.getDoctorId());
        VaccinationSite from = d.getFromSiteId() != null ? vaccinationSiteService.getById(d.getFromSiteId()) : null;
        VaccinationSite to = d.getToSiteId() != null ? vaccinationSiteService.getById(d.getToSiteId()) : null;
        String statusDesc = DoctorDispatchStatusEnum.fromCode(d.getStatus()) != null
                ? DoctorDispatchStatusEnum.fromCode(d.getStatus()).getDesc() : "";
        return DoctorDispatchVO.builder()
                .id(d.getId())
                .doctorId(d.getDoctorId())
                .doctorName(doctor != null ? doctor.getRealName() : null)
                .fromSiteId(d.getFromSiteId())
                .fromSiteName(from != null ? from.getSiteName() : null)
                .toSiteId(d.getToSiteId())
                .toSiteName(to != null ? to.getSiteName() : null)
                .status(d.getStatus())
                .statusDesc(statusDesc)
                .applyTime(d.getApplyTime())
                .approveTime(d.getApproveTime())
                .build();
    }
}
