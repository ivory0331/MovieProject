<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======= #27. tile1 중 header 페이지 만들기  ======= --%>
<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">

.dropdown {
  position: relative;
  display: inline-block;
  /* border: solid 1px gray;  */
  width: 210px; 
  height: 40px;
  background-color: white; 
  /* margin-left: 30px; */
  line-height: 40px;
 /*  margin-top: 18px; */
  cursor: pointer;
  color: #333;
  font-weight: bold;
  font-size: 15pt;
  border-left: solid 1px #ccc; 
}

.dropdown:hover{
	text-decoration: underline;
	color: #00BCD4;
}

.dropdown-content {
  display: none;
  position: absolute;
  background-color: white;
  min-width: 180px;
  /* box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); */
  padding: 12px 16px;
  cursor: pointer;
  color: #333;
  opacity: 0.9;
  
}

.dropdown:hover .dropdown-content {
  display: block;
}

.minimenu{
   display: inline-block; 
   float: right; 
   /* border: solid 1px red;  */
   margin-right: 20px;
   cursor: pointer;
   font-weight: bold;
   text-align: center;
}

.logo:hover{
   text-decoration: none;
   color:black;
   cursor: pointer;
}

.logo{
   width: 250px; 
   margin-left:405px; 
   height: 75px; 
   display: inline-block;
}

.moveColor {
   color: #00BCD4; 
   font-weight: bold; 
   background-color: #00BCD4;
}

a{
	text-decoration: none;
	color: #333;
}


a.minim{
	text-decoration: none;
	font-size: 10pt;
	display: inline-block; 
	text-align: center; 
}

a:link{
	color: #333;
}

a:visited{
	color: #333;	
}

a:hover{
   color: #00BCD4; 
}


</style>
<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script type="text/javascript">
   
   $(document).ready(function(){
      
      $(".downmenu").hover(function(){
                     $(this).addClass("moveColor");
                       }, 
                       function(){
                          $(this).removeClass("moveColor"); 
                       }
      );
      
   });

</script>

<html>
<body style="margin: 0;">
<!-- header 전체를 감싸는 div / 가로사이즈 지정 -->
<div style="width:1080px; height: 200px; margin: 0 auto; padding-top:10px;"><br>

<!-- header 중앙에 표시되는 로고  -->
	<img class="logo" onclick="javascript:location.href='<%=ctxPath%>/index.mv'" src="<c:url value="/resources/images/index/logo.png" />">
	
<!-- 우측상단 미니메뉴바  -->

<c:if test="${sessionScope.loginuser != null}">
	<span class="minimenu"><a class="minim" href="<%=ctxPath%>/login/logout.up"><img  src="<c:url value="/resources/images/index/logout.png" />"><br>로그아웃</a></span>
</c:if>
<c:if test="${sessionScope.loginuser == null}">
	<div class="minimenu"><a class="minim" href="<%=ctxPath%>/login/login.up"><img src="<c:url value="/resources/images/index/login.png" />"><br>로그인</a></div>
</c:if>
<div class="minimenu"><a class="minim" href="<%=ctxPath%>/QnAList.mv"><img style="width: 24px; height: 24px;" src="<c:url value="/resources/images/index/qa3.png" />"><br>Q&A</a></div>
<c:if test="${sessionScope.loginuser.userid == 'admin'}">
	<span class="minimenu"><a class="minim" href="<%=ctxPath%>/admin.up""><img  src="<c:url value="/resources/images/index/admin.png" />"><br>관리자</a></span>
</c:if>

   <!-- =====================================================================  -->
   
   <!-- 메뉴바가 담겨져 있는 div -->
   <div style="width: 1080px; height:70px; margin: 0 auto; text-align: center; margin-top: 20px; position: relative; z-index:1;" >
      
      <div class="dropdown">
        <span onclick="javascript:location.href='<%=ctxPath%>/login.mv'">로그인/회원가입</span>
      </div>      
      
      <div class="dropdown">
         <span onclick="javascript:location.href='<%=ctxPath%>/spoilerList.mv'">스포주의 감상문</span> 
      </div>
      
      <div class="dropdown">
        <span>커뮤니티</span>
        <div class="dropdown-content">
        <a class="downmenu" href="<%=ctxPath%>/freeBoardList.mv">자유게시판</a><br>
        <a href="<%=ctxPath%>/noticeList.mv">공지사항</a><br>
        <a href="<%=ctxPath%>/QnAList.mv">Q&A</a>
        </div>
      </div>
      
      <div class="dropdown" style="border-right: solid 1px #ccc;">
      	<c:if test="${empty sessionScope.loginuser}">
           <span onclick="javascript:location.href='<%=ctxPath%>/mypageMain.mv'">마이페이지</span>
           </c:if>
      	
      	<c:if test="${sessionScope.loginuser.identity == 1}">
           <span onclick="javascript:location.href='<%=ctxPath%>/mypageMain.up'">마이페이지</span>
        </c:if>
                
       </div>
    </div>
      
   </div>  

