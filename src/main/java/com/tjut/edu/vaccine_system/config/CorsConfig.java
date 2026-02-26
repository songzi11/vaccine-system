package com.tjut.edu.vaccine_system.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

/**
 * 跨域配置：解决前端验证用户名等接口“一直转圈”、OPTIONS 无响应等问题
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        // 允许任意来源（与 AllowCredentials true 同时使用时必须用 Pattern，不能写 "*" 字面量）
        config.setAllowedOriginPatterns(List.of("*"));
        // 允许携带 Cookie / Authorization
        config.setAllowCredentials(true);
        // 允许所有请求头（含 Content-Type、Authorization 等）
        config.addAllowedHeader("*");
        // 允许所有方法（GET、POST、PUT、DELETE、OPTIONS）
        config.addAllowedMethod("*");
        // 预检缓存，减少 OPTIONS 请求
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
