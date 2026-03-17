package com.tjut.edu.vaccine_system.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.util.SocketUtils;
import redis.embedded.RedisServer;

import java.io.IOException;

@Configuration
@Profile({"dev", "test"})
public class EmbeddedRedisConfig {

    private static final Logger log = LoggerFactory.getLogger(EmbeddedRedisConfig.class);

    @Bean
    public RedisServer redisServer() throws IOException {
        int port = SocketUtils.findAvailableTcpPort(10000, 60000);
        log.info("Starting Embedded Redis on port {}", port);
        return new RedisServer(port);
    }
}