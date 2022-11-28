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

		//当容器加载完成之后，对容器调用工具函数
		//$("input[name='mydate']").datetimepicker({
		$(".mydate").datetimepicker({
			language:'zh-CN', //语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose:true,//设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn:true,//设置是否显示"今天"按钮,默认是false
			clearBtn:true//设置是否显示"清空"按钮，默认是false
		});

		//当主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryBookByConditionForPage(1,10);
		//给"查询"按钮添加单击事件
		$("#queryBookBtn").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			//queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
			queryBookByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
		});
	});

	<!--条件查询-->
	function queryBookByConditionForPage(pageNo,pageSize) {
		//收集参数
		var bookid=$.trim($("#query-bookid").val());//图书编号
		var bookname=$.trim($("#query-bookname").val());//书名
		var author=$.trim($("#query-author").val());//作者
		var status=$("#query-status").val();//书籍位置
		var pageNo=1;
		var pageSize=10;
		//发送请求
		$.ajax({
			url:'workbench/lendbook/queryBookByConditionForPage.do',
			data:{
				bookid:bookid,
				bookname:bookname,
				author:author,
				status:status,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			dataType:'json',
			success:function (data) {
				//显示总条数
				//$("#totalRowsB").text(data.totalRows);
				//显示市场活动的列表
				//遍历readerList，拼接所有行数据
				var htmlStr="";
				console.log("返回来的data=="+data)
				console.log("返回来的data=="+data.bookList)
				console.log("返回来的data=="+data.totalRows)
				$.each(data.bookList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+obj.id+"</a></td>";
					htmlStr+="<td>"+obj.bookname+"</td>";
					htmlStr+="<td>"+obj.author+"</td>";
					htmlStr+="<td>"+obj.price+"</td>";
					htmlStr+="<td>"+obj.location+"</td>";
					htmlStr+="<td>"+obj.status+"</td>";
					htmlStr+="</tr>";
				});
				$("#tBody").html(htmlStr);
				//取消"全选"按钮
				$("#chckAll").prop("checked",false);
				//计算总页数
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}
				//对容器调用bs_pagination工具函数，显示翻页信息
				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页号,相当于pageNo

					rowsPerPage:pageSize,//每页显示条数,相当于pageSize
					totalRows:data.totalRows,//总条数
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks:5,//最多可以显示的卡片数

					showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//每次返回切换页号之后的pageNo和pageSize
					onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
						//js代码
						//alert(pageObj.currentPage);
						//alert(pageObj.rowsPerPage);
						//queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
						queryReaderByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}

</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>图书信息列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">图书编号</div>
				      <input class="form-control" type="text" id="query-bookid">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">图书名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">作者</div>
					  <input class="form-control" type="text" id="query-author" />
				    </div>
				  </div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">借阅状态</div>
							<input class="form-control" type="text" id="query-status">
						</div>
					</div>
					<button type="button" class="btn btn-default" id="queryBookBtn">查询</button>
				</form>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>图书编号</td>
							<td>图书名称</td>
							<td>作者</td>
							<td>价格</td>
							<td>书籍位置</td>
							<td>借阅状态</td>
						</tr>
					</thead>
					<tbody id="tBody"></tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
		</div>
		
	</div>
</body>
</html>