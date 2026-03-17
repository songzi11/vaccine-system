package com.tjut.edu.vaccine_system.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.io.IOException;
import java.net.ServerSocket;

@Configuration
@Profile({"dev", "test"})
public class EmbeddedRedisConfig {

    private static final Logger log = LoggerFactory.getLogger(EmbeddedRedisConfig.class);

    @Bean
    public EmbeddedRedisServer embeddedRedisServer() throws IOException {
        int port = findAvailablePort(10000, 60000);
        log.info("Starting Embedded Redis on port {}", port);
        return new EmbeddedRedisServer(port);
    }

    private int findAvailablePort(int minPort, int maxPort) {
        for (int port = minPort; port <= maxPort; port++) {
            try {
                ServerSocket socket = new ServerSocket(port);
                socket.close();
                return port;
            } catch (IOException e) {
                // Port in use, try next
            }
        }
        throw new IllegalStateException("No available port found in range " + minPort + "-" + maxPort);
    }

    /**
     * 嵌入式 Redis 服务器
     */
    public static class EmbeddedRedisServer {
        private final redis.embedded.RedisServer redisServer;

        public EmbeddedRedisServer(int port) throws IOException {
            this.redisServer = new redis.embedded.RedisServer(port);
        }

        @jakarta.annotation.PostConstruct
        public void start() {
            redisServer.start();
            log.info("Embedded Redis started");
        }

        @jakarta.annotation.PreDestroy
        public void stop() {
            if (redisServer != null) {
                redisServer.stop();
                log.info("Embedded Redis stopped");
            }
        }

        public int getPort() {
            return redisServer.getBind();
        }
    }
}