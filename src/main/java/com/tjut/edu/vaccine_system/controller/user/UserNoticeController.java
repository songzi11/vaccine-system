package com.tjut.edu.vaccine_system.controller.user;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.Notice;
import com.tjut.edu.vaccine_system.service.NoticeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 用户端/医生端-公告仅查看（已发布，带 publisher_role 区分管理员/医生发布）
 */
@RestController
@RequestMapping(value = {"/user/notice", "/api/notice"})
@RequiredArgsConstructor
@Tag(name = "用户-公告查看")
public class UserNoticeController {

    private final NoticeService noticeService;

    @Operation(summary = "分页查询已发布公告（仅查看，含 publisher_role；传 userId 时可看仅本人可见的警告/冻结公告）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<Notice>> pagePublished(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Long userId) {
        IPage<Notice> page = noticeService.pagePublished(current, size, title, userId);
        return Results.page(page);
    }

    @Operation(summary = "公告详情（仅已发布；定向公告需为当前用户）")
    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id, @RequestParam(required = false) Long userId) {
        Notice n = noticeService.getById(id);
        if (n == null || !Integer.valueOf(1).equals(n.getStatus())) {
            return Result.fail(404, "公告不存在或未发布");
        }
        if (n.getTargetUserId() != null && (userId == null || !n.getTargetUserId().equals(userId))) {
            return Result.fail(404, "公告不存在或未发布");
        }
        return Result.ok(n);
    }
}
