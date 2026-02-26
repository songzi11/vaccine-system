package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.dto.SiteDTO;
import com.tjut.edu.vaccine_system.model.vo.SiteDetailVO;
import com.tjut.edu.vaccine_system.model.vo.SiteStockVO;
import com.tjut.edu.vaccine_system.model.vo.SiteVO;
import com.tjut.edu.vaccine_system.service.SiteVaccineStockService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员-接种点管理（CRUD + 启用/禁用 + 指定驻场医生）
 */
@RestController
@RequestMapping(value = {"/admin/site", "/vaccination_site"})
@RequiredArgsConstructor
@Tag(name = "管理员-接种点管理")
public class AdminSiteController {

    private final VaccinationSiteService vaccinationSiteService;
    private final SiteVaccineStockService siteVaccineStockService;

    @Operation(summary = "分页查询")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<SiteVO>> page(
            @RequestParam(required = false) Long current,
            @RequestParam(required = false) Long size,
            @RequestParam(required = false) Long pageNum,
            @RequestParam(required = false) Long pageSize,
            @RequestParam(required = false) String siteName,
            @RequestParam(required = false) Integer status) {
        long cur = current != null ? current : (pageNum != null ? pageNum : 1L);
        long siz = size != null ? size : (pageSize != null ? pageSize : 10L);
        IPage<SiteVO> page = vaccinationSiteService.pageSitesAsVO(cur, siz, siteName, status);
        return Results.page(page);
    }

    @Operation(summary = "详情（含库存、驻场医生、今日预约数）；兼容直接返回基础信息供编辑")
    @GetMapping("/{id}")
    public Result<SiteDetailVO> getById(@PathVariable Long id) {
        SiteDetailVO vo = vaccinationSiteService.getDetailForAdmin(id);
        return vo != null ? Result.ok(vo) : Result.fail(ResultCode.NOT_FOUND.getCode(), "接种点不存在");
    }

    /** 详情备用路径：前端可能用 /vaccination_site/detail/123 打开查看页 */
    @GetMapping("/detail/{id}")
    public Result<SiteDetailVO> getDetailById(@PathVariable Long id) {
        return getById(id);
    }

    /** 仅基础信息（无库存、今日预约数），供只做查看/编辑表单的前端使用 */
    @GetMapping(value = {"/{id}/base", "/{id}/simple"})
    public Result<SiteVO> getBaseById(@PathVariable Long id) {
        SiteVO vo = vaccinationSiteService.getSiteVOById(id);
        return vo != null ? Result.ok(vo) : Result.fail(ResultCode.NOT_FOUND.getCode(), "接种点不存在");
    }

    @Operation(summary = "新增")
    @PostMapping
    public Result<SiteVO> save(@Valid @RequestBody SiteDTO dto) {
        SiteVO vo = vaccinationSiteService.saveFromDTO(dto);
        return Result.ok("新增成功", vo);
    }

    @Operation(summary = "修改")
    @PutMapping("/{id}")
    public Result<SiteVO> update(@PathVariable Long id, @Valid @RequestBody SiteDTO dto) {
        SiteVO vo = vaccinationSiteService.updateFromDTO(id, dto);
        return Result.ok("修改成功", vo);
    }

    @Operation(summary = "删除（先将该接种点所有疫苗退回总仓再删除）")
    @DeleteMapping("/{id}")
    public Result<Void> remove(@PathVariable Long id) {
        boolean ok = vaccinationSiteService.removeSite(id);
        return ok ? Result.ok() : Result.fail(ResultCode.NOT_FOUND.getCode(), "删除失败");
    }

    @Operation(summary = "启用接种点")
    @PostMapping("/enable/{id}")
    public Result<Void> enable(@PathVariable Long id) {
        vaccinationSiteService.enable(id);
        return Result.ok("已启用");
    }

    @Operation(summary = "禁用接种点")
    @PostMapping("/disable/{id}")
    public Result<Void> disable(@PathVariable Long id) {
        vaccinationSiteService.disable(id);
        return Result.ok("已禁用");
    }

    @Operation(summary = "指定驻场医生（指派后向该医生推送派遣信息）；支持 PUT 与 POST")
    @RequestMapping(value = "/{id}/assignDoctor/{doctorId}", method = {RequestMethod.PUT, RequestMethod.POST})
    public Result<Void> assignDoctor(@PathVariable Long id, @PathVariable Long doctorId) {
        vaccinationSiteService.assignDoctor(id, doctorId);
        return Result.ok("已指派驻场医生，医生端将收到派遣信息");
    }

    @Operation(summary = "清空驻场医生")
    @PostMapping("/{id}/clearDoctor")
    public Result<Void> clearDoctor(@PathVariable Long id) {
        vaccinationSiteService.assignDoctor(id, null);
        return Result.ok("已清空驻场医生");
    }

    // --------------- 接种点库存（只读展示，与预约/用户端一致：来自总仓调拨 site_vaccine_stock；增减请在「疫苗管理-库存管理」中分配）---------------

    @Operation(summary = "某接种点库存列表（按疫苗汇总可用库存，只读）")
    @GetMapping("/{siteId}/stock")
    public Result<java.util.List<SiteStockVO>> listStock(@PathVariable Long siteId) {
        if (vaccinationSiteService.getById(siteId) == null) {
            return Result.fail(ResultCode.NOT_FOUND.getCode(), "接种点不存在");
        }
        return Result.ok(siteVaccineStockService.listAvailableStockByVaccineForSite(siteId));
    }
}
