<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<style>
	#container{
		background-color: #fafafa;
	}

	#wholeNotice{
		width: 1080px;
		margin: 0 auto;
		/* border: solid 1px black; */
		background-color: #fafafa;
	}
	
	table,tr,th,td{
		border: solid 1px black;
		border-collapse: collapse;
		padding: 20px;
	}
	
	th{
		width: 150px;
	}
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		/*  스마트에디터 */ 
	 	//전역변수
	    var obj = [];
	    
	    //스마트에디터 프레임생성
	    nhn.husky.EZCreator.createInIFrame({
	        oAppRef: obj,
	        elPlaceHolder: "content",
	        sSkinURI: "<%= request.getContextPath() %>/resources/smarteditor/SmartEditor2Skin.html",
	        htParams : {
	            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseToolbar : true,            
	            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseVerticalResizer : true,    
	            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseModeChanger : true,
	        }
	    });	   	   	   
	   
		
	   	// 작성버튼
	      $("#write").click(function(){
	    	    
	    	 /* 스마트에디터 */
			//id가 content인 textarea에 에디터에서 대입
	        obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			/*  스마트에디터 */

	         // 글제목 유효성 검사 
	         var subjectVal = $("#title").val().trim();
	         if(subjectVal == "") {
	            alert("글제목을 입력하세요");
	            return;
	         }
	          
	         
	         /* === 스마트에디터 구현 시작 === */ 
			//스마트에디터 사용시 무의미하게 생기는 p태그 제거
	        var contentval = $("#content").val();
		        
	        // === 확인용 ===
	        // alert(contentval); // content에 내용을 아무것도 입력치 않고 쓰기할 경우 알아보는것.
	        // "<p>&nbsp;</p>" 이라고 나온다.
	        
	        /* 스마트에디터 사용시 무의미하게 생기는 p태그 제거하기전에 먼저 유효성 검사를 하도록 한다.
	        // 글내용 유효성 검사 
	        if(contentval == "" || contentval == "<p>&nbsp;</p>") {
	        	alert("글내용을 입력하세요!!");
	        	return;
	        } */
	        
	        // 스마트에디터 사용시 무의미하게 생기는 p태그 제거하기
	        contentval = $("#content").val().replace(/<p><br><\/p>/gi, "<br>"); //<p><br></p> -> <br>로 변환
	    /*    
	              대상문자열.replace(/찾을 문자열/gi, "변경할 문자열");
	        ==> 여기서 꼭 알아야 될 점은 나누기(/)표시안에 넣는 찾을 문자열의 따옴표는 없어야 한다는 점입니다. 
	                     그리고 뒤의 gi는 다음을 의미합니다.

	        	g : 전체 모든 문자열을 변경 global
	        	i : 영문 대소문자를 무시, 모두 일치하는 패턴 검색 ignore
	    */    
	        contentval = contentval.replace(/<\/p><p>/gi, "<br>"); //</p><p> -> <br>로 변환  
	        contentval = contentval.replace(/(<\/p><br>|<p><br>)/gi, "<br><br>"); //</p><br>, <p><br> -> <br><br>로 변환
	        contentval = contentval.replace(/(<p>|<\/p>)/gi, ""); //<p> 또는 </p> 모두 제거시
	    
	        $("#content").val(contentval);
	     // alert(contentval);
		 	/*  === 스마트에디터 구현 끝 === */
	     
	         
	         // 글제목 유효성 검사 
	         var titleVal = $("#title").val().trim();
	         if(titleVal == "") {
	            alert("제목을 입력하세요");
	            return;
	         }
	         
	         // 폼(form) 을 전송(submit)
	         var frm = document.addFreeFrm;
	         frm.method = "POST";
	         frm.action = "<%= ctxPath%>/addfreeboardEnd.mv";
	         frm.submit();
	      });
	   
	});

</script>

<div id ="container"><br>
	<div id="wholeNotice">
		<div style="text-align: center;">
			<h3 style="font-weight: bold;">자유게시판</h3>
		</div>	
		<br>
			
		<div>
		<form name="addFreeFrm" enctype="multipart/form-data"> <!-- enctype="multipart/form-data" -->
			<table id="table" style="margin: 0 auto; width: 1040px; background-color: white;">
				<tr>
					<th>제목</th>
					<td><input type="text" size="50" id="title" name="title"/></td>
				</tr>
				
				<tr>
					<th>작성자</th>
					<td>
						<input type="text" name="nickname" value="${sessionScope.loginuser.nickname}" readonly />
						<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}" /> 	
					</td>
				</tr>
				
				<tr>
					<th>내용</th>
					<td><textarea rows="15" cols="110" style="width:766px; height:412px;" id="content" name="content"></textarea></td>
				</tr>
							
			</table>
		</form>
		
		</div>
		
		<br>
		<div style="margin: 0 auto; width: 300px;">
			<button type="button" style="width: 140px;" id="write">작성</button>
			<button type="reset" style="width: 140px;">취소</button>
		</div>	
		<br>		
	</div>
	
	
</div>