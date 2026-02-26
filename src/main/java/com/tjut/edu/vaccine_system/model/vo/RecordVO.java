package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 接种记录展示 VO（含疫苗名称、接种点名称、医生姓名）
 * 用户端列表合并 record 与 vaccination_record，source 区分来源便于前端 key
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecordVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    /** 来源：record | vaccination_record */
    private String source;
    private Long orderId;
    private Long userId;
    private Long childId;
    private String childName;
    private Long vaccineId;
    private String vaccineName;
    private Long doctorId;
    private String doctorName;
    private Long siteId;
    private String siteName;
    private LocalDateTime vaccinateTime;
    private String status;
    private String remark;
    /** 疫苗编号（仅接种记录展示，家长端不展示批次信息） */
    private String vaccineCode;
}
