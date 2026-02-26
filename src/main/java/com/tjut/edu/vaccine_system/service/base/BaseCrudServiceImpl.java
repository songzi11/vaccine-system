package com.tjut.edu.vaccine_system.service.base;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.transaction.annotation.Transactional;

/**
 * 通用 CRUD Service 基类，提供 page/save/update/removeById/getById 等能力。
 * 各模块 ServiceImpl 可继承此类减少重复代码。
 *
 * @param <M> Mapper
 * @param <T> Entity
 */
public abstract class BaseCrudServiceImpl<M extends BaseMapper<T>, T> extends ServiceImpl<M, T> {

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean save(T entity) {
        return super.save(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateById(T entity) {
        return super.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeById(java.io.Serializable id) {
        return super.removeById(id);
    }
}
