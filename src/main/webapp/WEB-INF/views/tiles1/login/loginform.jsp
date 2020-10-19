<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>

<style type="text/css">
	div.login_container {
		max-width: 1080px;
		height: 500px;
		margin: 0 auto;
		border: solid 1px red;
	}
	div.loginname{
		border: solid 0px red;
		margin: 20px 0px;
		width: 300px;
	}
	div#loginbox{
		border: solid 1px blue;
		margin: 0 auto;
		padding-left: 20px;
		width: 500px;
		height: 300px;
	}

</style>

<script type="text/javascript">
 
     $(document).ready(function(){
    	 
    	 $("#btnLOGIN").click(function() {
    		 func_Login();
    	 }); // end of $("#btnLOGIN").click();-----------------------
    	 
    	 $("#pwd").keydown(function(event){
  			
  			if(event.keyCode == 13) { // 엔터를 했을 경우
  				func_Login();
  			}
    	 }); // end of $("#pwd").keydown();-----------------------	
    	 
    }); // end of $(document).ready()---------------------------	 

    
    function func_Login() {
    		 
		 var userid = $("#userid").val(); 
		 var pwd = $("#pwd").val(); 
		
		 if(userid.trim()=="") {
		 	 alert("아이디를 입력하세요!!");
			 $("#userid").val(""); 
			 $("#userid").focus();
			 return;
		 }
		
		 if(pwd.trim()=="") {
			 alert("비밀번호를 입력하세요!!");
			 $("#pwd").val(""); 
			 $("#pwd").focus();
			 return;
		 }

		 var frm = document.loginFrm;
		 
		 frm.action = "<%=ctxPath%>/loginEnd.mv";
		 frm.method = "POST";
		 frm.submit();
		 
    } // end of function func_Login(event)-----------------------------
     
</script>

	<div class="login_container">
		<h2>로그인</h2>
		
		<form name="loginFrm">
		<div id="loginbox">
			<input type="text" name="userid" id="userid" value="" required autofocus placeholder="아이디"/>
			
			<br>
			
			<input type="password" name="pwd" id="pwd" value="" required placeholder="비밀번호"/> 
			
			<br>
			<button class="btn" type="button" id="btnLOGIN">로그인</button> 
			
			<br>
			
			<div class="login_footer">
				<input type="checkbox" value="">아이디 저장하기 <br>
				<a href="<%=ctxPath%>/login/findID.mv">아이디찾기</a><span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
				<a href="<%=ctxPath%>/login/findPWD.mv">비밀번호 찾기</a><span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
				<a href="<%=ctxPath%>/login/joinmember.mv">회원가입</a>
			</div>
		</div>
		</form>
	</div>





