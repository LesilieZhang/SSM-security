package com.yian.libsys.worbench.service.impl;

import com.yian.libsys.settings.web.controller.UserController;
import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.mapper.ReaderMapper;
import com.yian.libsys.worbench.service.ReaderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName ReaderServiceImpl.java
 * @Description TODO
 * @createTime 2022年11月19日 22:53:00
 */
@Service("readerService")
public class ReaderServiceImpl implements ReaderService {
    private final static Logger logger = LoggerFactory.getLogger((ReaderServiceImpl.class));

    @Autowired
    private ReaderMapper readerMapper;

    /**
     * 添加读者
     * @param reader
     * @return
     */
    @Override
    public int saveReader(Reader reader) {
        return readerMapper.insert(reader);
    }

    /**
     * 分页查询
     * @param map
     * @return
     */
    @Override
    public List<Reader> queryReaderByConditionForPage(Map<String, Object> map) {
        logger.info("map==="+map);
        return readerMapper.selectReaderByConditionForPage(map);
    }

    /**
     * 查询记录总数
     * @param map
     * @return
     */
    @Override
    public int queryCountOfReaderByCondition(Map<String, Object> map) {

        return readerMapper.selectCountOfReaderByCondition( map);
    }

    @Override
    public Reader queryReaderById(String id) {
        return readerMapper.selectReaderById(id);
    }

    @Override
    public int saveEditReader(Reader reader) {
        return readerMapper.updateReader(reader);
    }

    @Override
    public int deleteReaderByIds(String[] ids) {
        return readerMapper.deleteReaderByIds(ids);
    }
}
