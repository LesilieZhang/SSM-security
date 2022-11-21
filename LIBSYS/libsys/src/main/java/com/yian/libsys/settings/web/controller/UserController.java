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

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName UserController.java
 * @Description 跳转登录页面
 * @createTime 2022年11月19日 16:15:00
 */

@Controller

public class UserController {

    private final static Logger logger = LoggerFactory.getLogger((UserController.class));

    @Autowired
    private UserService userService;
    /**
     * url要和当前controller方法将来访问的资源目录保持一致
     * src/main/webapp/WEB-INF/pages/settings/qx/user/login.jsp
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        //请求转发到登录页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, String userType,HttpServletRequest request, HttpServletResponse response, HttpSession session){
       logger.info("=====进入方法");

        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        logger.info("map==="+map);
        //传给sql语句的才要封装
        //调用service层方法，查询用户
        User user=userService.queryUserByLoginActAndPwd(map);

        //根据查询结果，生成响应信息
        ReturnObject returnObject=new ReturnObject();
        if(user==null) {
            //登录失败,用户名或者密码错误
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或者密码错误");
        }else{
            //进一步判断账号是否合法:跟当前时间比，最大过期时间比当前时间大--未过期
            if(DateUtils.formateDateTime(new Date()).compareTo(user.getExpireTime())>0){
                //登录失败，账号已过期
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期");
            }else if("0".equals(user.getLockState())){
                //登录失败，状态被锁定
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("状态被锁定");
            }else{
                //登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                if("0".equals(userType)){
                    logger.info("管理员登录");
                    returnObject.setUserType("0");
                }else {
                    logger.info("读者登录");
                    returnObject.setUserType("1");
                }
                //把user保存到session中
                session.setAttribute(Contants.SESSION_USER,user);
                //如果需要记住密码，则往外写cookie
                if("true".equals(isRemPwd)){
                    Cookie c1=new Cookie("loginAct",user.getLoginAct());
                    c1.setMaxAge(10*24*60*60);//记住十天
                    response.addCookie(c1);
                    Cookie c2=new Cookie("loginPwd",user.getLoginPwd());
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else{
                    //把没有过期cookie删除
                    Cookie c1=new Cookie("loginAct","1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2=new Cookie("loginPwd","1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        logger.info("返回的是=="+returnObject.getCode());
        logger.info("返回的用户类型=="+returnObject.getUserType());
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        //清空cookie
        Cookie c1=new Cookie("loginAct","1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2=new Cookie("loginPwd","1");
        c2.setMaxAge(0);
        response.addCookie(c2);
        //销毁session
        session.invalidate();
        //跳转到首页
        return "redirect:/";//借助springmvc来重定向
    }
}
