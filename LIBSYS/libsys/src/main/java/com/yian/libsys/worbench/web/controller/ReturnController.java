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

import java.util.Date;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName ReturnController.java
 * @Description 归还图书类
 * @createTime 2022年11月28日 19:52:00
 */
@Controller
public class ReturnController {

    private final static Logger logger = LoggerFactory.getLogger(( ReturnController.class));
    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;
    @Autowired
    private ReaderService readerService;

    @Autowired
    private LendService lendService;

    @RequestMapping("/workbench/return/index.do")
    public String index(){
        return "workbench/return/index";
    }



    @RequestMapping("/workbench/return/returnBook.do")
    @ResponseBody
    public Object returnBook(String id, String bookname, String lender, String studentid){
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
        }else if("0".equals(book.getStatus())){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("此书已归还！");
        }
        Lend lend=lendService.queryLendById(id);
        Date backDate=new Date();
        Date lendDate=new Date();
        lend.setBacktime(backDate);
        if(backDate.compareTo(lendDate)>30){
            lend.setLate("1");//逾期归还
        }
        book.setStatus("0");//更新图书表中的借书状态
        try {
            int ret=lendService.updateLend(lend);
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
