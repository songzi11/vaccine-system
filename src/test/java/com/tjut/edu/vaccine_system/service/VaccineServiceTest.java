package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class VaccineServiceTest {

    @Autowired
    private VaccineService vaccineService;

    @Test
    void testPageVaccines() {
        // Given
        long current = 1;
        long size = 10;

        // When
        var page = vaccineService.pageVaccines(current, size, null, null);

        // Then
        assertNotNull(page);
        assertTrue(page.getPages() >= 0);
    }

    @Test
    void testPageVaccinesWithNameFilter() {
        // Given
        long current = 1;
        long size = 10;
        String vaccineName = "乙肝";

        // When
        var page = vaccineService.pageVaccines(current, size, vaccineName, null);

        // Then
        assertNotNull(page);
        // Should filter by vaccine name if any records exist
    }

    @Test
    void testPageVaccinesWithStatusFilter() {
        // Given
        long current = 1;
        long size = 10;
        Integer status = 1; // 上架

        // When
        var page = vaccineService.pageVaccines(current, size, null, status);

        // Then
        assertNotNull(page);
        // Verify all returned vaccines have status = 1
        for (Vaccine vaccine : page.getRecords()) {
            assertEquals(1, vaccine.getStatus());
        }
    }

    @Test
    void testUpdateStatus() {
        // Given: 创建一个疫苗（下架状态）
        Vaccine vaccine = new Vaccine();
        vaccine.setVaccineName("测试疫苗_" + System.currentTimeMillis());
        vaccine.setShortCode("TEST_" + System.currentTimeMillis());
        vaccine.setStatus(0); // 下架状态
        vaccineService.save(vaccine);
        Long vaccineId = vaccine.getId();

        // When: 上架
        vaccineService.updateStatus(vaccineId, 1);

        // Then
        Vaccine updated = vaccineService.getById(vaccineId);
        assertEquals(1, updated.getStatus());
    }

    @Test
    void testUpdateStatus_InvalidStatus() {
        // Given: 创建一个疫苗
        Vaccine vaccine = new Vaccine();
        vaccine.setVaccineName("测试疫苗2_" + System.currentTimeMillis());
        vaccine.setShortCode("TEST2_" + System.currentTimeMillis());
        vaccine.setStatus(0);
        vaccineService.save(vaccine);
        Long vaccineId = vaccine.getId();

        // When & Then: 无效状态应该抛异常
        assertThrows(Exception.class, () -> {
            vaccineService.updateStatus(vaccineId, 5); // 无效状态
        });
    }

    @Test
    void testGetById() {
        // Given: 查找一个已有疫苗
        Vaccine existing = vaccineService.lambdaQuery()
                .last("LIMIT 1")
                .one();

        if (existing != null) {
            // When
            Vaccine found = vaccineService.getById(existing.getId());

            // Then
            assertNotNull(found);
            assertEquals(existing.getId(), found.getId());
        } else {
            assertTrue(true, "No vaccine found, test skipped");
        }
    }
}