package com.tjut.edu.vaccine_system.model.vo;

import com.tjut.edu.vaccine_system.model.entity.Appointment;
import com.tjut.edu.vaccine_system.model.entity.ChildProfile;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * 医生端-待接种预约详情：预约信息、宝宝档案、家长信息、该宝宝过往接种记录（医生提交）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorAppointmentDetailVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Appointment appointment;
    private ChildProfile child;
    private String parentName;
    private String parentPhone;
    private String vaccineName;
    private String siteName;
    /** 该宝宝过往接种记录（含疫苗名、接种点名、医生名） */
    private List<RecordVO> pastRecords;
}
