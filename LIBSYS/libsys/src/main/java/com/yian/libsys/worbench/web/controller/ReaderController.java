package com.yian.libsys.worbench.web.controller;

import com.yian.libsys.commons.contants.Contants;
import com.yian.libsys.commons.utils.DateUtils;
import com.yian.libsys.commons.utils.UUIDUtils;
import com.yian.libsys.settings.domain.User;
import com.yian.libsys.settings.service.UserService;
import com.yian.libsys.worbench.domain.Lend;
import com.yian.libsys.worbench.domain.Reader;
import com.yian.libsys.worbench.service.LendService;
import com.yian.libsys.worbench.service.ReaderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private final static Logger logger = LoggerFactory.getLogger((ReaderController.class));

    @Autowired
    private UserService userService;

    @Autowired
    private ReaderService readerService;

    @Autowired
    private LendService lendService;

    @RequestMapping("/workbench/reader/index.do")
    public String index(HttpServletRequest request) {
        //调用service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //把数据保存到request中
        request.setAttribute("userList", userList);
        //请求转发到读者信息的主页面
        return "workbench/reader/index";
    }

    @RequestMapping("/workbench/reader/saveReader.do")
    @ResponseBody
    public Object saveReader(Reader reader, HttpSession session) {
        logger.info("进入当前方法");
        //获取当前用户
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        reader.setId(UUIDUtils.getUUID());
        reader.setCreateTime((new Date()));
        reader.setUpdateTime(new Date());
        reader.setCreateUser(user.getName());
        reader.setUpdateUser(user.getName());
        reader.setStatus(1);//正常状态
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = readerService.saveReader(reader);
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("添加成功！");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试....");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/reader/queryReaderByConditionForPage.do")
    @ResponseBody
    public Object queryReaderByConditionForPage(String name, String idNum, String dept, String className, int pageNo, int pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("idNumber", idNum);
        map.put("deptname", dept);
        map.put("classname", className);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        logger.info("封装好的map===" + map);
        List<Reader> readerList = readerService.queryReaderByConditionForPage(map);
        logger.info("查询回来的数据readerList===" + readerList);
        int totalRows = readerService.queryCountOfReaderByCondition(map);
        //根据查询结果结果，生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("readerList", readerList);
        retMap.put("totalRows", totalRows);
        logger.info("retMap====" + retMap);
        return retMap;
    }

    @RequestMapping("/workbench/reader/queryReaderById.do")
    @ResponseBody
    public Object queryReaderById(String id, HttpSession session) {
        logger.info("传过来的id是===" + id);
        Reader reader = readerService.queryReaderById(id);
        //根据查询结果，返回响应信息
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        reader.setCreateUser(user.getName());
        logger.info("返回的学号是==" + reader.getIdNumber());
        return reader;
    }

    @RequestMapping("/workbench/reader/saveEditReader.do")
    @ResponseBody
    public Object saveEditReader(Reader reader, HttpSession session) {
        //获得当前的user
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        reader.setUpdateTime(new Date());
        reader.setUpdateUser(user.getName());
        logger.info("id===" + reader.getId());
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = readerService.saveEditReader(reader);
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("修改成功！");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }


    @RequestMapping("/workbench/reader/deleteReaderIds.do")
    @ResponseBody
    public Object deleteReader(String[] id) {
        //形参String[] id：接受前台发来的数组
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = readerService.deleteReaderByIds(id);
            //ret接受返回删除的影响记录条数
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

        @RequestMapping("/workbench/reader/queryBookDetailByStudentIdForPage.do")
        @ResponseBody
        public Object queryBookDetailByStudentIdForPage(String id){
            List<Lend> bookList=lendService.queryBookByStuendtId(id);
            logger.info("查询回来的数据bookList==="+bookList);
            Date curryDate=new Date();
            for(int i=0;i<bookList.size();i++){
                Lend lend=bookList.get(i);
                Date lendDate=lend.getLendtime();
                String nowDate=DateUtils.formateDateTime(curryDate);
                String lendtime=DateUtils.formateDateTime(lendDate);
                if(nowDate.compareTo(lendtime)>30){
                    lend.setLate(Contants.ISLATE);//逾期
                }else{
                   lend.setLate(Contants.NOTLATE);
                }
            }
            int totalRows=bookList.size();
            //根据查询结果结果，生成响应信息
            Map<String,Object> retMap=new HashMap<>();
            retMap.put("bookList",bookList);
            retMap.put("totalRows",totalRows);
            logger.info("retMap===="+retMap);
            return retMap;
        }
}
