package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 按日接种趋势 VO（近 7 天等） */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyTrendVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String date;
    private Long count;
}
