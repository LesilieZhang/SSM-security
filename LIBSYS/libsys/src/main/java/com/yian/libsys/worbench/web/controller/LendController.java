package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.commons.domain.ReturnObject;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Book;
import com.yian.libsys.worbench.domain.Lend;
import com.yian.libsys.worbench.service.BookService;
import com.yian.libsys.worbench.service.LendService;
import com.yian.libsys.worbench.service.ReaderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName LendController.java
 * @Description TODO
 * @createTime 2022年11月28日 18:59:00
 */
@Controller
public class LendController {
    private final static Logger logger = LoggerFactory.getLogger(( LendController.class));
    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;
    @Autowired
    private ReaderService readerService;

    @Autowired
    private LendService lendService;

    @RequestMapping("/workbench/lendmain/index.do")
    public String index(){
        return "workbench/lendmain/index";
    }

    @RequestMapping("/workbench/lendmainbook/saveLender.do")
    @ResponseBody
    public Object saveLender(Lend lend, String id, String bookname, String lender, String studentid){
        ReturnObject returnObject = new ReturnObject();
        if(logger.isDebugEnabled()){
            logger.info("前台传来的值："+id);
            logger.info("前台传来的值："+bookname);
            logger.info("前台传来的值："+lender);
            logger.info("前台传来的值："+studentid);
        }
        //与图书表对比
       Book book= bookService.queryBookById(id);
        if(book==null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("此书不存在图书库中");
        }else if("1".equals(book.getStatus())){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("此书已借出！");
        }
        lend.setLender(lender);
        lend.setId(id);
        lend.setBookname(bookname);
        lend.setStudentId(studentid);
        lend.setLendtime(new Date());
        lend.setLate("0");
        book.setStatus("1");//更新图书表中的借书状态
        try {
            int ret=lendService.saveLend(lend);
            int ret_book=bookService.saveEditBook(book);
            if (ret > 0&&ret_book>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试....");
        }
        return returnObject;
    }
}
