package com.yian.libsys.worbench.service.impl;

import com.yian.libsys.worbench.domain.Book;
import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.mapper.BookMapper;
import com.yian.libsys.worbench.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName BookServiceImpl.java
 * @Description TODO
 * @createTime 2022年11月20日 17:29:00
 */
@Service("bookService")
public class BookServiceImpl implements BookService {

    @Autowired
    private BookMapper bookMapper;
    @Override
    public int saveBook(Book book) {
        return bookMapper.insert(book);
    }

    @Override
    public List<Book> queryBookByConditionForPage(Map<String, Object> map) {
        return bookMapper.selectBookByConditionForPage(map);
    }

    @Override
    public int queryCountOfBookByCondition(Map<String, Object> map) {
        return bookMapper.selectCountOfBookByCondition(map);
    }

    @Override
    public Book queryBookById(String id) {
        return bookMapper.selectBookById(id);
    }

    @Override
    public int saveEditBook(Book book) {
        return bookMapper.updateBook(book);
    }

    @Override
    public int deleteBookByIds(String[] ids) {
        return bookMapper.deleteBookByIds(ids);
    }
}
