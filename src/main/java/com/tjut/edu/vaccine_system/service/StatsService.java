package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.vo.DailyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.HeatmapCellVO;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.MonthlyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;

import java.time.LocalDate;
import java.util.List;

/**
 * 统计 Service：今日接种、库存、趋势、低库存预警
 */
public interface StatsService {

    long countTodayVaccination();

    List<VaccineStockVO> listVaccineStock();

    List<MonthlyTrendVO> listMonthlyTrend(Integer year);

    /** 低库存预警（stock <= threshold，默认 5） */
    List<LowStockVO> listLowStock(int threshold);

    /** 近 7 天每日接种趋势 */
    List<DailyTrendVO> listTrendLast7Days();

    /**
     * 多维热力图：按接种点、疫苗类型、时间维度统计接种量（辅助卫生部门优化资源配置）
     *
     * @param dateFrom 开始日期
     * @param dateTo   结束日期
     */
    List<HeatmapCellVO> listHeatmap(LocalDate dateFrom, LocalDate dateTo);
}
