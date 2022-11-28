<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function () {
		//给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			//如果按的是回车键，则提交登录请求
			if(e.keyCode==13){
				$("#loginBtn").click();
			}
		});
		//给"登录"按钮添加单击事件
		$("#loginBtn").click(function () {
			//收集参数
			var manager=$("#ManagerLogin").prop("checked");
			var reader=$("#ReaderLogin").prop("checked");
			var loginAct=$.trim($("#loginAct").val());
			var loginPwd=$.trim($("#loginPwd").val());
			var isRemPwd=$("#isRemPwd").prop("checked");
			var userType=null;
			if(manager==false&&reader==false){
				alert("请至少选择一种登录方式！")
				return;
			}
			if(manager&&reader){
				alert("只能选择一种登录方式");
				return;
			}
			if(manager==true&&reader==false){
				userType="0";
			}else{
				userType="1";
			}
			//表单验证
			if(loginAct==""){
				alert("用户名不能为空");
				return;
			}
			if(loginPwd==""){
				alert("密码不能为空");
				return;
			}
			//显示正在验证
			//$("#msg").text("正在努力验证....");
			//发送请求
			$.ajax({
				url:'settings/qx/user/login.do',
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					userType:userType,
					isRemPwd:isRemPwd

				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//跳转到业务主页面
						if(data.userType=="0"){
							window.location.href="workbench/index.do";
						}else{
							window.location.href="workbench/index2.do";
						}
					}else{
						//提示信息
						$("#msg").text(data.message);
					}
				},
				beforeSend:function () {//当ajax向后台发送请求之前，会自动执行本函数；
					                    //该函数的返回值能够决定ajax是否真正向后台发送请求：
									    //如果该函数返回true,则ajax会真正向后台发送请求；否则，如果该函数返回false，则ajax放弃向后台发送请求。
					$("#msg").text("正在努力验证....");
					return true;
				}
			});
		});
		$("#regBtn").click(function (){
			//初始化工作
			//重置表单
			//$("#createUserForm").get(0).reset();
			//弹出创建市场活动的模态窗口
			$("#AddUserModal").modal("show");
		});
		//给"保存"按钮添加单击事件
		$("#saveUserBtn").click(function () {
			//收集参数
			var username=$.trim($("#username").val());
			var loginAct=$.trim($("#loginName").val());
			var password =$.trim($("#password").val());
			var passwordConfirm=$.trim($("#passwordConfirm").val());
			var email=$.trim($("#email").val());
			//表单验证
			if(username==""){
				alert("用户名不能为空");
				return;
			}
			if(loginAct==""){
				alert("登录名不能为空");
				return;
			}
			if(password!=passwordConfirm){
				alert("两次输入的密码不一致");
				return;
			}
			if(password.length!=6){
				alert("请输入六位密码！")
				return;
			}
			var msg=/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
		    if(!msg.test(email)){
				alert("请输入正确邮箱！")
				return;
			}
			//发送请求
			$.ajax({
				url:'settings/qx/register/register.do',
				data:{
				    username:username,
					loginAct:loginAct,
					password,password,
					email,email
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						window.confirm("注册成功！");
						$("#AddUserModal").modal("hide");
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#AddUserModal").modal("show");
					}
				}
			});
		});
	});
</script>
</head>
<body>

<!-- 创建用户模态窗口 -->
<div class="modal fade" id="AddUserModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">用户注册</h4>
			</div>
			<div class="modal-body">
				<form id="createUserForm" class="form-horizontal" role="form">

					<div class="form-group has-feedback">
						<label for="username">用户名</label>
						<div class="input-group">
							<span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
							<input id="username" class="form-control" placeholder="请输入用户名" maxlength="20" type="text">
						</div>
						<span style="color:red;display: none;" class="tips"></span>
						<span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
						<span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<label for="loginName">登录账号</label>
						<div class="input-group">
							<span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
							<input id="loginName" class="form-control" maxlength="20" type="text">
						</div>
						<span style="color:red;display: none;" class="tips"></span>
						<span style="display: none;" class=" glyphicon glyphicon-remove form-control-feedback"></span>
						<span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<label for="password">密码</label>
						<div class="input-group">
							<span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
							<input id="password" class="form-control" placeholder="请输入密码" maxlength="20" type="password">
						</div>
						<span style="color:red;display: none;" class="tips"></span>
						<span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
						<span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<label for="passwordConfirm">确认密码</label>
						<div class="input-group">
							<span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
							<input id="passwordConfirm" class="form-control" placeholder="请再次输入密码" maxlength="20" type="password">
						</div>
						<span style="color:red;display: none;" class="tips"></span>
						<span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
						<span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<label for="email">邮箱</label>
						<div class="input-group">
							<span class="input-group-addon"><span class="glyphicon glyphicon-envelope"></span></span>
							<input id="email" class="form-control" placeholder="请输入邮箱"  type="text">
						</div>
						<span style="color:red;display: none;" class="tips"></span>
						<span style="display: none;" class="glyphicon glyphicon-remove form-control-feedback"></span>
						<span style="display: none;" class="glyphicon glyphicon-ok form-control-feedback"></span>
					</div>
					<div class="form-group">
						<input class="form-control btn btn-primary" id="saveUserBtn" value="立&nbsp;&nbsp;即&nbsp;&nbsp;注&nbsp;&nbsp;册" type="submit">
					</div>
					<div class="form-group">
						<input value="重置" id="reset" class="form-control btn btn-danger" type="reset">
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/login.jpg" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">图书管理系统 &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;LIBSYSTEM</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:620px;height:500px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>用户登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd">
							</c:if>
							 十天内免登录
						</label>
						<label>
							<input type="checkbox" id="ManagerLogin" >
							管理员
						</label>
						<label>
							<input type="checkbox" id="ReaderLogin">
							读者
						</label>
						<span id="msg" style="color: red"></span>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
						<button type="button" id="regBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">注册</button>
				</div>
					</div>
			</form>
		</div>
	</div>
</body>
</html>