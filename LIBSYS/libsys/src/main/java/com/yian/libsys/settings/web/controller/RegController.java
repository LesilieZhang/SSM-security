package com.yian.libsys.settings.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.commons.domain.ReturnObject;
import com.yian.libsys.commons.utils.DateUtils;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName RegController.java
 * @Description 注册控制
 * @createTime 2022年11月28日 22:13:00
 */
@Controller
public class RegController {

    private final static Logger logger = LoggerFactory.getLogger((RegController.class));
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/register/toRegister.do")
    public String toRegister(){
        //请求转发到注册页面
        return "settings/qx/register/register";
    }


    @RequestMapping("/settings/qx/register/register.do")
    @ResponseBody
    public Object register(User user, String username, String loginAct, String password, String email){
        logger.info("username=="+username);
        ReturnObject returnObject=new ReturnObject();
        user.setLoginAct(loginAct);
        user.setName(username);
        user.setLoginPwd(password);
        user.setEmail(email);
        user.setLockState("0");
        user.setCreatetime(DateUtils.formateDateTime(new Date()));
        try{
            int ret=userService.saveUser(user);
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
