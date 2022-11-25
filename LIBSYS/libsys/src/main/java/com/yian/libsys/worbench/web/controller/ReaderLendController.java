package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.service.BookService;
import com.yian.libsys.worbench.service.ReaderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName ReaderLendController.java
 * @Description TODO
 * @createTime 2022年11月25日 21:55:00
 */
@Controller
public class ReaderLendController {
    private final static Logger logger = LoggerFactory.getLogger(( ReaderLendController.class));
    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;
    @Autowired
    private ReaderService readerService;

    @RequestMapping("/workbench/lendbook/index.do")
    public String index(HttpServletRequest request){
        return "workbench/lendbook/index";
    }

    @RequestMapping("/workbench/lendmain/index.do")
    public String lendindex(HttpServletRequest request){
        return "workbench/lendmain/lendindex";
    }



}
