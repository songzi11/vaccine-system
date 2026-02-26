package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 疫苗按接种点简易库存（预约时扣减，高并发乐观锁）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine_site_stock")
public class VaccineSiteStock implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long vaccineId;
    private Long siteId;
    private Integer stock;
    private Integer warningThreshold;
    @Version
    private Integer version;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
