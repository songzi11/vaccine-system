package com.tjut.edu.vaccine_system.controller.user;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.vo.SiteWithStockVO;
import com.tjut.edu.vaccine_system.service.VaccinationSiteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 用户端-接种点信息（仅启用，含库存、驻场医生）
 */
@RestController
@RequestMapping("/user/site")
@RequiredArgsConstructor
@Tag(name = "用户端-接种点信息")
public class UserSiteController {

    private final VaccinationSiteService vaccinationSiteService;

    @Operation(summary = "接种点列表（含各疫苗库存、驻场医生），仅显示启用站点")
    @GetMapping("/listWithStock")
    public Result<List<SiteWithStockVO>> listWithStock() {
        List<SiteWithStockVO> list = vaccinationSiteService.listEnabledWithStockForUser();
        return Result.ok(list);
    }
}
