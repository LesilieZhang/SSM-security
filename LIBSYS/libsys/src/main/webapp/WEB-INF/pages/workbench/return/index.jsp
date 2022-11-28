<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">
        $(function(){
            $("#lendBtn").click(function(){
                var bookid=$.trim($("#bookid").val());//图书编号
                var bookname=$.trim($("#bookname").val());//书名
                var lender=$.trim($("#lender").val());//借书人
                var studentid =$.trim($("#studentid").val());//借书人学号
                //表单验证
                if(bookid==""){
                    alert("图书编号不能为空");
                    return;
                }
                var myreg=/[0-9]/g;
                if(!myreg.test(bookid)){
                    alert("请输入正确图书编号！")
                    return;
                }
                if(bookid.length!=13){
                    alert("请输入13位IBSN编号！")
                    return;
                }
                if(bookname==""){
                    alert("图书名称不能为空");
                    return;
                }
                if(lender==""){
                    alert("借书人姓名不能为空");
                    return;
                }
                if (!myreg.test(studentid)){
                    alert("请输入正确的学号！")
                    return;
                }
                if(studentid==""){
                    alert("借书人学号不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:'workbench/return/returnBook.do',
                    data:{
                        id:bookid,
                        bookname:bookname,
                        lender:lender,
                        studentid,studentid
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            window.confirm("添加成功！");
                        }else{
                            //提示信息
                            alert(data.message);
                        }
                    }
                });
            });



        });
    </script>
</head>
<body>
<form>
    <div class="form-row">
        <div class="form-group">
            <label for="bookid" class="col-sm-2 control-label" >图书编号</label>
            <input type="text" class="form-control" id="bookid" placeholder="请输入图书编号">
        </div>
        <div class="form-group">
            <label for="bookname" class="col-sm-2 control-label">图书名称</label>
            <input type="text" class="form-control" id="bookname">
        </div>
    </div>
    <div class="form-group">
        <label for="lender" class="col-sm-2 control-label"> 借书人姓名</label>
        <input type="text" class="form-control" id="lender" placeholder="必填">
    </div>
    <div class="form-group">
        <label for="studentid" class="col-sm-2 control-label">借书人学号</label>
        <input type="text" class="form-control" id="studentid" placeholder="必填">
    </div>
    <button type="button" class="btn btn-primary" id="lendBtn"><span class="glyphicon glyphicon-plus"></span> 归还</button>
</form>
</body>
</html>
