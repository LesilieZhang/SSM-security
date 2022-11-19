<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/css/style.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<!--
<img src="image/home.png" style="position: relative;top: -10px; left: -10px;" height="500" width="500"/>
-->

<div class="container">
	<div class="row">
		<div class="col-sm">
			公告栏
		</div>
		<div class="col-sm">
			<img src="image/home2.jpg" style="position: relative;top: -10px; left: -10px;width: 100%;height: auto " />
		</div>
	</div>
</div>

</body>
</html>