package com.tjut.edu.vaccine_system.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI 3 / Swagger 接口文档配置
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("疫苗接种管理系统 API")
                        .description("疫苗接种管理系统后端接口文档")
                        .version("1.0")
                        .contact(new Contact()
                                .name("疫苗管理系统")));
    }
}
