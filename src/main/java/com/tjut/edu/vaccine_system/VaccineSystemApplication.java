package com.tjut.edu.vaccine_system;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.tjut.edu.vaccine_system.mapper")
@EnableScheduling
public class VaccineSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(VaccineSystemApplication.class, args);
    }
}