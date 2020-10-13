<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


	
	<script>
		function go_search(){
			var key = $("#keyword").val();
			
			$.ajax({
			  method:"GET",
			  url: "<%= request.getContextPath()%>/search.mv",
			  data: { "keyword" : key },
			  dataType:"JSON",
			  success:function(json){
				  console.log("실행");
				  console.log(json);
				  
				  $.each(json.items,function(i,item){
					  console.log(item.title);
					  $("#mvResult").append(
					  	"<tr>"+"<td width='100'><img src='"+item.image+"'></td>"+
					  	"<td width='300'>"+item.title+"</td>"+
					  	"<td>"+item.director+"</td></tr>"
					  );
				  });
			  },
			  error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			})

		}
  </script>
  
  	<div id="content">
		<h1>네이버 검색 api 구현하기</h1>
		
		<input type="text" id="keyword" placeholder="영화명 입력"/>
		<button type="button" onclick="go_search();" id="btn-movies-find">검색하기</button>
		<table id="mvResult" align="left" border="1"></table>
		<button type="button" onclick="location.href='javascript:history.back()'" >돌아가기</button>
	</div>