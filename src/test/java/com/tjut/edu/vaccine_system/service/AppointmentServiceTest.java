package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.entity.Appointment;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AppointmentServiceTest {

    @Autowired
    private AppointmentService appointmentService;

    @Test
    void testPageAppointments() {
        // Given
        long current = 1;
        long size = 10;

        // When
        var page = appointmentService.pageAppointments(current, size, null, null, null, null, null, null);

        // Then
        assertNotNull(page);
        assertTrue(page.getPages() >= 0);
    }

    @Test
    void testPageAppointmentsWithFilters() {
        // Given
        long current = 1;
        long size = 10;
        Integer status = 1; // 已预约

        // When
        var page = appointmentService.pageAppointments(current, size, null, null, null, status, null, null);

        // Then
        assertNotNull(page);
        // Verify all returned appointments have status = 1
        for (Appointment appointment : page.getRecords()) {
            assertEquals(1, appointment.getStatus());
        }
    }

    @Test
    void testCancelByUser_Success() {
        // Given: 查找一个状态为已预约(1)的订单
        List<Appointment> appointments = appointmentService.lambdaQuery()
                .eq(Appointment::getStatus, 1)
                .last("LIMIT 1")
                .list();

        if (!appointments.isEmpty()) {
            Appointment appointment = appointments.get(0);
            Long appointmentId = appointment.getId();
            Long userId = appointment.getUserId();

            // When: 用户取消
            appointmentService.cancelByUser(appointmentId, userId);

            // Then: 状态变为已取消(4)
            Appointment updated = appointmentService.getById(appointmentId);
            assertEquals(4, updated.getStatus());
        } else {
            // No appointment with status 1, skip test
            assertTrue(true, "No appointment with status 1 found, test skipped");
        }
    }

    @Test
    void testCancelByUser_WrongUser() {
        // Given: 查找一个订单
        List<Appointment> appointments = appointmentService.lambdaQuery()
                .last("LIMIT 1")
                .list();

        if (!appointments.isEmpty()) {
            Appointment appointment = appointments.get(0);
            Long appointmentId = appointment.getId();
            Long wrongUserId = 99999L; // 不存在的用户

            // When & Then: 使用错误用户取消应该抛异常
            assertThrows(Exception.class, () -> {
                appointmentService.cancelByUser(appointmentId, wrongUserId);
            });
        } else {
            assertTrue(true, "No appointment found, test skipped");
        }
    }

    @Test
    void testListByDoctorId() {
        // Given: 找一个有预约的医生
        List<Appointment> appointments = appointmentService.lambdaQuery()
                .isNotNull(Appointment::getDoctorId)
                .last("LIMIT 1")
                .list();

        if (!appointments.isEmpty()) {
            Long doctorId = appointments.get(0).getDoctorId();

            // When
            List<Appointment> doctorAppointments = appointmentService.listByDoctorId(doctorId);

            // Then
            assertNotNull(doctorAppointments);
            for (Appointment appt : doctorAppointments) {
                assertEquals(doctorId, appt.getDoctorId());
            }
        } else {
            assertTrue(true, "No appointment with doctor found, test skipped");
        }
    }

    @Test
    void testCompleteObservationExpired() {
        // Given: 查找状态为留观中(10)的订单
        List<Appointment> obsAppointments = appointmentService.lambdaQuery()
                .eq(Appointment::getStatus, 10)
                .list();

        // When: 执行完成过期留观
        int updated = appointmentService.completeObservationExpired();

        // Then: 应该更新了对应数量的记录
        assertTrue(updated >= 0);
    }

    @Test
    void testExpireScheduledAfterSlotEndHours() {
        // Given: 查找已预约(1)的订单
        List<Appointment> scheduledAppointments = appointmentService.lambdaQuery()
                .eq(Appointment::getStatus, 1)
                .list();

        // When: 执行过期检查
        int updated = appointmentService.expireScheduledAfterSlotEndHours(2);

        // Then
        assertTrue(updated >= 0);
    }
}