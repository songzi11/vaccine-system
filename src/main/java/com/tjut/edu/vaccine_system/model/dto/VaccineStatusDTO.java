package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.io.Serializable;

/**
 * 疫苗上架/下架请求体
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VaccineStatusDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 状态：0-下架，1-上架 */
    @NotNull(message = "状态不能为空")
    private Integer status;
}
