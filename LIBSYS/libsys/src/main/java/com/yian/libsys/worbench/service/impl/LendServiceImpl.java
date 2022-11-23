package com.yian.libsys.worbench.service.impl;

import com.yian.libsys.worbench.domain.Lend;
import com.yian.libsys.worbench.mapper.LendMapper;
import com.yian.libsys.worbench.mapper.ReaderMapper;
import com.yian.libsys.worbench.service.LendService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName LendServiceImpl.java
 * @Description TODO
 * @createTime 2022年11月23日 15:28:00
 */
@Service("lendService")
public class LendServiceImpl implements LendService {

    private final static Logger logger = LoggerFactory.getLogger((LendServiceImpl.class));

    @Autowired
    private LendMapper lendMapper;
    @Override
    public List<Lend> queryBookByStuendtId(String studentId) {
        return lendMapper.selectBookByStudentId(studentId);
    }
}
