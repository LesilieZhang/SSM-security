package com.atguigu.system.service.impl;

import com.atguigu.model.system.SysRole;
import com.atguigu.model.vo.SysRoleQueryVo;
import com.atguigu.system.mapper.SysRoleMapper;
import com.atguigu.system.service.SysRoleService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName SysRoleServiceImol.java
 * @Description TODO
 * @createTime 2022年12月04日 16:44:00
 */

@Service
public class SysRoleServiceImol extends ServiceImpl<SysRoleMapper, SysRole> implements SysRoleService {
    /**
     * 条件分页查询
     * @param pageParam
     * @param sysRoleQueryVo
     * @return
     */
    @Override
    public IPage<SysRole> selectPage(Page<SysRole> pageParam, SysRoleQueryVo sysRoleQueryVo) {
       IPage<SysRole> pageModel= baseMapper.selectPage(pageParam,sysRoleQueryVo);
        return null;
    }
}
