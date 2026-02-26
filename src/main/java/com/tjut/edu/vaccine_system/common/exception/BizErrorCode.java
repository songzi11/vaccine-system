package com.tjut.edu.vaccine_system.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 业务错误码（与 ResultCode 区分：4xx 为业务可预期错误）
 */
@Getter
@AllArgsConstructor
public enum BizErrorCode {

    /** 请先登录 */
    LOGIN_REQUIRED(400, "请先登录"),
    /** 仅居民用户可预约接种 */
    ROLE_NOT_RESIDENT(400, "仅居民用户可预约接种"),
    /** 该宝宝已有待处理预约，请完成或取消后再预约（同一家长下不同孩子可各有 one） */
    DUPLICATE_PENDING_APPOINTMENT(400, "该宝宝已有待处理预约，请完成或取消后再预约"),
    /** 同一儿童同一天同一疫苗不能重复预约 */
    DUPLICATE_SAME_DAY_VACCINE(400, "该儿童该疫苗当日已有预约，请勿重复提交"),
    /** 请选择接种点 */
    SITE_REQUIRED(400, "请选择接种点"),
    /** 接种点已禁用，不可预约 */
    SITE_DISABLED(400, "接种点已禁用，不可预约"),
    /** 请选择接种儿童 */
    CHILD_REQUIRED(400, "请选择接种儿童"),
    /** 儿童档案不存在 */
    CHILD_NOT_FOUND(400, "儿童档案不存在"),
    /** 该儿童不属于当前用户 */
    CHILD_NOT_OWNED(400, "该儿童不属于当前用户"),
    /** 疫苗不存在或已下架 */
    VACCINE_NOT_AVAILABLE(400, "疫苗不存在或已下架"),
    /** 该疫苗已下架，无法录入接种记录 */
    VACCINE_OFF_SHELF_CANNOT_RECORD(400, "该疫苗已下架，无法录入接种记录"),
    /** 预约不存在 */
    APPOINTMENT_NOT_FOUND(404, "预约不存在"),
    /** 该预约已处理，无法重复审核 */
    APPOINTMENT_ALREADY_REVIEWED(400, "该预约已处理，无法重复审核"),
    /** 仅待审批的预约可审批排班 */
    APPOINTMENT_NOT_PENDING(400, "仅待审批的预约可审批排班"),
    /** 仅已排班的预约可接种 */
    APPOINTMENT_NOT_SCHEDULED(400, "仅已排班的预约可接种"),
    /** 该接种点未指定驻场医生，无法预约 */
    SITE_NO_RESIDENT_DOCTOR(400, "该接种点未指定驻场医生，无法预约"),
    /** 仅该接种点的驻场医生可审核该预约 */
    APPOINTMENT_NOT_RESIDENT_DOCTOR(400, "仅该接种点的驻场医生可审核该预约"),
    /** 同一种疫苗后续针只能由第一次接种的医生接种，请选择该医生所在接种点预约 */
    SAME_VACCINE_MUST_SAME_DOCTOR(400, "同一种疫苗后续针只能由第一次接种的医生接种，请选择该医生所在接种点预约"),
    /** 该接种点该疫苗库存不足 */
    STOCK_INSUFFICIENT(400, "该接种点该疫苗库存不足"),
    /** 该疫苗暂无可用批次（无在效期内批次或库存为0） */
    NO_AVAILABLE_BATCH(400, "该疫苗暂无可用批次，暂不可预约"),
    /** 排班不存在 */
    SCHEDULE_NOT_FOUND(404, "排班不存在"),
    /** 排班已禁用或已满，无法预约 */
    SCHEDULE_NOT_AVAILABLE(400, "排班已禁用或已满，无法预约"),
    /** 请选择排班（医生班次） */
    SCHEDULE_REQUIRED(400, "请选择排班（医生班次）"),
    /** 用户名或密码错误 */
    LOGIN_FAILED(401, "用户名或密码错误"),
    /** 该用户名已被使用或已注销，不可再次使用 */
    USERNAME_TAKEN(400, "该用户名已被使用或已注销，不可再次使用"),
    /** 管理员密码错误 */
    ADMIN_PASSWORD_WRONG(400, "管理员密码错误，请重新输入"),
    /** 该用户已注销，不可恢复 */
    USER_ALREADY_DEACTIVATED(400, "该用户已注销，不可恢复"),
    /** 仅正常状态用户可禁用/恢复 */
    USER_STATUS_INVALID(400, "仅正常或已禁用状态可操作"),
    /** 因爽约次数过多，三十日内不可预约 */
    RESERVATION_BANNED(400, "因爽约次数过多，三十日内不可预约，请按时履约。"),
    /** 自定义消息（code 使用 400） */
    BAD_REQUEST(400, ""),
    /** 资源不存在 */
    NOT_FOUND(404, "资源不存在");

    private final int code;
    private final String defaultMessage;
}
