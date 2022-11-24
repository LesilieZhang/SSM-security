package com.yian.libsys.worbench.service;

import com.yian.libsys.worbench.domain.Book;
import com.yian.libsys.worbench.domain.Reader;

import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName BookService.java
 * @Description TODO
 * @createTime 2022年11月20日 17:29:00
 */
public interface BookService {

    int saveBook(Book book);

    List<Book> queryBookByConditionForPage(Map<String,Object> map);

    int queryCountOfBookByCondition(Map<String,Object> map);


    Book queryBookById(String id);

    int saveEditBook(Book book);
    int deleteBookByIds(String[] ids);

}
