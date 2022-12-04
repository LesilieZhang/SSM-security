package com.atguigu.system;
import com.atguigu.model.system.SysRole;
import com.atguigu.system.mapper.SysRoleMapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;


/**
 * 测试类
 */
@SpringBootTest
public class SysRoleMapperTest {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    //1查询表中的所有记录
    @Test
    public void findAll(){
        List<SysRole> list= sysRoleMapper.selectList(null);
        for(SysRole sysRole:list){
            System.out.println(sysRole);
        }
    }
    //修改操作
    @Test
    public void update(){
        //根据id查询
        SysRole sysRole = sysRoleMapper.selectById(1);
        //设置修改的值
        sysRole.setDescription("系统管理员尚硅谷");
        //调用方法
        sysRoleMapper.updateById(sysRole);
    }

   //条件查询
    @Test
    public void testSelect(){
        //创建一个条件构造器对象
        QueryWrapper<SysRole> queryWrapper=new QueryWrapper<>();
        //第一个参数：表里的字段名称，第二个参数，字段值
      //  queryWrapper.eq("role_name","用户管理员");
        queryWrapper.like("role_name","管理员");//模糊查询
        List<SysRole> sysRoleList = sysRoleMapper.selectList(queryWrapper);
        System.out.println(sysRoleList);
    }
}