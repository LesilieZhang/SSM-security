package com.yian.libsys.worbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName MainController.java
 * @Description 跳转到workbench的index
 * @createTime 2022年11月19日 22:19:00
 */

@Controller
public class MainController {

    @RequestMapping("/workbench/main/index.do")
    public String index(){
        //跳转到main/index.jsp
        return "workbench/main/index";
    }
}
