package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.web.controller.UserController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName MainController.java
 * @Description 跳转到workbench的index
 * @createTime 2022年11月19日 22:19:00
 */

@Controller
public class MainController {
    private final static Logger logger = LoggerFactory.getLogger((MainController.class));

    @RequestMapping("/workbench/main/index.do")
    public String index(){
        //跳转到main/index.jsp
        return "workbench/main/index";
    }


}
