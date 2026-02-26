package com.tjut.edu.vaccine_system.controller.user;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.model.vo.RecordVO;
import com.tjut.edu.vaccine_system.service.RecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户端-我的接种记录
 */
@RestController
@RequestMapping(value = {"/user/record", "/record"})
@RequiredArgsConstructor
@Tag(name = "用户-接种记录")
public class UserRecordController {

    private final RecordService recordService;

    @Operation(summary = "根据用户/宝宝查询接种记录（合并 record 与 vaccination_record，实时同步）")
    @GetMapping(value = {"/my", "/list"})
    public Result<List<RecordVO>> listByUserOrChild(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long childId) {
        List<RecordVO> list;
        if (childId != null) {
            list = recordService.listByChildIdMerged(childId);
        } else if (userId != null) {
            list = recordService.listByUserIdMerged(userId);
        } else {
            list = List.of();
        }
        return Result.ok(list);
    }

    @Operation(summary = "根据宝宝查询接种记录（合并两表，含名称信息）")
    @GetMapping("/child/{childId}")
    public Result<List<RecordVO>> listByChild(@PathVariable Long childId) {
        List<RecordVO> list = recordService.listByChildIdMerged(childId);
        return Result.ok(list);
    }
}
