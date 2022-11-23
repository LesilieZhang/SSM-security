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
		$("#addReaderBtn").click(function () {
			//初始化工作
			//重置表单
			$("#createReaderForm").get(0).reset();
			//弹出创建市场活动的模态窗口
			$("#AddReaderModal").modal("show");
		});
		
		//给"保存"按钮添加单击事件
		$("#saveReaderBtn").click(function () {
			//收集参数
			var createBy=$("#create-createBy").val();//创建者
			var name=$.trim($("#create-readerName").val());//读者姓名
			var sex=$.trim($("#create-sex").val());//读者性别
			var idNumber =$.trim($("#create-idNum").val());//读者学号
			var phone=$.trim($("#create-phone").val());//读者手机号
			var deptname=$.trim($("#create-dept").val());//读者所在的系
			var classname=$("#create-class").val();//读者所在班级
			//表单验证
			if(createBy==""){
				alert("操作人不能为空");
				return;
			}
			if(name==""){
				alert("读者姓名不能为空");
				return;
			}
		    if(idNumber.length!=10){
				alert("请输入十位学号！")
				return;
			}
			var myreg=/^1[3-9]\d{9}$/;
			if(!myreg.test(phone)){
					alert("请输入正确手机号！")
					return;
				}
			if(deptname==""){
				alert("请输入所在系！")
				return;
			}
			if(classname==""){
				alert("请输入所在班级！")
				return;
			}
			//发送请求
			$.ajax({
				url:'workbench/reader/saveReader.do',
				data:{
					creatBy:createBy,
					name:name,
					sex:sex,
					idNumber:idNumber,
					phone:phone,
					deptname:deptname,
					classname:classname
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#AddReaderModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变
					//	queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						queryReaderByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#AddReaderModal").modal("show");//可以不写。
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
		queryReaderByConditionForPage(1,10);

		//给"查询"按钮添加单击事件
		$("#queryReaderBtn").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			//queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));

			queryReaderByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
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
		$("#deleteReaderBtn").click(function () {
			//收集参数
			//获取列表中所有被选中的checkbox
			var chekkedIds=$("#tBody input[type='checkbox']:checked");
			if(chekkedIds.size()==0){
				alert("请选择要删除的市场活动");
				return;
			}

			if(window.confirm("确定删除吗？")){
				var ids="";
				$.each(chekkedIds,function () {//id=xxxx&id=xxx&.....&id=xxx&
					ids+="id="+this.value+"&";
				});
				ids=ids.substr(0,ids.length-1);//id=xxxx&id=xxx&.....&id=xxx

				//发送请求
				$.ajax({
					url:'workbench/reader/deleteReaderIds.do',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.code=="1"){
							//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
							queryReaderByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							//提示信息
							alert(data.message);
						}
					}
				});
			}
		});

		//给"修改"按钮添加单击事件
		$("#editReaderBtn").click(function () {
			//收集参数:id
			//获取列表中被选中的checkbox
			var chkedIds=$("#tBody input[type='checkbox']:checked");//被选中的checkbox
			if(chkedIds.size()==0){
				alert("请选择要修改的读者");
				return;
			}
			if(chkedIds.size()>1){
				alert("每次只能修改一条读者信息");
				return;
			}
			var id=chkedIds[0].value; //获取value值
			//发送请求
			$.ajax({
				url:'workbench/reader/queryReaderById.do',
				data:{
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//把市场活动的信息显示在修改的模态窗口上
					$("#edit-createBy").val(data.creatBy);
					$("#edit-readerName").val(data.name);
					$("#edit-sex").val(data.sex);
					$("#edit-phone").val(data.phone);
					$("#edit-deptname").val(data.deptname);
					$("#edit-classname").val(data.classname);
					$("#edit-idNumber").val(data.idNumber);
					$("#edit-id").val(data.id);
					//弹出模态窗口
					$("#editReaderModal").modal("show");
				}
			});
		});

		//给"查看详情"按钮添加单击事件
		$("#checkDetialBtn").click(function () {
			//收集参数:id
			//获取列表中被选中的checkbox
			var chkedIds=$("#tBody input[type='checkbox']:checked");//被选中的checkbox
			console.log("选中的id==="+chkedIds)
			if(chkedIds.size()==0){
				alert("请选择要查看的读者");
				return;
			}
			if(chkedIds.size()>1){
				alert("每次只能查看一名读者信息");
				return;
			}
			var id=chkedIds[0].value; //获取value值
			//发送请求
			$.ajax({
				url:'workbench/reader/queryReaderById.do',
				data:{
					id:id,
					pageNo:1,
					pageSize:10
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//把市场活动的信息显示在修改的模态窗口上
					console.log("返回的学号是=="+data.idNumber)
					var studentId=data.idNumber;
					//弹出模态窗口
					$("#DetailModal").modal("show");
					queryBookDetailByStudentId(studentId,1,10);
				}
			});
		});

		//给"更新"按钮添加单击事件
		$("#saveEditReaderBtn").click(function () {
			//收集参数
			var id=$("#edit-id").val();
			var createBy=$("#edit-createBy").val();
			var readerName=$.trim($("#edit-readerName").val());
			var sex=$("#edit-sex").val();
			var phone=$("#edit-phone").val();
			var deptname=$.trim($("#edit-deptname").val());
			var classname=$.trim($("#edit-classname").val());
			var idNumber=$.trim($("#edit-idNumber").val());
			//表单验证(作业)
			//发送请求
			$.ajax({
				url:'workbench/reader/saveEditReader.do',
				data:{
					id:id,
					creatBy:createBy,
					name:readerName,
					sex:sex,
					phone:phone,
					deptname:deptname,
					classname:classname,
					idNumber:idNumber
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#editReaderModal").modal("hide");
						//刷新市场活动列表,保持页号和每页显示条数都不变
						queryReaderByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#editReaderModal").modal("show");
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
	function queryReaderByConditionForPage(pageNo,pageSize) {
		//收集参数
		var name=$.trim($("#query-name").val());//读者姓名
		var idNum=$.trim($("#query-id").val());//读者学号
		var dept=$.trim($("#query-deptname").val());//读者所在的系
		var className=$("#query-classname").val();//读者所在班级
		var pageNo=1;
		var pageSize=10;
		//发送请求
		$.ajax({
			url:'workbench/reader/queryReaderByConditionForPage.do',
			data:{
				name:name,
				idNumber:idNum,
				deptname:dept,
				classname:className,
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
				console.log("返回来的data=="+data.readerList)
				console.log("返回来的data=="+data.totalRows)
				$.each(data.readerList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.sex+"</td>";
					htmlStr+="<td>"+obj.idNumber+"</td>";
					htmlStr+="<td>"+obj.phone+"</td>";
					htmlStr+="<td>"+obj.deptname+"</td>";
					htmlStr+="<td>"+obj.classname+"</td>";
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

	<!--根据读者学号查询-->
	function queryBookDetailByStudentId(id,pageNo,pageSize){
		//收集参数
		var id=id;
		var pageNo=pageNo;
		var pageSize=pageSize;
		//发送请求
		$.ajax({
			url: 'workbench/reader/queryBookDetailByStudentIdForPage.do',
			data: {
				id: id
			},
			type: 'post',
			dataType: 'json',
			success: function (data) {
				//显示总条数
				//$("#totalRowsB").text(data.totalRows);
				//显示市场活动的列表
				//遍历readerList，拼接所有行数据
				var htmlStr = "";
				console.log("返回来的data==" + data.totalRows)
				$.each(data.bookList, function (index, obj) {
					console.log("id" + obj.id);
					console.log("name" + obj.bookname);
					console.log("lendtime"+obj.lendTime);
					htmlStr += "<td>" + obj.id +"</td>";
					htmlStr += "<td>" + obj.bookname + "</td>";
					htmlStr += "<td>" + obj.lendtime + "</td>";
					htmlStr += "<td>" + obj.late + "</td>";
					htmlStr += "</tr>";
				});
				$("#tBody1").html(htmlStr);
			}
		});
	}


</script>
</head>
<body>

	<!-- 创建读者信息的模态窗口 -->
	<div class="modal fade" id="AddReaderModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">添加读者</h4>
				</div>
				<div class="modal-body">

					<!--创建读者表单-->
					<form id="createReaderForm" class="form-horizontal" role="form">
						<div class="form-group">
							<!--添加操作人-->
							<label for="create-createBy" class="col-sm-2 control-label">操作人<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-createBy">
								  <c:forEach items="${userList}" var="u">
									   <option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
							<!--添加读者姓名-->
                            <label for="create-readerName" class="col-sm-2 control-label">读者姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-readerName">
                            </div>
						</div>
						<!--添加读者性别-->
                        <div class="form-group">
							<label for="create-sex" class="col-sm-2 control-label">性别</label>
							<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-sex">
								<option value="1">男</option>
								<option value="0">女</option>
							</select>
							</div>
							<!--学号-->
							<label for="create-idNum" class="col-sm-2 control-label">学号</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-idNum">
							</div>
                        </div>
						<!--联系方式-->
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">手机号</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<!--所在系-->
							<label for="create-dept" class="col-sm-2 control-label">系别</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-dept">
							</div>
						</div>
						<!--所在班级-->
						<div class="form-group">
							<label for="create-class" class="col-sm-2 control-label">班级</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control  match-rotation-input"
									   maxlength="3"
									   onkeyup="value=value.replace(/[^\d]/g,'')"
								onblur="value=value.replace(/[^\d]/g,'')"
								ng-model="schedule.round"
								placeholder="请输入数字" id="create-class">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveReaderBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editReaderModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改读者信息</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-createBy" class="col-sm-2 control-label">操作人<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-createBy">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-readerName" class="col-sm-2 control-label">读者姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-readerName" value="张三">
                            </div>
						</div>
						<div class="form-group">
							<label for="edit-sex" class="col-sm-2 control-label">性别</label>
							<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-sex">
									<option value="1">男</option>
									<option value="0">女</option>
							</select>
						</div>
						<div class="form-group">
							<label for="edit-idNumber" class="col-sm-2 control-label">学号</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-idNumber" value="2018005534">
							</div>
						</div>
							<div class="form-group">
								<label for="edit-phone" class="col-sm-2 control-label">手机号</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-phone" value="18650825096">
								</div>
							</div>
						<div class="form-group">
							<label for="edit-deptname" class="col-sm-2 control-label">系别</label>
							<div class="col-sm-10" style="width: 81%;">
								<input type="text" class="form-control" id="edit-deptname" value="计算机系">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-classname" class="col-sm-2 control-label">班级</label>
							<div class="col-sm-10" style="width: 81%;">
								<input type="text" class="form-control" id="edit-classname" value="1班">
							</div>
						</div>
							</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditReaderBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查看读者详细信息的模态窗口 -->
	<div class="modal fade" id="DetailModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalDetail">查看读者的借阅信息</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative;top: 10px;">
						<table class="table table-hover">
							<thead>
							<tr style="color: #B3B3B3;">
								<td>图书编号</td>
								<td>图书名称</td>
								<td>借书日期</td>
								<td>是否逾期</td>
							</tr>
							</thead>
							<tbody id="tBody1"></tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>读者信息列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">学号</div>
				      <input class="form-control" type="text" id="query-id">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">系别</div>
					  <input class="form-control" type="text" id="query-deptname" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">班级</div>
					  <input class="form-control" type="text" id="query-classname">
				    </div>
				  </div>
					<button type="button" class="btn btn-default" id="queryReaderBtn">查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addReaderBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editReaderBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteReaderBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
					<button type="button" class="btn btn-danger" id="checkDetialBtn"><span class="glyphicon glyphicon-zoom-in"></span> 查看详情</button>
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
							<td>姓名</td>
							<td>姓别</td>
							<td>学号</td>
							<td>手机号</td>
							<td>系别</td>
							<td>班级</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>
					</tbody>
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