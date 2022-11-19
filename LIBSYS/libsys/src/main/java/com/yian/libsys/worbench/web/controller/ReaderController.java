package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.commons.utils.DateUtils;
import com.yian.libsys.commons.utils.UUIDUtils;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.service.ReaderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import com.yian.libsys.commons.domain.ReturnObject;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName ReaderController.java
 * @Description 读者信息管理
 * @createTime 2022年11月19日 22:45:00
 */

@Controller
public class ReaderController {

    @Autowired
    private UserService userService;

    @Autowired
    private ReaderService readerService;

    @RequestMapping("/workbench/reader/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法，查询所有的用户
      List<User> userList=userService.queryAllUsers();
      //把数据保存到request中
        request.setAttribute("userList",userList);
        //请求转发到市场活动的主页面
        return "workbench/reader/index";
    }

    @RequestMapping("/workbench/activity/saveReader.do")
    @ResponseBody
    public Object saveReader(Reader reader, HttpSession session){
        //获取当前用户
        User user=(User) session.getAttribute(Contants.SESSION_USER);
        reader.setId(UUIDUtils.getUUID());
        reader.setCreateTime((new Date()));
        reader.setCreateUser(user.getId());
        ReturnObject returnObject=new ReturnObject();
        try{
            int ret=readerService.saveReader(reader);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试....");
            }
        }
        catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试....");
        }
        return returnObject;
    }

}
