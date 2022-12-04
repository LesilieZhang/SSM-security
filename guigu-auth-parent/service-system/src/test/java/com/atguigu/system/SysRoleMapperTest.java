package com.atguigu.system;
import com.atguigu.model.system.SysRole;
import com.atguigu.system.mapper.SysRoleMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
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

    //根据id删除(只删除一个）
    @Test
    public void delete(){

    }
}