package com.tjut.edu.vaccine_system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tjut.edu.vaccine_system.model.entity.VaccineSiteStock;
import com.tjut.edu.vaccine_system.model.vo.LowStockVO;

import java.util.List;

/**
 * 疫苗按接种点库存 Service（预约时校验并扣减）
 */
public interface VaccineSiteStockService extends IService<VaccineSiteStock> {

    /**
     * 查询某疫苗在某接种点的可用库存
     *
     * @param vaccineId 疫苗ID
     * @param siteId    接种点ID
     * @return 库存数，无记录返回 0
     */
    int getAvailableStock(Long vaccineId, Long siteId);

    /**
     * 扣减库存 1，仅当 stock > 0 时执行
     *
     * @param vaccineId 疫苗ID
     * @param siteId    接种点ID
     * @return 是否扣减成功（影响行数 > 0）
     */
    boolean decrementStock(Long vaccineId, Long siteId);

    /**
     * 库存预警：查询所有 stock < warning_threshold 的记录（任务书要求，供管理员大屏展示）
     *
     * @return 低库存列表（含疫苗名、接种点名、当前库存、预警阈值）
     */
    List<LowStockVO> listStockWarning();

    /**
     * 按接种点 ID 查询该接种点下所有疫苗库存列表
     */
    java.util.List<com.tjut.edu.vaccine_system.model.entity.VaccineSiteStock> listBySiteId(Long siteId);

    /**
     * 增加库存（无记录则先创建再加）
     */
    void addStock(Long siteId, Long vaccineId, int quantity);

    /**
     * 减少库存（库存不足时抛异常）
     */
    void reduceStock(Long siteId, Long vaccineId, int quantity);

    /**
     * 更新预警阈值
     */
    void updateWarningThreshold(Long stockId, Integer warningThreshold);

    /**
     * 某接种点库存列表（转 SiteStockVO，含疫苗名）
     */
    java.util.List<com.tjut.edu.vaccine_system.model.vo.SiteStockVO> listSiteStockVOBySiteId(Long siteId);

    /**
     * 直接设置库存数量（管理员修正用）
     */
    void setStockQuantity(Long stockId, Integer quantity);

    /**
     * 删除接种点下某条库存记录（移除该疫苗在该点的库存记录）
     */
    void removeStock(Long siteId, Long stockId);
}
