package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.NoticeFeedback;
import com.tjut.edu.vaccine_system.mapper.NoticeFeedbackMapper;
import com.tjut.edu.vaccine_system.service.NoticeFeedbackService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class NoticeFeedbackServiceImpl extends ServiceImpl<NoticeFeedbackMapper, NoticeFeedback> implements NoticeFeedbackService {

    @Override
    public NoticeFeedback submit(Long noticeId, Long userId, String content) {
        if (noticeId == null || userId == null) throw new BizException(BizErrorCode.LOGIN_REQUIRED);
        if (!StringUtils.hasText(content)) throw new BizException(BizErrorCode.BAD_REQUEST, "意见内容不能为空");
        NoticeFeedback f = NoticeFeedback.builder()
                .noticeId(noticeId)
                .userId(userId)
                .content(content.trim())
                .build();
        save(f);
        return getById(f.getId());
    }

    @Override
    public List<NoticeFeedback> listByNoticeId(Long noticeId) {
        if (noticeId == null) return List.of();
        return list(new LambdaQueryWrapper<NoticeFeedback>()
                .eq(NoticeFeedback::getNoticeId, noticeId)
                .orderByDesc(NoticeFeedback::getCreateTime));
    }
}
