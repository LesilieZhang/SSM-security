package com.yian.libsys.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName IndexController.java
 * @Description 控制login
 * @createTime 2022年11月19日 16:02:00
 */

@Controller
public class IndexController {

    /**
     * http://127.0.0.1:8099/libsys/
     * 为了简便，协议//ip:port/appname 应该省去，用/代表应用根目录下的/
     * @return
     */
    @RequestMapping("/")
    public String index(){
        //请求转发:资源路径
        /**视图解析器，自动加上前缀后缀
         * src/main/webapp/WEB-INF/pages/index.jsp
         */
        return "index";
    }
}
