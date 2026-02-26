package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.NoticeFeedback;

import java.util.List;

/**
 * 公告意见 Service（医生对往期公告提交意见给管理员）
 */
public interface NoticeFeedbackService extends IService<NoticeFeedback> {

    /**
     * 提交一条意见（医生对某公告）
     */
    NoticeFeedback submit(Long noticeId, Long userId, String content);

    /**
     * 某公告下的所有意见（管理员查看）
     */
    List<NoticeFeedback> listByNoticeId(Long noticeId);
}
