package com.yian.libsys.worbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName WorkbenchIndexController.java
 * @Description 跳转到业务的主页面
 * @createTime 2022年11月19日 17:59:00
 */
@Controller
public class WorkbenchIndexController {

    @RequestMapping("/workbench/index.do")
    public String index(){
        //跳转到业务主页面
        return "workbench/index";
    }

    @RequestMapping("/workbench/index2.do")
    public String index2(){
        //跳转到main/index.jsp
        return "workbench/index2";
    }
}
