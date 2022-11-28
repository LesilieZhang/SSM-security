package com.yian.libsys.settings.service;

import com.yian.libsys.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName UserService.java
 * @Description TODO
 * @createTime 2022年11月19日 17:41:00
 */
public interface UserService {

    /**
     * 根据用户名和密码查询
     * @param map
     * @return
     */
    User queryUserByLoginActAndPwd(Map<String,Object> map);

    /**
     * 查询所有的用户
     * @return
     */
    List<User> queryAllUsers();

    /**
     * 添加用户
     * @param user
     * @return
     */
    int saveUser(User user);
}
