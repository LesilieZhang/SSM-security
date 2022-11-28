package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Book;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @RequestMapping("/workbench/lendbook/queryBookByConditionForPage.do")
    @ResponseBody
    public Object queryBookByConditionForPage(String bookname, String bookid, String author, String status, int pageNo, int pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("bookname", bookname);
        map.put("id", bookid);
        map.put("author", author);
        map.put("status", status);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        logger.info("封装好的map===" + map);
        List<Book> bookList = bookService.queryBookByConditionForPage(map);
        for(int i=0;i<bookList.size();i++){
            Book book=bookList.get(i);
            String addTime=book.getAddtime();
            logger.info("addTime==="+addTime);
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
}
