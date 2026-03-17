package com.tjut.edu.vaccine_system.rule.annotation;

import java.lang.annotation.*;

/**
 * 规则组注解
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RuleGroup {
    String value();
}