package com.tjut.edu.vaccine_system.controller.admin;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjut.edu.vaccine_system.common.result.PageResult;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.common.result.Results;
import com.tjut.edu.vaccine_system.model.entity.Notice;
import com.tjut.edu.vaccine_system.model.entity.NoticeFeedback;
import com.tjut.edu.vaccine_system.service.NoticeFeedbackService;
import com.tjut.edu.vaccine_system.service.NoticeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 管理员-公告管理（审批医生申请、查看公告意见）
 */
@RestController
@RequestMapping(value = {"/admin/notice", "/notice"})
@RequiredArgsConstructor
@Tag(name = "管理员-公告管理")
public class AdminNoticeController {

    private final NoticeService noticeService;
    private final NoticeFeedbackService noticeFeedbackService;

    @Operation(summary = "分页查询（可选 auditStatus 筛选医生待审批）")
    @GetMapping(value = {"/page", "/list"})
    public Result<PageResult<Notice>> page(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "10") Long size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String auditStatus,
            @RequestParam(required = false) String publisherRole) {
        IPage<Notice> page = noticeService.pageNotices(current, size, title, type, status, auditStatus, publisherRole);
        return Results.page(page);
    }

    @Operation(summary = "医生待审批公告列表（audit_status=PENDING）")
    @GetMapping("/pending")
    public Result<PageResult<Notice>> listPending(
            @RequestParam(defaultValue = "1") Long current,
            @RequestParam(defaultValue = "20") Long size) {
        IPage<Notice> page = noticeService.pageNotices(current, size, null, null, null, "PENDING", "DOCTOR");
        return Results.page(page);
    }

    @Operation(summary = "审批通过：发布公告，备注发布医生")
    @PutMapping("/{id}/approve")
    public Result<Void> approve(@PathVariable Long id) {
        noticeService.approve(id);
        return Result.ok();
    }

    @Operation(summary = "审批拒绝：未通过返回医生端并填写原因")
    @PutMapping("/{id}/reject")
    public Result<Void> reject(@PathVariable Long id, @RequestBody(required = false) java.util.Map<String, String> body) {
        String reason = body != null && body.containsKey("rejectReason") ? body.get("rejectReason") : null;
        noticeService.reject(id, reason);
        return Result.ok();
    }

    @Operation(summary = "详情")
    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id) {
        return Optional.ofNullable(noticeService.getById(id))
                .map(Result::ok)
                .orElse(Result.fail(ResultCode.NOT_FOUND.getCode(), "公告不存在"));
    }

    @Operation(summary = "新增（管理员直接发布，publisher_role=ADMIN）")
    @PostMapping
    public Result<Notice> save(@Valid @RequestBody Notice notice) {
        if (notice.getPublisherRole() == null || notice.getPublisherRole().isBlank()) {
            notice.setPublisherRole("ADMIN");
        }
        // 管理员直接发布：设为已发布状态，便于用户端展示
        notice.setStatus(1);
        notice.setPublishTime(LocalDateTime.now());
        notice.setAuditStatus("APPROVED");
        noticeService.save(notice);
        return Result.ok("新增成功", noticeService.getById(notice.getId()));
    }

    @Operation(summary = "修改")
    @PutMapping("/{id}")
    public Result<Notice> update(@PathVariable Long id, @RequestBody Notice notice) {
        notice.setId(id);
        boolean ok = noticeService.updateById(notice);
        return ok ? Result.ok("修改成功", noticeService.getById(id))
                : Result.fail(ResultCode.NOT_FOUND.getCode(), "修改失败");
    }

    @Operation(summary = "下架公告（仅对管理员可见，不物理删除）")
    @PutMapping("/{id}/offline")
    public Result<Void> setOffline(@PathVariable Long id) {
        noticeService.setOffline(id);
        return Result.ok();
    }

    @Operation(summary = "上架公告（重新对用户端展示）")
    @PutMapping("/{id}/online")
    public Result<Void> setOnline(@PathVariable Long id) {
        noticeService.setOnline(id);
        return Result.ok();
    }

    @Operation(summary = "置顶公告")
    @PutMapping("/{id}/top")
    public Result<Void> setTop(@PathVariable Long id) {
        noticeService.setTop(id);
        return Result.ok();
    }

    @Operation(summary = "取消置顶公告")
    @PutMapping("/{id}/untop")
    public Result<Void> setUntop(@PathVariable Long id) {
        noticeService.setUntop(id);
        return Result.ok();
    }

    @Operation(summary = "某公告下的医生意见列表")
    @GetMapping("/{id}/feedback")
    public Result<List<NoticeFeedback>> listFeedback(@PathVariable Long id) {
        List<NoticeFeedback> list = noticeFeedbackService.listByNoticeId(id);
        return Result.ok(list);
    }
}
