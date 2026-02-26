package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.Notice;

import java.util.List;

/**
 * 通知公告 Service（管理员发布/审批医生申请，医生申请公告、往期意见）
 */
public interface NoticeService extends IService<Notice> {

    /**
     * 分页查询公告（置顶优先、按发布时间倒序；可选 auditStatus、publisherRole）
     */
    IPage<Notice> pageNotices(long current, long size, String title, String type, Integer status, String auditStatus, String publisherRole);

    /**
     * 仅查询已发布的公告（用户端/医生端查看，带 publisher_role 区分管理员/医生）
     * @param userId 当前用户ID，非空时同时返回 targetUserId 为空（全员）或等于 userId（仅本人可见）的公告
     */
    IPage<Notice> pagePublished(long current, long size, String title, Long userId);

    /**
     * 医生提交公告申请（status=0 草稿，audit_status=PENDING，publisher_role=DOCTOR）
     */
    Notice submitByDoctor(Notice notice, Long doctorId);

    /**
     * 管理员审批通过：发布公告，备注发布医生
     */
    void approve(Long id);

    /**
     * 管理员审批拒绝：audit_status=REJECTED，reject_reason
     */
    void reject(Long id, String rejectReason);

    /**
     * 医生撤回申请（仅 PENDING 或 REJECTED 可撤回，即删除）
     */
    void withdrawByDoctor(Long id, Long doctorId);

    /**
     * 医生我的公告申请列表（publisher_id=doctorId）
     */
    List<Notice> listByPublisherId(Long doctorId);

    /**
     * 管理员下架公告（status=0，仅管理员可见，不物理删除）
     */
    void setOffline(Long id);

    /**
     * 管理员上架公告（status=1，重新对用户端展示）
     */
    void setOnline(Long id);

    /**
     * 管理员置顶公告（is_top=1）
     */
    void setTop(Long id);

    /**
     * 管理员取消置顶公告（is_top=0）
     */
    void setUntop(Long id);

    /**
     * 系统自动推送仅指定用户可见的公告（爽约警告/冻结通知），管理员端自动通过、红色框等由 notice_style 控制
     */
    Notice createSystemNoticeForUser(Long targetUserId, String noticeStyle, String title, String content);
}
