package com.atguigu.system.exception;

import com.atguigu.common.result.Result;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName GlobalExceptionHandler.java
 * @Description 异常处理
 *  全局异常
 *  特定异常
 * @createTime 2022年12月10日 19:32:00
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 全局异常
     * responsebody:返回json数据
     * @param e
     * @return
     */
    @ResponseBody
    @ExceptionHandler(Exception.class)
    public Result error(Exception e){
        e.printStackTrace();
        return Result.fail().message("执行了全局异常");
    }


    /**
     * 特定异常处理
     * @param e
     * @return
     */
    @ExceptionHandler(ArithmeticException.class)
    @ResponseBody
    public Result error(ArithmeticException e){
        e.printStackTrace();
        return Result.fail().message("执行了特定异常处理");
    }

    /**
     * 自定义异常
     * @param e
     * @return
     */
    @ExceptionHandler(GuiguException.class)
    @ResponseBody
    public Result error(GuiguException e){
        e.printStackTrace();
        return Result.fail().message(e.getMessage()).code(e.getCode());
    }
}
