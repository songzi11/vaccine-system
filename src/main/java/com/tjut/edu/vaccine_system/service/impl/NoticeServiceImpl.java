package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.Notice;
import com.tjut.edu.vaccine_system.mapper.NoticeMapper;
import com.tjut.edu.vaccine_system.service.NoticeService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 通知公告 Service 实现
 */
@Service
public class NoticeServiceImpl extends ServiceImpl<NoticeMapper, Notice> implements NoticeService {

    private static final String ROLE_DOCTOR = "DOCTOR";
    private static final String ROLE_ADMIN = "ADMIN";
    private static final String AUDIT_PENDING = "PENDING";
    private static final String AUDIT_APPROVED = "APPROVED";
    private static final String AUDIT_REJECTED = "REJECTED";

    @Override
    public IPage<Notice> pageNotices(long current, long size, String title, String type, Integer status, String auditStatus, String publisherRole) {
        Page<Notice> page = new Page<>(current, size);
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(title), Notice::getTitle, title)
                .eq(StringUtils.hasText(type), Notice::getType, type)
                .eq(status != null, Notice::getStatus, status)
                .eq(StringUtils.hasText(auditStatus), Notice::getAuditStatus, auditStatus)
                .eq(StringUtils.hasText(publisherRole), Notice::getPublisherRole, publisherRole)
                .orderByDesc(Notice::getIsTop)
                .orderByDesc(Notice::getPublishTime)
                .orderByDesc(Notice::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    public IPage<Notice> pagePublished(long current, long size, String title, Long userId) {
        Page<Notice> page = new Page<>(current, size);
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notice::getStatus, 1)
                // 仅展示：管理员直接发布 或 医生提交且管理员已审核通过（手册：医生提交未审核/已拒绝的不展示）
                .and(w -> w.eq(Notice::getPublisherRole, ROLE_ADMIN).or().eq(Notice::getAuditStatus, AUDIT_APPROVED))
                .like(StringUtils.hasText(title), Notice::getTitle, title);
        // 定向公告：仅 targetUserId 为空（全员可见）或 等于当前用户（仅本人可见的警告/冻结公告）
        if (userId != null) {
            wrapper.and(w -> w.isNull(Notice::getTargetUserId).or().eq(Notice::getTargetUserId, userId));
        } else {
            wrapper.isNull(Notice::getTargetUserId);
        }
        wrapper.orderByDesc(Notice::getIsTop)
                .orderByDesc(Notice::getPublishTime);
        return page(page, wrapper);
    }

    @Override
    public Notice submitByDoctor(Notice notice, Long doctorId) {
        if (doctorId == null) throw new BizException(BizErrorCode.LOGIN_REQUIRED);
        notice.setPublisherId(doctorId);
        notice.setPublisherRole(ROLE_DOCTOR);
        notice.setAuditStatus(AUDIT_PENDING);
        notice.setRejectReason(null);
        notice.setStatus(0);
        notice.setPublishTime(null);
        save(notice);
        return getById(notice.getId());
    }

    @Override
    public void approve(Long id) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        if (!AUDIT_PENDING.equals(n.getAuditStatus())) throw new BizException(BizErrorCode.BAD_REQUEST, "仅待审批的医生申请可通过");
        n.setStatus(1);
        n.setPublishTime(LocalDateTime.now());
        n.setAuditStatus(AUDIT_APPROVED);
        n.setRejectReason(null);
        updateById(n);
    }

    @Override
    public void reject(Long id, String rejectReason) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        if (!AUDIT_PENDING.equals(n.getAuditStatus())) throw new BizException(BizErrorCode.BAD_REQUEST, "仅待审批的医生申请可拒绝");
        n.setAuditStatus(AUDIT_REJECTED);
        n.setRejectReason(rejectReason);
        updateById(n);
    }

    @Override
    public void withdrawByDoctor(Long id, Long doctorId) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        if (!Long.valueOf(doctorId).equals(n.getPublisherId())) throw new BizException(BizErrorCode.BAD_REQUEST, "只能撤回本人的申请");
        if (!AUDIT_PENDING.equals(n.getAuditStatus()) && !AUDIT_REJECTED.equals(n.getAuditStatus())) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "仅待审批或未通过的申请可撤回");
        }
        removeById(id);
    }

    @Override
    public List<Notice> listByPublisherId(Long doctorId) {
        if (doctorId == null) return List.of();
        return list(new LambdaQueryWrapper<Notice>()
                .eq(Notice::getPublisherId, doctorId)
                .eq(Notice::getPublisherRole, ROLE_DOCTOR)
                .orderByDesc(Notice::getCreateTime));
    }

    @Override
    public void setOffline(Long id) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        n.setStatus(0);
        updateById(n);
    }

    @Override
    public void setOnline(Long id) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        n.setStatus(1);
        n.setPublishTime(LocalDateTime.now());
        updateById(n);
    }

    @Override
    public void setTop(Long id) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        n.setIsTop(1);
        updateById(n);
    }

    @Override
    public void setUntop(Long id) {
        Notice n = getById(id);
        if (n == null) throw new BizException(BizErrorCode.BAD_REQUEST, "公告不存在");
        n.setIsTop(0);
        updateById(n);
    }

    @Override
    public Notice createSystemNoticeForUser(Long targetUserId, String noticeStyle, String title, String content) {
        if (targetUserId == null) return null;
        Notice n = Notice.builder()
                .title(title)
                .content(content)
                .type("SYSTEM")
                .publisherId(null)
                .publisherRole(ROLE_ADMIN)
                .auditStatus(AUDIT_APPROVED)
                .rejectReason(null)
                .isTop(0)
                .status(1)
                .publishTime(LocalDateTime.now())
                .targetUserId(targetUserId)
                .noticeStyle(noticeStyle != null ? noticeStyle : "NORMAL")
                .build();
        save(n);
        return getById(n.getId());
    }
}
