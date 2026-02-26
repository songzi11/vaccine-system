package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentSimpleVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private Long childId;
    private Long vaccineId;
    private Long siteId;
    private LocalDate appointmentDate;
    private String timeSlot;
    private Integer status;
    private String statusLabel;
    private Long doctorId;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
