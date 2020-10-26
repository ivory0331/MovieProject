<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
  <%
   String ctxPath = request.getContextPath();
%>
  <style type="text/css">
  
  	div#con{
  		border: solid 1px #f2f2f2;
  		background: #f2f2f2;
  		margin: 30px 0;
  		padding: 40px;
  		border-radius: 2%;
  	}
  	.error{
  		color: red;
  		font-size: 8pt;
  	}
  	.pointer{
  		cursor: pointer;
  	}
  	
  </style>
  
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" >
<script src="https://code.jquery.com/jquery-3.5.1.js" ></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">

 	$(document).ready(function(){ 
	
		// 엔터를 누를 경우 다음 input 태그로 이동하기
		$('input').keydown(function(e) {
			var idx = $('input').index(this); // index가 바로 eq 값을 알려주는 친구
			if (e.keyCode === 10) {
				event.preventDefault(); // input 태그에서 엔터 누를 시 submit 방지하기
				$('input').eq(idx+1).focus();
			};
		}); 
		
		// 아이디 중복확인 클릭 여부
		var bIdDuplicateCheck = false; 
		
		$(".error").hide();
		
		// 아이디 유효성 검사 ---------------------------
		$("#userid").blur(function(){ 
			
			var data = $(this).val().trim();
			
			// 유효성 검사 해야함 (영소문자 + 숫자 조합 4 ~ 20)
			var regExp_userid = /^(?=.*[a-z])+[a-z0-9_]{4,20}$/;
			var bool = regExp_userid.test(data);
			
			if(data == "") { // 빈칸이면
				$(this).parent().find(".idregex").hide();
				$(this).parent().find(".iderror").show();
			}
			else if (!bool) { // 유효성에서 걸린다면
				$(this).parent().find(".iderror").hide();
				$(this).parent().find(".idregex").show();
			}
			else { // 다 통과할시
				$(this).parent().find(".iderror").hide();
				$(this).parent().find(".idregex").hide();
			}
		});
		
		// AJAX로 아이디 중복 검사 --------------------------
		$("#idcheck").click(function(){ 
			//alert("아이디 중복검사 체크");
			var useridVal = $("#userid").val().trim();
			
			$("#idcheckResult").html("");
			var regExp_userid = /^(?=.*[a-z])+[a-z0-9_]{4,20}$/;
			var bool = regExp_userid.test(useridVal);
			
			// 빈칸으로 아이디 중복검사 버튼을 누른 경우
			if(useridVal == "") {
				alert("아이디를 입력하세요");
			}
			// 아이디 중복검사 버튼을 잘 누른 경우
			else if (useridVal != "") {
				
				$(".iderror").hide();
				
				$.ajax({ 
					url: "<%= ctxPath%>/login/idDuplicateCheck.mv",
					type: "POST",
					data: {"userid":$("#userid").val()},
					dataType: "JSON",
					success: function(json) {						
						if(json.n == null && useridVal != "" && bool) {
							alert("사용 가능한 아이디 입니다!");
							bIdDuplicateCheck = true; // 아이디 중복검사 클릭함 (true)
						}
						else if (useridVal != "" & bool) {
							alert("중복된 아이디 입니다!");
							$("#userid").val("");
						}
					},
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				}); // end of ajax
			}
			
		}); // end of $("#idcheck").click(function(){ ----------------------------------------------
		
			
		// 비밀번호 유효성 검사 --------------------------------------------
		$("#pwd").blur(function(){ 
			
			var data = $(this).val().trim();
			var regExp_pwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
		
			var bool = regExp_pwd.test(data);
			
			if (data != "" && !bool ) { // 암호가 정규표현식에 위배된 경우
				$(this).parent().find(".error").show();
				$("#pwd").focus();
			}
			else {
				$(this).parent().find(".error").hide();
			}

		}); // -------------------------------------------------------
		
		
		// 비밀번호 일치여부 확인
		$("#pwdcheck").blur(function(){ 
			var pwd = $("#pwd").val();
			var pwdcheck = $(this).val().trim();

			if (pwd != pwdcheck) { // 암호가 정규표현식에 위배된 경우
				$(this).parent().find(".error").show();
				$("#pwdcheck").val("");
				$("#pwdcheck").focus();
			}
			else {
				$(this).parent().find(".error").hide();
			}

		}); // -------------------------------------------------------
		
		
		// 휴대전화 유효성 검사 ------------------------------------------
		$("#mobile").keyup(function(){  
			
			var keycode = event.keyCode;
			
			// 숫자 이외의 문자를 입력 시 에러 문구 보여준다.
			if( !((48 <= keycode && keycode<=57) || (96<=keycode && keycode<=105))){
				$(this).parent().find(".error").show(); 
		    }
			
			$(this).parent().find(".error").hide();
			var data = $(this).val().trim();
			var regExp_mobile = /^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/;
	
			var bool = regExp_mobile.test(data);
			
			if (!bool ) { // 암호가 정규표현식에 위배된 경우
				$(this).parent().find(".error").show();
			}
			else {
				$(this).parent().find(".error").hide();
			}
		
		});
		
		// 가입 버튼을 눌렀을 경우 ------------------------------------
		$("#goRegister").click(function(){ 
			
			// 필수항목을 모두 입력했는지
			var useridVal = $("#userid").val().trim();
			var nameVal = $("#name").val().trim();
			var nicknameVal = $("#nickname").val().trim();
			var pwdcheckVal = $("#pwdcheck").val().trim();
			var pwdVal = $("#pwd").val().trim();
			var mobile = $("#mobile").val().trim();
			
			if (useridVal == "" || nameVal == "" || nicknameVal == "" || pwdcheckVal == "" || pwdVal == "" || mobile == "") {
				alert("필수 항목은 모두 입력해주세요!");
				return;
			}
			// 아이디 중복확인 클릭 여부 --------------------------------
			if (bIdDuplicateCheck == false) {
				alert("아이디 중복확인은 필수입니다!");
				return;
			}
			
			func_goRegister();
			
		});
		
	}); // end of $(document).ready(function() -----------
	
	// 회원가입 함수
	function func_goRegister() {
	
		var frm = document.information_form;
		frm.method = "POST";
		frm.action = "<%= ctxPath%>/login/loginEnd.mv";
		frm.submit();
	}	 	
	 
</script>

<body id="content">
	<div id="con">
	<div id="signuptitle">
		<h1 id="head_main">회원가입</h1>
	</div>
		<div id="information_content">
			<div id="information_back">
				<span style="font-size: 16pt; ">가입정보를 입력해 주세요.</span><span class="required_red" style="margin-left: 550px;">*</span>
				<span style="font-size: 10pt;">표시는 필수 입력 항목입니다.</span>
				
				<form name="information_form">
				  <div class="form-row">
				  
				  	<div class="form-group col-md-4">
				  	<span class="required_red">*</span>
				      <label for="userid">아이디</label>
				      <input type="text" class="form-control" id="userid" name="userid">
				      <span id="idcheck" class="pointer" style="display: inline-block; border: solid 1px #464646; width: 100px; line-height: 30pt; text-align: center; margin-left: 15px;">중복확인</span>
					  <span id="idcheckResult"></span>
				      <span class="error iderror">아이디는 필수입력 사항입니다.</span>
					  <span class="error idregex">아이디는 영소문자, 숫자를 포함하여 4~20글자로 입력해주세요.</span>
				    </div>
				    
				    <div class="form-group col-md-4">
				    <span class="required_red">*</span>
				      <label for="name">성명</label>
				      <input type="text" class="form-control" id="name" name="name">
				    </div>
				    
				    <div class="form-group col-md-4">
				    <span class="required_red">*</span>
				      <label for="nickname">닉네임</label>
				      <input type="text" class="form-control" id="nickname" name="nickname">
				    </div>
				    
				    <div class="form-group col-md-6">
				    <span class="required_red">*</span>
				      <label for="pwd">비밀번호</label>
				      <input type="password" class="form-control" id="pwd" name="pwd">
				      <span class="error">비밀번호 조건에 부합하지 않습니다.</span>
					  <div class="sub_text">비밀번호는 영문자, 숫자, 특수기호를 모두 포함하여 8~16자로 입력해 주세요.</div>
				    </div>
				    
				    <div class="form-group col-md-6">
				    <span class="required_red">*</span>
				      <label for="pwdcheck">비밀번호 확인</label>
				      <input type="password" class="form-control" id="pwdcheck">
				      <span class="error">암호가 일치하지 않습니다.</span>
					  <div class="sub_text">동일한 비밀번호를 다시 한 번 입력해주세요.</div>
				    </div>
				    
				    <div class="form-group col-md-6">
				    <span class="required_red">*</span>
				      <label for="email">이메일</label>
				      <input type="email" class="form-control" id="email" name="email">
				    </div>
				    
				    <div class="form-group col-md-6">
				    <span class="required_red">*</span>
				      <label for="mobile">핸드폰</label>
				      <input type="text" class="form-control" id="mobile" name="mobile" placeholder="ex) 01012341234">
					  <span class="error mberror">휴대전화 형식이 아닙니다.</span>
				    </div>
				    
				    
				    <div class="form-group col-md-2">
				      <label for="bank_account">계좌 정보</label>
				      <select id="bank_account" class="form-control" name="bank_name">
				        <option selected>은행 이름</option>
				        <option value="기업은행">기업은행</option>
				        <option value="신한은행">신한은행</option>
				        <option value="국민은행">국민은행</option>
				        <option>그외 </option>
				      </select>
				    </div>
				    
				    <div class="form-group col-md-4">
				      <label for="bank_number">계좌번호</label>
				      <input type="text" class="form-control" id="bank_number" name="bank_num">
				    </div>
				    <!--
				   	프로필사진 올리기 위한 첨부파일 넣기 
				    <div class="form-group col-md-6">
				      <label for="filename">파일첨부</label>
				      <input type="file" class="form-control" id="filename">
				    </div>
				    -->
				  </div>
				  <div class="form-group">
				    <div class="form-check">
				      <input class="form-check-input" type="checkbox" id="gridCheck">
				      <label class="form-check-label" for="gridCheck">
				        Check me out
				      </label>
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-success" id="goRegister">가입하기</button>
				  <button class="btn btn-secondary" onclick="alert('취소 (메인페이지로)')">취소</button>
				</form>
						
			</div>
		</div>
	</div>
</body>

