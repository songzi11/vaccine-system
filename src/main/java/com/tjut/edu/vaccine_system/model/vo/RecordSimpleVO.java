package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecordSimpleVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long orderId;
    private Long userId;
    private Long childId;
    private Long vaccineId;
    private Long doctorId;
    private Long siteId;
    private LocalDateTime vaccinateTime;
    private String status;
    private String remark;
    private LocalDateTime createTime;
}
