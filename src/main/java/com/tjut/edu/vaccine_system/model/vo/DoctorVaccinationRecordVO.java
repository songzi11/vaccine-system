package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 医生端：本人接种记录 VO（含宝宝名、疫苗名、接种点名）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorVaccinationRecordVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long childId;
    private String childName;
    private Long vaccineId;
    private String vaccineName;
    private Long siteId;
    private String siteName;
    private LocalDateTime vaccinationDate;
    private Integer doseNumber;
}
