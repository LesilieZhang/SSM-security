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
		//给"创建读者"按钮添加单击事件
		$("#addBookBtn").click(function () {
			//初始化工作
			//重置表单
			$("#createBookForm").get(0).reset();
			//弹出创建市场活动的模态窗口
			$("#AddBookModal").modal("show");
		});
		
		//给"保存"按钮添加单击事件
		$("#saveBookBtn").click(function () {
			//收集参数
			var bookid=$.trim($("#create-bookid").val());//图书编号
			var bookname=$.trim($("#create-bookName").val());//书名
			var author=$.trim($("#create-author").val());//作者
			var price =$.trim($("#create-price").val());//价格
			var location=$.trim($("#create-location").val());//书籍位置
			var status=$("#create-status").val();//是否可借
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
			if(author==""){
				alert("作者不能为空");
				return;
			}
			if(location==""){
				alert("位置不能为空");
				return;
			}
			if(status==""){
				alert("借阅状态不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:'workbench/book/saveBook.do',
				data:{
					id:bookid,
					bookname:bookname,
					author:author,
					price:price,
					location:location,
					status:status
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						window.confirm("添加成功！");
						$("#AddBookModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变
					//	queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						queryBookByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#AddBookModal").modal("show");//可以不写。
					}
				}
			});
		});
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

		//给"全选"按钮添加单击事件
		$("#chckAll").click(function () {
			//如果"全选"按钮是选中状态，则列表中所有checkbox都选中
			//this：代表当前正在发生事件的对象
			$("#tBody input[type='checkbox']").prop("checked",this.checked);
		});
		$("#tBody").on("click","input[type='checkbox']",function () {
			//如果列表中的所有checkbox都选中，则"全选"按钮也选中
			if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
				$("#chckAll").prop("checked",true);
			}else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
				$("#chckAll").prop("checked",false);
			}
		});

		//给"删除"按钮添加单击事件
		$("#deleteBookBtn").click(function () {
			//收集参数
			//获取列表中所有被选中的checkbox
			var chekkedIds=$("#tBody input[type='checkbox']:checked");
			if(chekkedIds.size()==0){
				alert("请选择要删除的图书信息");
				return;
			}
			if(window.confirm("确定删除吗？")){
				var ids="";
				$.each(chekkedIds,function () {//id=xxxx&id=xxx&.....&id=xxx&
					ids+="id="+this.value+"&";
				});
				ids=ids.substr(0,ids.length-1);//id=xxxx&id=xxx&.....&id=xxx
				console.log("删除id==="+id);
				//发送请求
				$.ajax({
					url:'workbench/Book/deleteBookIds.do',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.code=="1"){
							//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
							queryBookByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							//提示信息
							alert(data.message);
						}
					}
				});
			}
		});

		//给"修改"按钮添加单击事件
		$("#editBookBtn").click(function () {
			//收集参数:id
			//获取列表中被选中的checkbox
			var chkedIds=$("#tBody input[type='checkbox']:checked");//被选中的checkbox
			if(chkedIds.size()==0){
				alert("请选择要修改的图书");
				return;
			}
			if(chkedIds.size()>1){
				alert("每次只能修改一条图书信息");
				return;
			}
			var id=chkedIds[0].value; //获取value值
			console.log("选择的id=="+id)
			//发送请求
			$.ajax({
				url:'workbench/book/queryBookById.do',
				data:{
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//把图书的信息显示在修改的模态窗口上
					$("#edit-createBy").val(data.creatBy);
					$("#edit-bookName").val(data.bookname);
					$("#edit-author").val(data.author);
					$("#edit-price").val(data.price);
					$("#edit-location").val(data.location);
					$("#edit-status").val(data.status);
					$("#edit-id").val(data.id);
					//弹出模态窗口
					$("#editBookModal").modal("show");
				}
			});
		});
		//给"更新"按钮添加单击事件
		$("#saveEditBookBtn").click(function () {
			//收集参数
			var id=$("#edit-id").val();
			var bookName=$("#edit-bookName").val();
			var author=$("#edit-author").val();
			var price=$("#edit-price").val();
			var location=$.trim($("#edit-location").val());
			var status=$.trim($("#edit-status").val());
			//表单验证(作业)
			//发送请求
			$.ajax({
				url:'workbench/books/saveEditBook.do',
				data:{
					id:id,
					bookname:bookName,
					author:author,
					price:price,
					location:location,
					status:status
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						window.confirm("修改成功！");
						$("#editBookModal").modal("hide");
						//刷新市场活动列表,保持页号和每页显示条数都不变
						queryBookByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#editBookModal").modal("show");
					}
				}
			});
		});
		//给"批量导出"按钮添加单击事件
		$("#exportActivityAllBtn").click(function () {
			//发送同步请求
			window.location.href="workbench/activity/exportAllActivitys.do";
		});
		//给“选择导出”按钮添加单击事件
		$("#exportActivityChooseByIdBtn").click(function () {
			var checkedIds = $("#tBody input:checked")//父标签tBody下的被选中的input
			if(checkedIds.size()==0){
				alert("请选择要导出的活动");
				return;
			}
			if(window.confirm("您确定要导出这"+checkedIds.size()+"条活动吗？")){
				var ids=[];
				$.each(checkedIds,function () {
					ids.push(this.value);//this.value就是被选中的id值
				});
				window.location.href="exportChooseActivitysByIds.do?ids="+ids;//注意传参格式
			}
		});


		//给"导入"按钮添加单击事件
		$("#importActivityBtn").click(function () {
			//收集参数
			var activityFileName=$("#activityFile").val();
			var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();//xls,XLS,Xls,xLs,....
			if(suffix!="xls"){
				alert("只支持xls文件");
				return;
			}
			var activityFile=$("#activityFile")[0].files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件大小不超过5MB");
				return;
			}

			//FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
			//FormData最大的优势是不但能提交文本数据，还能提交二进制数据
			var formData=new FormData();
			formData.append("activityFile",activityFile);
			formData.append("userName","张三");

			//发送请求
			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
				contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//提示成功导入记录条数
						alert("成功导入"+data.retData+"条记录");
						//关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});
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
			url:'workbench/book/queryBookByConditionForPage.do',
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
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
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

	<!-- 创建图书信息的模态窗口 -->
	<div class="modal fade" id="AddBookModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">添加图书</h4>
				</div>
				<div class="modal-body">
					<!--创建读者表单-->
					<form id="createBookForm" class="form-horizontal" role="form">
						<div class="form-group">
							<!--添加图书编号-->
							<label for="create-bookid" class="col-sm-2 control-label">图书编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-bookid">
							</div>
							<!--添加图书姓名-->
                            <label for="create-bookName" class="col-sm-2 control-label">图书名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-bookName">
                            </div>
						</div>
						<!--添加图书作者-->
                        <div class="form-group">
							<label for="create-author" class="col-sm-2 control-label">作者</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-author">
							</div>
							<!--价格-->
							<label for="create-price" class="col-sm-2 control-label">价格</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-price">
							</div>
                        </div>
						<!--位置-->
						<div class="form-group">
							<label for="create-location" class="col-sm-2 control-label">书籍位置</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-location">
							</div>
							<!--状态-->
							<label for="create-status" class="col-sm-2 control-label">借阅状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option value="1">可借</option>
									<option value="0">已借出</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBookBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改图书信息的模态窗口 -->
	<div class="modal fade" id="editBookModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改图书信息</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<!--添加图书姓名-->
							<label for="edit-bookName" class="col-sm-2 control-label">图书名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-bookName">
							</div>
						</div>
						<!--添加图书作者-->
						<div class="form-group">
							<label for="edit-author" class="col-sm-2 control-label">作者</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-author">
							</div>
							<!--价格-->
							<label for="edit-price" class="col-sm-2 control-label">价格</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-price">
							</div>
						</div>
						<!--位置-->
						<div class="form-group">
							<label for="edit-location" class="col-sm-2 control-label">书籍位置</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-location">
							</div>
							<!--状态-->
							<label for="edit-status" class="col-sm-2 control-label">借阅状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<option value="1">可借</option>
									<option value="0">已借出</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditBookBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
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
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBookBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBookBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBookBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="chckAll"/></td>
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

			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>