package com.atguigu.system.exception;

import com.atguigu.common.result.ResultCodeEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author ZhangYiAn
 * @version 1.0.0
 * @ClassName GuiguException.java
 * @Description 自定义异常
 * @createTime 2022年12月10日 19:37:00
 */
@Data
@AllArgsConstructor //有参构造
@NoArgsConstructor //无参构造
public class GuiguException extends RuntimeException{

    private Integer code;
    private String message;

    /**
     * 接收枚举类型对象
     * @param resultCodeEnum
     */
    public GuiguException(ResultCodeEnum resultCodeEnum) {
        super(resultCodeEnum.getMessage());
        this.code = resultCodeEnum.getCode();
        this.message = resultCodeEnum.getMessage();
    }

    @Override
    public String toString() {
        return "GuliException{" +
                "code=" + code +
                ", message=" + this.getMessage() +
                '}';
    }
}
