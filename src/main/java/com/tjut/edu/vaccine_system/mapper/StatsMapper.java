package com.tjut.edu.vaccine_system.mapper;

import com.tjut.edu.vaccine_system.model.vo.DailyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.HeatmapCellVO;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.MonthlyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 统计 Mapper（今日接种、疫苗库存、每月趋势、低库存预警、近7日趋势）
 */
@Mapper
public interface StatsMapper {

    Long countTodayVaccination();

    List<VaccineStockVO> listVaccineStock();

    List<MonthlyTrendVO> listMonthlyTrend(@Param("year") Integer year);

    /** 低库存预警：vaccine_site_stock 中 stock <= threshold 的条目 */
    List<LowStockVO> listLowStock(@Param("threshold") int threshold);

    /** 近 7 天每日接种数 */
    List<DailyTrendVO> listTrendLast7Days();

    /**
     * 多维热力图：按接种点、疫苗类型、日期维度统计接种量（辅助卫生部门优化资源配置）
     *
     * @param dateFrom 开始日期
     * @param dateTo   结束日期
     */
    List<HeatmapCellVO> listHeatmap(@Param("dateFrom") LocalDate dateFrom, @Param("dateTo") LocalDate dateTo);
}
