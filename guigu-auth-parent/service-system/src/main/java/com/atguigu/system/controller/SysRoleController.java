package com.atguigu.system.controller;

import com.atguigu.common.result.Result;
import com.atguigu.model.system.SysRole;
import com.atguigu.system.service.SysRoleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName SysRoleController.java
 * @Description 用户管理模块-crud接口
 * @createTime 2022年12月04日 16:54:00
 */

@Api(tags = "角色管理的接口")
@RestController
@RequestMapping("/admin/system/sysRole")
public class SysRoleController {
    @Autowired
    private SysRoleService sysRoleService;

    /** http://localhost:8800/admin/system/sysRole/findAll
     * 查询所有的记录
     * @return
     */
    @ApiOperation("查询所有的接口")
    @GetMapping("findAll")
    public Result<List<SysRole>> findAll() {
        List<SysRole> roleList = sysRoleService.list();
        return Result.ok(roleList);
    }

    /**
     *取到路径中的id值
     * @return
     */
    @ApiOperation("逻辑删除的接口")
    @DeleteMapping("remove/{id}")
    public Result removeRole(@PathVariable Long id) {
        //调用方法进行删除
        boolean isSuccess = sysRoleService.removeById(id);
        if (isSuccess) {
        return Result.ok();
        }else{
            return Result.fail();//失败
        }
    }
}
