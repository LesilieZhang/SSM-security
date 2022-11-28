package com.yian.libsys.worbench.service;

import com.yian.libsys.worbench.domain.Lend;
import java.util.List;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName LendService.java
 * @Description TODO
 * @createTime 2022年11月23日 15:28:00
 */
public interface LendService {

    /**
     * 根据学号查询借阅信息
     * @param studentId 学号
     * @return
     */
   List<Lend> queryBookByStuendtId(String studentId);

    /**
     * 保存借阅信息
     * @param lend 实体类
     * @return
     */
    int saveLend(Lend lend);

    /**
     * 更新借阅信息
     * @param lend
     * @return
     */
    int updateLend(Lend lend);

    Lend queryLendById(String id);

}
