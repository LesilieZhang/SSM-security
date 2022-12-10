package com.atguigu.system.controller;

import com.atguigu.common.result.Result;
import io.swagger.annotations.Api;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName IndexController.java
 * @Description 服务器端增加接口
 * @createTime 2022年12月10日 21:10:00
 */

@Api(tags = "用户登录的接口")
@RestController
@RequestMapping("/admin/system/index")
public class IndexController {

    /**
     * 登录接口
     * @return
     */
    @PostMapping("/login")
    public Result login(){
        Map<String,Object> map=new HashMap<>();
        map.put("token","admin-token atguigu");
        return  Result.ok(map);
    }

    /**
     * info接口
     * @return
     */
    @GetMapping("/info")
    public Result info(){
        Map<String,Object> map=new HashMap<>();
        map.put("roles","[admin]");
        map.put("name","Super Admin atguigu");
        map.put("avatar","https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif");//头像
        return Result.ok(map);
    }

    /**
     * 退出
     * @return
     */
    @PostMapping("/logout")
    public Result logout(){
        return Result.ok();
    }

}
