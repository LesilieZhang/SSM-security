package com.yian.libsys.worbench.service;

import com.yian.libsys.worbench.domain.Reader;

import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName ReaderService.java
 * @Description 读者管理-service层
 * @createTime 2022年11月19日 22:52:00
 */
public interface ReaderService {

    int saveReader(Reader reader);

    List<Reader> queryReaderByConditionForPage(Map<String,Object> map);

    int queryCountOfReaderByCondition(Map<String,Object> map);


    Reader queryReaderById(String id);

    int saveEditReader(Reader reader);
}
