package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.dto.SiteDTO;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.VaccineSiteStock;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.model.enums.SiteStatusEnum;
import com.tjut.edu.vaccine_system.model.vo.SiteDetailVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockVO;
import com.tjut.edu.vaccine_system.model.vo.SiteVO;
import com.tjut.edu.vaccine_system.model.vo.SiteWithStockVO;
import com.tjut.edu.vaccine_system.mapper.VaccinationSiteMapper;
import com.tjut.edu.vaccine_system.service.AppointmentService;
import com.tjut.edu.vaccine_system.service.DoctorDispatchService;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.StockTransferService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import com.tjut.edu.vaccine_system.service.VaccineSiteStockService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class VaccinationSiteServiceImpl extends ServiceImpl<VaccinationSiteMapper, VaccinationSite> implements VaccinationSiteService {

    private final SysUserService sysUserService;
    private final VaccineSiteStockService vaccineSiteStockService;
    private final SiteVaccineStockService siteVaccineStockService;
    private final VaccineService vaccineService;
    private final AppointmentService appointmentService;
    private final DoctorDispatchService doctorDispatchService;
    private final StockTransferService stockTransferService;

    public VaccinationSiteServiceImpl(
            SysUserService sysUserService,
            VaccineSiteStockService vaccineSiteStockService,
            SiteVaccineStockService siteVaccineStockService,
            VaccineService vaccineService,
            AppointmentService appointmentService,
            @Lazy DoctorDispatchService doctorDispatchService,
            StockTransferService stockTransferService) {
        this.sysUserService = sysUserService;
        this.vaccineSiteStockService = vaccineSiteStockService;
        this.siteVaccineStockService = siteVaccineStockService;
        this.vaccineService = vaccineService;
        this.appointmentService = appointmentService;
        this.doctorDispatchService = doctorDispatchService;
        this.stockTransferService = stockTransferService;
    }

    @Override
    public IPage<VaccinationSite> pageSites(long current, long size, String siteName, Integer status) {
        Page<VaccinationSite> page = new Page<>(current, size);
        LambdaQueryWrapper<VaccinationSite> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(siteName), VaccinationSite::getSiteName, siteName)
                .eq(status != null, VaccinationSite::getStatus, status)
                .orderByDesc(VaccinationSite::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    public IPage<SiteVO> pageSitesAsVO(long current, long size, String siteName, Integer status) {
        IPage<VaccinationSite> page = pageSites(current, size, siteName, status);
        List<SiteVO> voList = page.getRecords().stream().map(this::toSiteVO).collect(Collectors.toList());
        Page<SiteVO> voPage = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        voPage.setRecords(voList);
        return voPage;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enable(Long id) {
        VaccinationSite site = getById(id);
        if (site == null) throw new BizException(BizErrorCode.NOT_FOUND, "接种点不存在");
        // 接种点驻场医生不能重复：若本接种点已有驻场医生，启用前先将该医生从其他所有接种点清空并设为禁用
        if (site.getCurrentDoctorId() != null) {
            List<VaccinationSite> others = list(new LambdaQueryWrapper<VaccinationSite>()
                    .eq(VaccinationSite::getCurrentDoctorId, site.getCurrentDoctorId()));
            for (VaccinationSite other : others) {
                if (other.getId().equals(id)) continue;
                other.setCurrentDoctorId(null);
                other.setStatus(SiteStatusEnum.DISABLED.getCode());
                updateById(other);
                stockTransferService.returnAllSiteStockToWarehouse(other.getId(), null);
            }
        }
        site.setStatus(SiteStatusEnum.ENABLED.getCode());
        updateById(site);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void disable(Long id) {
        VaccinationSite site = getById(id);
        if (site == null) throw new BizException(BizErrorCode.NOT_FOUND, "接种点不存在");
        site.setStatus(SiteStatusEnum.DISABLED.getCode());
        site.setCurrentDoctorId(null); // 禁用时同步清空驻场医生，避免“禁用却仍显示驻场医生”的矛盾
        updateById(site);
        // 禁用后将该接种点所有疫苗可用库存退回到总仓（管理员库存）
        stockTransferService.returnAllSiteStockToWarehouse(id, null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void assignDoctor(Long siteId, Long doctorId) {
        VaccinationSite site = getById(siteId);
        if (site == null) throw new BizException(BizErrorCode.NOT_FOUND, "接种点不存在");
        if (doctorId != null) {
            SysUser doctor = sysUserService.getById(doctorId);
            if (doctor == null) throw new BizException(BizErrorCode.NOT_FOUND, "医生不存在");
            if (!"DOCTOR".equals(doctor.getRole())) throw new BizException(BizErrorCode.BAD_REQUEST, "指定用户不是医生");
        }

        Long fromSiteId = siteId;
        if (doctorId != null) {
            // 接种点驻场医生不能重复：一个医生只能驻场一个接种点
            List<VaccinationSite> fromSites = list(new LambdaQueryWrapper<VaccinationSite>()
                    .eq(VaccinationSite::getCurrentDoctorId, doctorId));
            for (VaccinationSite other : fromSites) {
                if (other.getId().equals(siteId)) continue;
                other.setCurrentDoctorId(null);
                other.setStatus(SiteStatusEnum.DISABLED.getCode());
                updateById(other);
                stockTransferService.returnAllSiteStockToWarehouse(other.getId(), null);
            }
            if (!fromSites.isEmpty() && !fromSites.get(0).getId().equals(siteId)) {
                fromSiteId = fromSites.get(0).getId();
            }
            // 若该医生已是本接种点驻场医生，仅确保本接种点为启用状态，不重复推送
            if (doctorId.equals(site.getCurrentDoctorId())) {
                site.setStatus(SiteStatusEnum.ENABLED.getCode());
                updateById(site);
                return;
            }
        } else {
            // 清空驻场医生：该接种点自动变为禁用，直至管理员指派新驻场医生
            site.setCurrentDoctorId(null);
            site.setStatus(SiteStatusEnum.DISABLED.getCode());
            updateById(site);
            stockTransferService.returnAllSiteStockToWarehouse(siteId, null);
            return;
        }

        site.setCurrentDoctorId(doctorId);
        site.setStatus(SiteStatusEnum.ENABLED.getCode());
        updateById(site);
        doctorDispatchService.notifyAssigned(doctorId, fromSiteId, siteId);
    }

    @Override
    public SiteVO getSiteVOById(Long id) {
        VaccinationSite site = getById(id);
        return site != null ? toSiteVO(site) : null;
    }

    @Override
    public SiteDetailVO getDetailForAdmin(Long id) {
        VaccinationSite site = getById(id);
        if (site == null) return null;
        SiteDetailVO vo = toSiteDetailVO(site);
        // 使用调拨库存 site_vaccine_stock（与预约校验、用户端展示一致）
        vo.setStockList(siteVaccineStockService.listAvailableStockByVaccineForSite(id));
        vo.setTodayAppointmentCount(appointmentService.countTodayBySiteId(id));
        return vo;
    }

    @Override
    public List<SiteWithStockVO> listEnabledWithStockForUser() {
        List<VaccinationSite> sites = list(new LambdaQueryWrapper<VaccinationSite>()
                .eq(VaccinationSite::getStatus, SiteStatusEnum.ENABLED.getCode())
                .orderByAsc(VaccinationSite::getId));
        List<SiteWithStockVO> result = new ArrayList<>();
        for (VaccinationSite site : sites) {
            SiteWithStockVO vo = SiteWithStockVO.builder()
                    .id(site.getId())
                    .siteName(site.getSiteName())
                    .address(site.getAddress())
                    .contactPhone(site.getContactPhone())
                    .workTime(site.getWorkTime())
                    .status(site.getStatus())
                    .statusDesc(SiteStatusEnum.fromCode(site.getStatus()) != null ? SiteStatusEnum.fromCode(site.getStatus()).getDesc() : "")
                    .currentDoctorName(resolveCurrentDoctorName(site.getCurrentDoctorId()))
                    .build();
            // 使用调拨库存 site_vaccine_stock（与预约校验一致，避免“有库存却显示无库存”）
            vo.setStockList(siteVaccineStockService.listAvailableStockByVaccineForSite(site.getId()));
            result.add(vo);
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SiteVO saveFromDTO(SiteDTO dto) {
        VaccinationSite site = VaccinationSite.builder()
                .siteName(dto.getSiteName())
                .address(dto.getAddress())
                .contactPhone(dto.getContactPhone())
                .workTime(dto.getWorkTime())
                .status(dto.getStatus() != null ? dto.getStatus() : SiteStatusEnum.ENABLED.getCode())
                .description(dto.getDescription())
                .build();
        save(site);
        return toSiteVO(getById(site.getId()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SiteVO updateFromDTO(Long id, SiteDTO dto) {
        VaccinationSite site = getById(id);
        if (site == null) throw new BizException(BizErrorCode.NOT_FOUND, "接种点不存在");
        site.setSiteName(dto.getSiteName());
        site.setAddress(dto.getAddress());
        site.setContactPhone(dto.getContactPhone());
        site.setWorkTime(dto.getWorkTime());
        if (dto.getStatus() != null) site.setStatus(dto.getStatus());
        site.setDescription(dto.getDescription());
        updateById(site);
        return toSiteVO(getById(id));
    }

    /** 仅当驻场医生存在且状态为正常时返回姓名，否则返回 null（页面驻场显示为空） */
    private String resolveCurrentDoctorName(Long currentDoctorId) {
        if (currentDoctorId == null) return null;
        SysUser user = sysUserService.getById(currentDoctorId);
        if (user == null || !Integer.valueOf(UserStatusEnum.NORMAL.getCode()).equals(user.getStatus())) return null;
        return user.getRealName();
    }

    private SiteVO toSiteVO(VaccinationSite site) {
        if (site == null) return null;
        String statusDesc = SiteStatusEnum.fromCode(site.getStatus()) != null ? SiteStatusEnum.fromCode(site.getStatus()).getDesc() : "";
        // 禁用状态下不展示驻场医生，避免“禁用却显示驻场医生”的歧义（含历史数据兜底）
        String doctorName = Integer.valueOf(SiteStatusEnum.DISABLED.getCode()).equals(site.getStatus()) ? null : resolveCurrentDoctorName(site.getCurrentDoctorId());
        return SiteVO.builder()
                .id(site.getId())
                .siteName(site.getSiteName())
                .address(site.getAddress())
                .contactPhone(site.getContactPhone())
                .workTime(site.getWorkTime())
                .status(site.getStatus())
                .statusDesc(statusDesc)
                .description(site.getDescription())
                .currentDoctorId(site.getCurrentDoctorId())
                .currentDoctorName(doctorName)
                .createTime(site.getCreateTime())
                .updateTime(site.getUpdateTime())
                .build();
    }

    private SiteDetailVO toSiteDetailVO(VaccinationSite site) {
        if (site == null) return null;
        String statusDesc = SiteStatusEnum.fromCode(site.getStatus()) != null ? SiteStatusEnum.fromCode(site.getStatus()).getDesc() : "";
        // 禁用状态下不展示驻场医生，与列表展示一致
        String doctorName = Integer.valueOf(SiteStatusEnum.DISABLED.getCode()).equals(site.getStatus()) ? null : resolveCurrentDoctorName(site.getCurrentDoctorId());
        return SiteDetailVO.builder()
                .id(site.getId())
                .siteName(site.getSiteName())
                .address(site.getAddress())
                .contactPhone(site.getContactPhone())
                .workTime(site.getWorkTime())
                .status(site.getStatus())
                .statusDesc(statusDesc)
                .description(site.getDescription())
                .currentDoctorId(site.getCurrentDoctorId())
                .currentDoctorName(doctorName)
                .createTime(site.getCreateTime())
                .updateTime(site.getUpdateTime())
                .build();
    }

    @Override
    public List<Long> listSiteIdsByCurrentDoctorId(Long doctorId) {
        if (doctorId == null) return List.of();
        return list(new LambdaQueryWrapper<VaccinationSite>()
                .eq(VaccinationSite::getCurrentDoctorId, doctorId)
                .select(VaccinationSite::getId))
                .stream().map(VaccinationSite::getId).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void disableSitesByResidentDoctorId(Long doctorId) {
        if (doctorId == null) return;
        List<VaccinationSite> sites = list(new LambdaQueryWrapper<VaccinationSite>()
                .eq(VaccinationSite::getCurrentDoctorId, doctorId));
        for (VaccinationSite site : sites) {
            site.setCurrentDoctorId(null);
            site.setStatus(SiteStatusEnum.DISABLED.getCode());
            updateById(site);
            stockTransferService.returnAllSiteStockToWarehouse(site.getId(), null);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeSite(Long id) {
        VaccinationSite site = getById(id);
        if (site == null) return false;
        stockTransferService.returnAllSiteStockToWarehouse(id, null);
        return removeById(id);
    }
}
