package com.tjut.edu.vaccine_system.rule.annotation;

import java.lang.annotation.*;

/**
 * 规则定义注解
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Rule {

    /**
     * 规则代码
     */
    String code();

    /**
     * 规则名称
     */
    String name();

    /**
     * 规则组
     */
    String group() default "DEFAULT";

    /**
     * 优先级，数字越小优先级越高
     */
    int priority() default 0;

    /**
     * 是否启用
     */
    boolean enabled() default true;

    /**
     * 是否为必须通过的规则
     */
    boolean mandatory() default true;
}