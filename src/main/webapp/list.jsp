<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- 
	Web路径：
		不以/ 开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
		以/ 开始的相对路径，找资源，以服务器的路径为基准(http://loaclhost:8080)，需加上项目名
				http://localhost:8080/SSM_CRUD
 -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-3.2.1.min.js"></script>
<!-- 引入样式 -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工添加模态框 -->
	<div class="modal fade" id="addEmpModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">添加员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">EmpName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="EmpName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">Email</label>
			    <div class="col-sm-10">
			      <input type="text" name="Email" class="form-control" id="Email_add_input" placeholder="xxxxx@xxx.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			        <label class="radio-inline">
					  <input type="radio" name="gender" id="gender_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender_add_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">department</label>
			    <div class="col-sm-6">
			        <select class="form-control" name="dId">
					</select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	
<!-- 员工修改模态框 -->
	<div class="modal fade" id="UpdateEmpModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">修改员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">EmpName</label>
			    <div class="col-sm-10">
			       <p class="form-control-static" id="EmpName_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">Email</label>
			    <div class="col-sm-10">
			      <input type="text" name="Email" class="form-control" id="Email_update_input" placeholder="xxxxx@xxx.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			        <label class="radio-inline">
					  <input type="radio" name="gender" id="gender_update_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender_update_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">department</label>
			    <div class="col-sm-6">
			        <select class="form-control" name="dId">
					</select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>



	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>SSM_CRUD</h1>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-10"></div>
			<div class="col-md-2">
				<button class="btn btn-primary" id="add_Emp_model_btn">新增</button>
				<button class="btn btn-danger" id="del_Emp_all_btn">删除</button>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>EmpName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>action</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
				</table>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-6" id="page_info_area"></div>
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
	</div>


	<script type="text/javascript">
		$(function(){
			to_page(1);
		});
		
		//总记录数
		var total;
		//当前页码
		var currentPage;
		
		//跳转页码
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"get",
				success:function(result){
					//console.log(result);
					build_emps_table(result);
					//解析显示分页数据
					build_page_info(result);
					//解析显示分页条数据
					build_page_nav(result);
				}
			});
		};
		
		//解析显示
		function build_emps_table(result){
			
			$("#emps_table tbody").empty();
			
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item){
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>")
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var gender = item.gender=="M"?"男":"女";
				var genderTd = $("<td></td>").append(gender);
				var deptTd = $("<td></td>").append(item.dept.deptName);
				var emailTd = $("<td></td>").append(item.email);
				/* <button class="btn btn-primary btn-sm">
					<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 修改
				</button>
				<button class="btn btn-danger btn-sm">
					<span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除
				</button> */
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").
								append("<span></span>").addClass("glyphicon glyphicon-pencil").append(" 修改");
				//给编辑按钮添加属性，来判断id
				editBtn.attr("edit_id", item.empId);
				
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").
								append("<span></span>").addClass("glyphicon glyphicon-trash").append(" 修改");
				//给删除按钮添加属性，来判断id
				delBtn.attr("del_id", item.empId);
				
				var BtnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				//append 方法执行后返回的还是原来的元素
				$("<tr></tr>").append(checkBoxTd)
							.append(empIdTd)
							.append(empNameTd)
							.append(genderTd)
							.append(emailTd)
							.append(deptTd)
							.append(BtnTd)
							.appendTo("#emps_table tbody");
			});
		};
		
		//解析显示分页信息
		function build_page_info(result){
			$("#page_info_area").empty();
			
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"
					+result.extend.pageInfo.pages+"页, 总"+result.extend.pageInfo.total+"条记录");
			
			total = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		};
		
		//解析显示分页条数据
		function build_page_nav(result){
			$("#page_nav_area").empty();
			
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href", "#"));
			//如果没有上一页(当前页数为首页), 则使上一页和首页标签失效，并不添加点击跳转事件
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else{
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum -1);
				});
			}
			
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href", "#"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("尾页").attr("href", "#"));
			//如果没有下一页(当前页数为尾页), 则使下一页和尾页标签失效，并不添加点击跳转事件
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				//lastPageLi.addClass("disabled");
			} else{
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum +1);
				});
			}
			ul.append(firstPageLi).append(prePageLi);
			$.each(result.extend.pageInfo.navigatepageNums, function(index, item){
				var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href", "#"));
				ul.append(numLi);
				//如果为当前页数，则显示特殊样式, 否则，添加点击跳转事件
				if(item == result.extend.pageInfo.pageNum){
					numLi.addClass("active");
				}else{
					numLi.click(function(){
						to_page(item);
					});
				}
			});
			ul.append(nextPageLi).append(lastPageLi);
			
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
			
		};
		
		
		//点击新增，弹出员工添加模态框
		$("#add_Emp_model_btn").click(function(){
			//完全清空表单(样式，标识..), jQuery没有reset方法，需要转换成Dom对象
			reset_form("#addEmpModel form");
			//获取部门信息
			getDepts("#addEmpModel select");
			//点击新增，弹出员工添加模态框
			$('#addEmpModel').modal({
				backdrop:"static"
			});
		});
		
		//完全清除表单样式
		function reset_form(ele){
			$(ele)[0].reset();
			$(ele).find("*").removeClass("has-success has-error");
			$(ele).find(".help-block").text("");
		}
		
		//获取部门信息
		function getDepts(ele){
			$(ele).empty();
			$.ajax({
				url:"depts",				
				type:"GET",
				success:function(result){
					/* console.log(result); */
					$.each(result.extend.depts, function(){
						//显示部门信息到下拉列表
						var option = $("<option></option>").append(this.deptName).attr("value", this.deptId);
						option.appendTo(ele);
					});
				}
			});
		};
		
		//点击保存，保存新增的员工数据
		$("#emp_save_btn").click(function(){
			//对用户名是否重复进行校验
			if($(this).attr("ajax-va")=="error"){
				return false;
			}
			//对表单数据进行校验
			if(!validate_add_form()){
				return false;
			}
			//$("#addEmpModel from").serialize() 将表单信息序列化，用于ajax传参
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#addEmpModel form").serialize(),
				success:function(result){
					//alert(result.msg);
					if(result.code==100){
						//关闭模态框
						$('#addEmpModel').modal('hide');
						//跳转到最后一页
						//思想：因为分页插件设置了参数合理化属性，当pageNum>=pages时,会跳转到最后一页，
						//所以只需传入一个足够大的值就可以了
						to_page(total);
					}else{
						//console.log(result);
						//有什么错误信息，就显示什么错误信息
						if(result.extend.errorFields.email != undefined){
							show_validate_msg("#Email_add_input", "error", result.extend.errorFields.email);
						}
						if(result.extend.errorFields.empName != undefined){
							show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
						}
					}
				}
			});
		});
		
		//数据校验
		function validate_add_form(){
			//使用正则表达式，对数据进行校验
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,12}$)|(^[\u2E80-\u9FFF]{2,5})/
			if(!regName.test(empName)){
				//alert("请输入2-5位中文字符或6-12位英文字符");
				show_validate_msg("#empName_add_input", "error", "请输入2-5位中文字符或输入6-12位英文字符和数字");
				return false;
			}else {
				show_validate_msg("#empName_add_input", "success", "");
			}
			var empEmail = $("#Email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(empEmail)){
				//alert("邮箱格式不正确");
				show_validate_msg("#Email_add_input", "error", "邮箱格式不正确");
				return false;
			} else{
				show_validate_msg("#Email_add_input", "success", "");
			}
			return true;
		}
		
		//显示校验结果的提示信息
		function show_validate_msg(ele, status, msg){
			//清除当前元素的效验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if("success"==status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error"==status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		//检验用户名是否可用
		$("#empName_add_input").change(function(){
			var empName = this.value;
			$.ajax({
				url:"checkName",
				type:"POST",
				data:"empName="+empName,
				success:function(result){
					if(result.code==100){
						show_validate_msg("#empName_add_input", "success", "用户名可用");
						//给保存按钮添加一个自定义的属性，用来判断验证信息
						$("#emp_save_btn").attr("ajax-va", "success");
					}else{
						show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va", "error");
					}
				}
			});
		});
		
		
		//因为是创建按钮之后添加的点击事件，所以绑定不上
		//1. 可以在创建的时候绑定 		2. 绑定点击事件.live()
		//jquery 新版没有live，使用on代替
		//点击编辑按钮，修改员工
		$(document).on("click", ".edit_btn", function(){
			//获取部门信息
			getDepts("#UpdateEmpModel select");
			getEmp($(this).attr("edit_id"));
			//将编辑按钮判断id的属性传递给更新按钮
			$("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));
			//显示修改员工模态框
			$('#UpdateEmpModel').modal({
				backdrop:"static"
			});
		});
		
		function getEmp(id){
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type:"GET",
				success:function(result){
					//console.log(result);
					var empData = result.extend.emp;
					EmpName_update_static
					$("#EmpName_update_static").text(empData.empName);
					$("#Email_update_input").val(empData.email);
					$("#UpdateEmpModel input[name=gender]").val([empData.gender]);
					$("#UpdateEmpModel select").val([empData.dId]); 
				}
			});
		}
		
		//点击更新按钮，更新员工数据
		$("#emp_update_btn").click(function(){
			//验证邮箱
			var empEmail = $("#Email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(empEmail)){
				//alert("邮箱格式不正确");
				show_validate_msg("#Email_update_input", "error", "邮箱格式不正确");
				return false;
			} else{
				show_validate_msg("#Email_update_input", "success", "");
			}
			
			//发送更新请求
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit_id"),
				type:"PUT",
				data:$("#UpdateEmpModel form").serialize(),
				success:function(result){
					//关闭模态框
					$("#UpdateEmpModel").modal("hide");
					//重新跳转至本页
					to_page(currentPage);
				}
			});
		});
		
		//点击删除
		$(document).on("click", ".delete_btn", function(){
			//获取empName， 根据该按钮的父节点tr 下的第二个td 的文本
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var id = $(this).attr("del_id");
			//弹出确认框，返回boolean
			if(confirm("确认删除【"+empName+"】吗？")){
				$.ajax({
					url:"${APP_PATH}/emp/"+id,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
			
		});
		
		//点击全选按钮
		$("#check_all").click(function(){
			 //attr获取checked是undefined;
			 //这是dom原生的属性； attr获取自定义属性的值
			 //prop修改和读取原生属性的值
			 $(".check_item").prop("checked", $(this).prop("checked"));
		});
		
		$(document).on("click", ".check_item", function(){
			//判断选中的个数和checkbox的数目是否一致
			var flag = $(".check_item").length==$(".check_item:checked").length;
			//如果一致，全选框状态为全选中，否则不选中
			$("#check_all").prop("checked", flag);
		});
		
		//批量删除
		$("#del_Emp_all_btn").click(function(){
			var empNames = "";
			var del_idstr = "";
			
			$.each($(".check_item:checked"), function(){
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";				
			});
			
			//去除多余字符','  '-'
			empNames = empNames.substring(0, empNames.length-1);
			del_idstr = del_idstr.substring(0, del_idstr.length-1);
			if(confirm("确认删除【"+empNames+"】吗")){
				$.ajax({
					url:"${APP_PATH}/emp/"+del_idstr,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
	</script>
</body>
</html>