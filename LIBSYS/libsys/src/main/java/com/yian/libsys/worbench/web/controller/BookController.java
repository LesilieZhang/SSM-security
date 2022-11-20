package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.settings.domain.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName BookController.java
 * @Description
 * @createTime 2022年11月20日 17:28:00
 */

@Controller
public class BookController {

    @RequestMapping("/workbench/book/index.do")
    public String index(HttpServletRequest request){

        //请求转发到图书信息的主页面
        return "workbench/reader/index";
    }

}
