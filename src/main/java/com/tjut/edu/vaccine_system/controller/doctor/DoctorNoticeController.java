package com.tjut.edu.vaccine_system.controller.doctor;

import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import com.tjut.edu.vaccine_system.model.entity.Notice;
import com.tjut.edu.vaccine_system.model.entity.NoticeFeedback;
import com.tjut.edu.vaccine_system.service.NoticeFeedbackService;
import com.tjut.edu.vaccine_system.service.NoticeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 医生端-公告：提交新增公告申请、我的申请列表、撤回/修改重申请、往期公告意见
 */
@RestController
@RequestMapping(value = {"/doctor/notice", "/api/doctor/notice"})
@RequiredArgsConstructor
@Tag(name = "医生-公告")
public class DoctorNoticeController {

    private final NoticeService noticeService;
    private final NoticeFeedbackService noticeFeedbackService;

    @Operation(summary = "提交新增公告申请（待管理员审批）")
    @PostMapping("/submit")
    public Result<Notice> submit(@RequestBody Notice notice, @RequestParam Long doctorId) {
        Notice saved = noticeService.submitByDoctor(notice, doctorId);
        return Result.ok("提交成功，等待管理员审批", saved);
    }

    @Operation(summary = "我的公告申请列表（含待审批/通过/未通过）")
    @GetMapping("/my")
    public Result<List<Notice>> myList(@RequestParam Long doctorId) {
        List<Notice> list = noticeService.listByPublisherId(doctorId);
        return Result.ok(list);
    }

    @Operation(summary = "修改后重新申请（仅未通过的可修改并置为待审批）")
    @PutMapping("/{id}/reapply")
    public Result<Notice> reapply(@PathVariable Long id, @RequestBody Notice notice, @RequestParam Long doctorId) {
        Notice n = noticeService.getById(id);
        if (n == null) return Result.fail(ResultCode.NOT_FOUND.getCode(), "公告不存在");
        if (!"REJECTED".equals(n.getAuditStatus())) return Result.fail(ResultCode.BAD_REQUEST.getCode(), "仅未通过的公告可修改后重新申请");
        if (!Long.valueOf(doctorId).equals(n.getPublisherId())) return Result.fail(ResultCode.BAD_REQUEST.getCode(), "只能修改本人的申请");
        if (notice.getTitle() != null) n.setTitle(notice.getTitle());
        if (notice.getContent() != null) n.setContent(notice.getContent());
        n.setAuditStatus("PENDING");
        n.setRejectReason(null);
        noticeService.updateById(n);
        return Result.ok("已重新提交审批", noticeService.getById(id));
    }

    @Operation(summary = "撤回申请（仅待审批或未通过可撤回）")
    @DeleteMapping("/{id}/withdraw")
    public Result<Void> withdraw(@PathVariable Long id, @RequestParam Long doctorId) {
        noticeService.withdrawByDoctor(id, doctorId);
        return Result.ok();
    }

    @Operation(summary = "对往期公告提交意见给管理员")
    @PostMapping("/feedback")
    public Result<NoticeFeedback> feedback(@RequestBody Map<String, Object> body) {
        Long noticeId = body.get("noticeId") != null ? Long.valueOf(body.get("noticeId").toString()) : null;
        Long userId = body.get("userId") != null ? Long.valueOf(body.get("userId").toString()) : null;
        String content = body.get("content") != null ? body.get("content").toString() : null;
        NoticeFeedback f = noticeFeedbackService.submit(noticeId, userId, content);
        return Result.ok("提交成功", f);
    }
}
