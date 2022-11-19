package com.yian.libsys.worbench.service.impl;

import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.service.ReaderService;
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
    @Override
    public int saveReader(Reader reader) {
        return 0;
    }

    @Override
    public List<Reader> queryReaderByConditionForPage(Map<String, Object> map) {
        return null;
    }

    @Override
    public int queryCountOfReaderByCondition(Map<String, Object> map) {
        return 0;
    }
}
