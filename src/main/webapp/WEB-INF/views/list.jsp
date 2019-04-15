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

	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>SSM_CRUD</h1>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-10"></div>
			<div class="col-md-2">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>#</th>
						<th>EmpName</th>
						<th>gender</th>
						<th>email</th>
						<th>deptName</th>
						<th>action</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
						<tr>
							<td>${emp.empId }</td>
							<td>${emp.empName }</td>
							<td>${emp.gender=="M"?"男":"女" }</td>
							<td>${emp.email }</td>
							<td>${emp.dept.deptName }</td>
							<td>
								<button class="btn btn-primary btn-sm">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 修改
								</button>
								<button class="btn btn-danger btn-sm">
									<span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除
								</button>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-6">
				当前${pageInfo.pageNum }页，总${pageInfo.pages }页，总${pageInfo.total }条记录
			</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				    <ul class="pagination">
				    	<li><a href="${APP_PATH }/emps?pn=1">首页</a></li>
				    	<c:if test="${pageInfo.hasPreviousPage }">
				    		<li>
				      		<a href="${pageInfo.pageNum-1 }" aria-label="Previous">
				        		<span aria-hidden="true">&laquo;</span>
				      		</a>
				    		</li>
				    	</c:if>
				    	
				    	<c:forEach items="${pageInfo.navigatepageNums }" var="page_Num">
				    		<c:if test="${page_Num == pageInfo.pageNum }">
						    	<li class="active"><a href="#">${page_Num }</a></li>
				    		</c:if>
				    		<c:if test="${page_Num != pageInfo.pageNum }">
						    	<li><a href="${APP_PATH }/emps?pn=${page_Num}">${page_Num }</a></li>
				    		</c:if>
				    	</c:forEach>
				    	
				    	<c:if test="${pageInfo.hasNextPage }">
					    	<li>
					      		<a href="${pageInfo.pageNum+1 }" aria-label="Next">
					        		<span aria-hidden="true">&raquo;</span>
					      		</a>
					    	</li>
				    	</c:if>
				    	<li><a href="${APP_PATH }/emps?pn=${pageInfo.pages}">尾页</a></li>
				  	</ul>
				</nav>
			</div>
		</div>
	</div>

</body>
</html>