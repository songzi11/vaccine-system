package com.tjut.edu.vaccine_system.service.impl;

import com.tjut.edu.vaccine_system.model.vo.DailyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.HeatmapCellVO;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;
import com.tjut.edu.vaccine_system.model.vo.MonthlyTrendVO;
import com.tjut.edu.vaccine_system.model.vo.VaccineStockVO;
import com.tjut.edu.vaccine_system.mapper.StatsMapper;
import com.tjut.edu.vaccine_system.service.StatsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Year;
import java.util.List;

/**
 * 统计 Service 实现：今日接种、各疫苗库存、每月趋势、低库存预警、近7日趋势
 */
@Service
@RequiredArgsConstructor
public class StatsServiceImpl implements StatsService {

    private final StatsMapper statsMapper;

    /** 低库存阈值：低于等于此值即预警 */
    private static final int DEFAULT_LOW_STOCK_THRESHOLD = 5;

    @Override
    public long countTodayVaccination() {
        Long count = statsMapper.countTodayVaccination();
        return count != null ? count : 0L;
    }

    @Override
    public List<VaccineStockVO> listVaccineStock() {
        return statsMapper.listVaccineStock();
    }

    @Override
    public List<MonthlyTrendVO> listMonthlyTrend(Integer year) {
        if (year == null) {
            year = Year.now().getValue();
        }
        return statsMapper.listMonthlyTrend(year);
    }

    @Override
    public List<LowStockVO> listLowStock(int threshold) {
        return statsMapper.listLowStock(threshold);
    }

    @Override
    public List<DailyTrendVO> listTrendLast7Days() {
        return statsMapper.listTrendLast7Days();
    }

    @Override
    public List<HeatmapCellVO> listHeatmap(LocalDate dateFrom, LocalDate dateTo) {
        if (dateFrom == null) dateFrom = LocalDate.now().minusMonths(1);
        if (dateTo == null) dateTo = LocalDate.now();
        if (dateFrom.isAfter(dateTo)) dateTo = dateFrom;
        return statsMapper.listHeatmap(dateFrom, dateTo);
    }
}
