package com.tjut.edu.vaccine_system.controller.doctor;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.entity.VaccinationRecord;
import com.tjut.edu.vaccine_system.model.entity.VaccinationSite;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.vo.DoctorProfileVO;
import com.tjut.edu.vaccine_system.model.vo.DoctorVaccinationRecordVO;
import com.tjut.edu.vaccine_system.service.ChildProfileService;
import com.tjut.edu.vaccine_system.service.SysUserService;
import com.tjut.edu.vaccine_system.service.VaccinationRecordService;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import com.tjut.edu.vaccine_system.service.VaccineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 医生端-个人信息与接种记录（工作台「医生信息」模块）
 */
@RestController
@RequestMapping(value = {"/doctor/profile", "/api/doctor/profile"})
@RequiredArgsConstructor
@Tag(name = "医生-个人信息与接种记录")
public class DoctorProfileController {

    private final SysUserService sysUserService;
    private final VaccinationRecordService vaccinationRecordService;
    private final ChildProfileService childProfileService;
    private final VaccineService vaccineService;
    private final VaccinationSiteService vaccinationSiteService;

    @Operation(summary = "医生个人信息（供工作台展示）")
    @GetMapping
    public Result<DoctorProfileVO> getProfile(@RequestParam Long doctorId) {
        SysUser user = sysUserService.getById(doctorId);
        if (user == null) {
            return Result.fail(ResultCode.NOT_FOUND.getCode(), "用户不存在");
        }
        if (!"DOCTOR".equals(user.getRole())) {
            return Result.fail(ResultCode.BAD_REQUEST.getCode(), "非医生账号");
        }
        DoctorProfileVO vo = DoctorProfileVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .realName(user.getRealName())
                .phone(user.getPhone())
                .role(user.getRole())
                .gender(user.getGender())
                .address(user.getAddress())
                .build();
        return Result.ok(vo);
    }

    @Operation(summary = "医生接种过的宝宝记录（分页，含宝宝名、疫苗名、接种点名）")
    @GetMapping("/vaccinated-records")
    public Result<PageResult<DoctorVaccinationRecordVO>> vaccinatedRecords(
            @RequestParam Long doctorId,
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size) {
        SysUser user = sysUserService.getById(doctorId);
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            return Result.fail(ResultCode.BAD_REQUEST.getCode(), "无效的医生身份");
        }
        IPage<VaccinationRecord> page = vaccinationRecordService.pageByDoctorId(current, size, doctorId);
        List<DoctorVaccinationRecordVO> voList = new ArrayList<>();
        for (VaccinationRecord r : page.getRecords()) {
            ChildProfile child = r.getChildId() != null ? childProfileService.getById(r.getChildId()) : null;
            Vaccine vaccine = r.getVaccineId() != null ? vaccineService.getById(r.getVaccineId()) : null;
            VaccinationSite site = r.getSiteId() != null ? vaccinationSiteService.getById(r.getSiteId()) : null;
            voList.add(DoctorVaccinationRecordVO.builder()
                    .id(r.getId())
                    .childId(r.getChildId())
                    .childName(child != null ? child.getName() : null)
                    .vaccineId(r.getVaccineId())
                    .vaccineName(vaccine != null ? vaccine.getVaccineName() : null)
                    .siteId(r.getSiteId())
                    .siteName(site != null ? site.getSiteName() : null)
                    .vaccinationDate(r.getVaccinationDate())
                    .doseNumber(r.getDoseNumber())
                    .build());
        }
        return Results.page(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }
}
