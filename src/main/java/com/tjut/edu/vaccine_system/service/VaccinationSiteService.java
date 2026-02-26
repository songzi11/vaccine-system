package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.dto.SiteDTO;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.vo.SiteDetailVO;
import com.tjut.edu.vaccine_system.model.vo.SiteVO;
import com.tjut.edu.vaccine_system.model.vo.SiteWithStockVO;

import java.util.List;

public interface VaccinationSiteService extends IService<VaccinationSite> {

    IPage<VaccinationSite> pageSites(long current, long size, String siteName, Integer status);

    /** 分页结果转 SiteVO 列表（不直接返回 entity） */
    IPage<SiteVO> pageSitesAsVO(long current, long size, String siteName, Integer status);

    /** 启用接种点 */
    void enable(Long id);

    /** 禁用接种点 */
    void disable(Long id);

    /** 指定驻场医生（管理员直接指派，指派后向医生推送派遣信息） */
    void assignDoctor(Long siteId, Long doctorId);

    /** 管理员：接种点详情（含库存、驻场医生、今日预约数） */
    SiteDetailVO getDetailForAdmin(Long id);

    /** 仅基础信息 SiteVO（无库存、今日预约数），供查看/编辑表单 */
    SiteVO getSiteVOById(Long id);

    /** 用户端：仅启用的接种点列表（含库存、驻场医生），用于 listWithStock */
    List<SiteWithStockVO> listEnabledWithStockForUser();

    /** 新增：从 DTO 保存 */
    SiteVO saveFromDTO(SiteDTO dto);

    /** 修改：从 DTO 更新 */
    SiteVO updateFromDTO(Long id, SiteDTO dto);

    /** 查询指定驻场医生所在的接种点ID列表（用于医生端仅查看本接种点待审批预约） */
    List<Long> listSiteIdsByCurrentDoctorId(Long doctorId);

    /**
     * 将指定医生作为驻场医生的所有接种点清空驻场医生并设为禁用。
     * 用于医生账户被禁用或注销时，其驻场接种点自动转为禁用。
     */
    void disableSitesByResidentDoctorId(Long doctorId);

    /**
     * 删除接种点：先将该接种点所有疫苗可用库存退回到总仓，再物理删除接种点记录。
     */
    boolean removeSite(Long id);
}
