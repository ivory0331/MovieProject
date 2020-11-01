<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style>
	.title{
		cursor: pointer;
	}
	
</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" >
<script src="https://code.jquery.com/jquery-3.5.1.js" ></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
	
		// 검색어를 입력 후 엔터를 하는 경우
		$("#searchWord").keydown(function(event) {
			 if(event.keyCode == 13) {
				 // 엔터를 했을 경우
				 goSearch();
			 }
		 });
		
		// 검색시 검색조건 및 검색어 값 유지시키기 
		if(${paraMap != null}) {
			$("#searchType").val("${paraMap.searchType}");
			$("#searchWord").val("${paraMap.searchWord}");
		}
		
		
	});// end of $(document).ready() -------------------------------------
	

	// 글을 보여주는 함수
	function goView(post_seq){
		
		<%-- location.href="<%=ctxPath%>/freeboardView.mv?post_seq="+post_seq; --%>
		
		 var frm = document.goViewFrm;
		 frm.post_seq.value = post_seq;
		 
			frm.method = "GET";
			frm.action = "freeboardView.mv";
			frm.submit(); 
	     
	 }// end of goView(seq) ------------------------------------
	
 
	// 글을 검색하는 함수
	function goSearch() {
			var frm = document.searchFrm;
			frm.method = "GET";
			frm.action = "<%= request.getContextPath()%>/freeBoardList.mv";
			frm.submit();
	}// end of function goSearch()-------------------------

	
	
</script>
	<div>
		<h2>자유게시판</h2>
	</div>	
	<br>
	<div class="container">
		<table class="table table-hover">
			<thead>
			<tr>
				<th scope="col">NO</th>
				<th scope="col">제목</th>
				<th scope="col">작성자</th>
				<th scope="col">날짜</th>
				<th scope="col">조회수</th>
			</tr>
			</thead>
			<tbody>
				<c:if test="${empty freeboardList}">
					<td colspan="5">게시글이 없습니다</td>
				</c:if>
				<c:if test="${not empty freeboardList}">
				<c:forEach var="boardList" items="${freeboardList}" varStatus="status">
					<tr>
						<th scope="row">${boardList.post_seq}</th>
						<td><span class="title" onclick="goView('${boardList.post_seq}')">${boardList.title}</span></td>
						<td>${boardList.nickname} ( ${boardList.userid} )</td>
						<td>${boardList.write_date}</td>
						<td>${boardList.view_cnt}</td>
					</tr>
				</c:forEach>
				</c:if>	
			</tbody>
		</table>
	</div>
		
		<!-- 페이지바  -->
		<div align="center" style="width: 60%; margin: 20px auto;">
			${pageBar}
		</div> 
				
	<div>
	<c:if test="${not empty sessionScope.loginuser.userid}">
		<span style="margin-left: 960px; border: solid 1px #f2f2f2; background-color: #f2f2f2; display:inline-block; width:80px; height: 30px; text-align: center; line-height: 30px; border-radius: 10px;">
			<a href="<%=ctxPath%>/freeBoardAdd.mv">글쓰기</a>
		</span>	
	</c:if>
	</div>
	 
	<form name="searchFrm" style="margin-top: 20px; margin-left: 40px;">
		<select name="searchType" id="searchType" style="height: 26px;">
			<option value="title">글제목</option>
			<option value="nickname">작성자</option>
		</select>
		<input type="text" name="searchWord" id="searchWord" size="40" autocomplete="off" /> 
		<span onclick="goSearch()" style="border: solid 1px #f2f2f2; background-color: #f2f2f2; display:inline-block; width:50px; height: 25px; text-align: center; line-height: 25px; border-radius: 10px;">검색</span>
	</form>
	
		
	<br>
	
	<form name="goViewFrm">
		<input type="hidden" name="post_seq"/>
		<input type="hidden" name="gobackURL" value="${gobackURL}"/>
	</form>
	