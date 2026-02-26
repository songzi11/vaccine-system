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
public class ChildProfileSimpleVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long parentId;
    private String name;
    private LocalDate birthDate;
    private Integer gender;
    private String contraindicationAllergy;
    private String vaccinationCardNo;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
