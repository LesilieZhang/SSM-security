package com.atguigu.system.controller;

import com.atguigu.common.result.Result;
import com.atguigu.model.system.SysRole;
import com.atguigu.model.vo.SysRoleQueryVo;
import com.atguigu.system.service.SysRoleService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
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
     * @requertbody:不能使用get提交方式
     * 传递json格式数据，把json格式数据封装到对象里面{....}
     * @param sysRole
     * @return
     */
    @ApiOperation("添加角色")
    @PostMapping("save")
    public Result saveRole(@RequestBody SysRole sysRole){
        boolean isSuccess = sysRoleService.save(sysRole);
        if(isSuccess){
            return Result.ok();
        }else{
            return Result.fail();
        }
    }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    @ApiOperation("根据id角色查询实体类")
    @PostMapping("findRoleById/{id}")
    public Result findRoleById(@PathVariable Long id){
       SysRole sysRole=sysRoleService.getById(id);
       return Result.ok();
    }

    /**
     * 传入带有id的对象
     * @param sysRole
     * @return
     */
    @ApiOperation("修改角色")
    @PostMapping("update")
    public Result updateRole(@RequestBody SysRole sysRole) {
        boolean isSuccess = sysRoleService.updateById(sysRole);
        if (isSuccess) {
            return Result.ok();
        } else {
            return Result.fail();
        }
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

    /**
     * 条件分页查询接口
     * page:页数
     * limit：每页显示多少
     * @return
     */
    @ApiOperation("条件分页查询")
    @GetMapping("{page}/{limit}")
    public Result findQueryRole(@PathVariable Long page, @PathVariable Long limit, SysRoleQueryVo sysRoleQueryVo){
        //插件page对象
        Page<SysRole> pageParam=new Page<>(page,limit);
        //调用service方法实现
        IPage<SysRole> pageModel=sysRoleService.selectPage(pageParam,sysRoleQueryVo);
        //返回
        return Result.ok(pageModel);
    }

    /**
     * 得到多个id [id1,id2,id2]
     * json中的数组对应java中的list集合
     * @return
     */
    @ApiOperation("批量删除接口")
    @DeleteMapping("batchRemove")
    public Result batchRemove(@RequestBody List<Long> ids) {
        boolean isSuccess = sysRoleService.removeByIds(ids);
        return Result.ok();
    }
}
