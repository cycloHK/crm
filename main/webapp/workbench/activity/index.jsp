<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


<script type="text/javascript">

	$(function(){

		
		$("#addBtn").click(function () {
			/*
				操作模态窗口的方式：
					需要操作模态窗口的jquery对象，调用modal方法，该方法传递参数， show:打开模态窗口， hide：隐藏模态窗口
			 */
			//alert(123);
			alert("123a");
			//时间选择器 .time为calss
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});


			//走后台 获取用户信息表
			$.ajax({
				url:"workbench/activity/getUserList.do",
				data:{
					//查用户信息表不需要传参
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					var html = "<option></option>";
					//遍历每个n 就是每个User对象
					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					//向页面添加数据
					$("#create-owner").html(html);


					//让当前登录的用户 设置为下拉列表中默认选项
					//取得用户id El 表达式（在jsp文件夹中 需要加在字符串中）
					var id = "${user.id}";
					$("#create-owner").val(id);

					//展现模态窗口
					$("#createActivityModal").modal("show");

				}
			})
		})

		//为保存按钮绑定事件
		$("#savaBtn").click(function () {
			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					"owner":$.trim($("#create-owner").val()),
					"name":$.trim($("#create-name").val()),
					"startDate":$.trim($("#create-startDate").val()),
					"endDate":$.trim($("#create-endDate").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-description").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
             		if(data.success){
             			//添加成功
						//刷新市场活动信息列表 局部刷新
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						//清空模态窗口的数据
						/*
						jquery 中没有reset方法 需要转化为dom对象
						jquery对象(下标)           补充：dom-》jQuery $(dom)
						* */
						$("#activityAddForm")[0].reset();
						//关闭添加操作窗口
						$("#createActivityModal").modal("hide");
					}else {
					}

				}
			})


		})
		pageList(1,2);
		//页面加载完毕后触发一个方法
		$("#searchBtn").click(function () {
			/*点击查询按钮的时候保存搜索框的信息*/
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);
		})

		//为全选的复选框绑定事件
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);  //本页中名字为xz的选择器都变为check状态
		})
          //d动态生成的元素 需要用on方法来触发事件
		 //   语法: $(需要绑定元素的有效外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			//alert(123);
			$("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
		})


		$("#deleteBtn").click(function (){
			//找到复选框中所有挑√的复选框的jquery对象
			var $xz = $("input[name=xz]:checked");
			if ($xz.length==0){
				alert("请选择要删除的记录")
			}else{
				if(confirm("确定要删除所选的记录吗？")){
					//拼接参数
					var param = "";
					//将$xz中的每一个dom对象遍历出来，取其value值相当于取得了需要删除记录的id
					for (var i=0;i<$xz.length;i++){
						param += "id="+ $($xz[i]).val();
						if (i<$xz.length-1){
							param += "&";
						}
					}
					$.ajax({
						url:"workbench/activity/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.success){
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除市场活动失败")
							}
						}
					})
				}

			}
		})

		//为修改操作绑定事件，打开修改操作的模态窗口
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length==0){
				alert("请选择需要修改的记录")
			}else if ($xz.length>1){
				alert("对不起，一次只能同时修改一个记录，请重新选择")
			}else if ($xz.length==1){
				var id = $xz.val();
				$.ajax({
					url:"workbench/activity/getUserListAndActivity.do",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data){

						//处理所有者下拉框
						var html = "<option></option>"
						$.each(data.uList,function (i,n){
							html += "<option value='"+n.id+"'>"+n.name+"</option>"
						})
						$("#edit-owner").html(html);
						//处理单条activity
						$("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
						$("#edit-owner").val(data.a.owner);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);

						//所有的值都填写好之后，打开修改操作的模态窗口
						$("#editActivityModal").modal("show");
					}
				})
			}
		})
		//更新操作绑定事件,执行市场活动的修改操作
		$("#updateBtn").click(function () {
			/*
					在原表进行修改
			* */
			$.ajax({
				url:"workbench/activity/update.do",
				data:{
					"id":$.trim($("#edit-id").val()),
					"owner":$.trim($("#edit-owner").val()),
					"name":$.trim($("#edit-name").val()),
					"startDate":$.trim($("#edit-startDate").val()),
					"endDate":$.trim($("#edit-endDate").val()),
					"cost":$.trim($("#edit-cost").val()),
					"description":$.trim($("#edit-description").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						//修改成功
						//刷新市场活动信息列表 局部刷新 回到维持当前页 维持每页展示的记录数
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                         //关闭修改操作的模态窗口
						$("#editActivityModal").modal("hide");
					}else {
						alert("修改市场活动失败")
					}

				}
			})
		})


	});
	/*pageNo 页码(第几页) pageSize 每页记录数*/
	function pageList(pageNo,pageSize) {
		$("#qx").prop("checked",false);
  			//查询前 将隐藏域中的信息取出来 赋予到搜索框中
	   $("#search-name").val($.trim($("#hidden-name").val()));
	   $("#search-owner").val($.trim($("#hidden-owner").val()));
	   $("#search-startDate").val($.trim($("#hidden-startDate").val()));
	   $("#search-endDate").val($.trim($("#hidden-endDate").val()));
			$.ajax({
				url:"workbench/activity/pageList.do",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					//选填
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"startDate":$.trim($("#search-startDate").val()),
					"endDate":$.trim($("#search-endDate").val())

				},
				type:"get",
				dataType:"json",
				success:function (data) {
					//data {"total":122,"dataList":[{市场活动1},{2}]}
					var html = "";
					$.each(data.dataList,function (i,n) {
					html +=	'<tr class="active">';
					html +=	'<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					                                                              //单引号里面有单引号 要转义
					html +=	'<td><a style="text-decoration: none; cursor: pointer;" ' +
							'onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+n.name+'</a></td>';
					html +=	'<td>'+n.owner+'</td>';
					html +=	'<td>'+n.startDate+'</td>';
					html +=	'<td>'+n.endDate+'</td>';
					html +=	'</tr>';

					})
					$("#activityBody").html(html);

					//计算总页数
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                    //数据处理完毕 执行分页展示
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 5, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}
			})




	}
	
</script>
</head>
<body>

		<input type="hidden" id="hidden-name"/>
		<input type="hidden" id="hidden-owner"/>
		<input type="hidden" id="hidden-startDate"/>
		<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>--%>
								  <%--<option>lisi</option>--%>
								  <%--<option>wangwu</option>--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="savaBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">

								<textarea class="form-control" rows="3" id="edit-describtion">

								</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>