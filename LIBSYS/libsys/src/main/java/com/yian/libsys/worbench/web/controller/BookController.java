package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.commons.domain.ReturnObject;
import com.yian.libsys.commons.utils.DateUtils;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Book;
import com.yian.libsys.worbench.domain.Reader;
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
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName BookController.java
 * @Description
 * @createTime 2022年11月20日 17:28:00
 */

@Controller
public class BookController {
    private final static Logger logger = LoggerFactory.getLogger(( BookController.class));

    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;
    @Autowired
    private ReaderService readerService;

    @Autowired
    private LendService lendService;
    @RequestMapping("/workbench/book/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //把数据保存到request中
        request.setAttribute("userList", userList);
        //请求转发到图书信息的主页面
        return "workbench/book/index";
    }

    @RequestMapping("/workbench/book/saveBook.do")
    @ResponseBody
    public Object saveBook(Book book, HttpSession session){
        logger.info("进入当前方法");
        //获取当前用户
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        logger.info("bookid==="+book.getId());
        book.setAddtime(DateUtils.formateDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = bookService.saveBook(book);
            logger.info("返回信息==" + ret);
            if (ret > 0) {
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

    @RequestMapping("/workbench/book/queryBookByConditionForPage.do")
    @ResponseBody
    public Object queryBookByConditionForPage(String bookname, String bookid, String author, String status, int pageNo, int pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("bookname", bookname);
        map.put("id", bookid);
        map.put("author", author);
        map.put("status", status);
        logger.info("status==="+status);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        logger.info("封装好的map===" + map);
        List<Book> bookList = bookService.queryBookByConditionForPage(map);
        for(int i=0;i<bookList.size();i++){
            Book book=bookList.get(i);
            String addTime=book.getAddtime();
            if("0".equals(book.getStatus())){
                book.setStatus(Contants.CANLEND);
            }else{
                book.setStatus(Contants.CANNOTLEND);
            }
        }
        logger.info("查询回来的数据bookList===" + bookList);
        int totalRows = bookService.queryCountOfBookByCondition(map);
        //根据查询结果结果，生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("bookList", bookList);
        retMap.put("totalRows", totalRows);
        logger.info("retMap====" + retMap);
        return retMap;
    }

    @RequestMapping("/workbench/book/queryBookById.do")
    @ResponseBody
    public Object queryBookById(String id, HttpSession session) {
        logger.info("传过来的id是===" + id);
        Book book=bookService.queryBookById(id);
        //根据查询结果，返回响应信息
        User user = (User) session.getAttribute(Contants.SESSION_USER);;
        return book;
    }

    @RequestMapping("/workbench/books/saveEditBook.do")
    @ResponseBody
    public Object saveEditBook(Book book, HttpSession session) {
        logger.info("进入方法");
        logger.info("book信息"+book.getId());
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = bookService.saveEditBook(book);
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }


    @RequestMapping("/workbench/book/deleteBookIds.do")
    @ResponseBody
    public Object deleteBook(String[] id) {
        //形参String[] id：接受前台发来的数组
        logger.info("id==="+id);
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = bookService.deleteBookByIds(id);
            //ret接受返回删除的影响记录条数
            if (ret > 0) {//如果影响记录条数>0
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);//删除成功
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);//删除失败
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }
}
