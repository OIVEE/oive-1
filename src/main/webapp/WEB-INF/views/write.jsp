
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="org.springframework.web.context.annotation.RequestScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="vo.SelfIntroduceVO, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
	<!-- 링크 넣어주기  -->
	<!-- <link rel="canonical" href="https://getbootstrap.com/docs/4.4/examples/starter-template/"> -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/oive.css" > 
	<link href="https://fonts.googleapis.com/css?family=Song+Myung:400" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Gamja+Flower:400" rel="stylesheet">
	
	<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	<style>
		li.post-content {
			/* border: black 1px solid; */
			display: block;
			margin: 20px;
		}

		ul.post-content-box {
			background: #0000000d;
			margin-left: 50px;
			margin-top: -2%;
			padding: 5px;
			transition: height 3s;
			height: 100px;
		}
    </style>
  </head>
  <body>
	<%@ include file="header.jsp" %>
  <div id="body">

    <div class="container">
		<div class="row">
			<div class="search col-sm" action="/oive/self_introduce/search" method="GET">
				<select class="form-control search-dropdown" id="search" name="boundary">
					<option value="company">지원회사</option>
					<option value="keyword">키워드</option>
					<option value="question">질문</option>
					<option value="answer">답변</option>					
				</select>
				<input class="search-input" name="input" id="input">
				<button onclick="myexample();" class="search-icon"  data-toggle="modal" data-target=".bd-example-modal-lg">
					<i class="fas fa-search"></i>
				</button>
			<!-- 검색 결과 모달 시작 -->
				<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
				  	<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">검색 결과</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								<div class="post-list">
									<ul class="list-header2">
										<li class="keywords">키워드</li>
										<li class="company">지원회사</li>
										<li class ="applied-date">작성일자</li>
									</ul>
									
									<div  id="one">
									<ul onclick="showContent(this)" data-id="1">
										<li class="keyword">keywords</li>
										<li class="company">지원회사</li>
										<li class ="applied-date">2019-09-09</li>
									</ul>
									</div>
									<ul class="post-content-box" data-id="1" style="display: none;">
										<li class="post-content">게시글</li>
									</ul>
								</div>
							</div>
						</div>
				  	</div>
				</div>	
				
			<!-- 모달 끝 -->		
			</div>
		</div>
    	<form>
    		<div class="row">
	    		<div class="form-group col-sm">
		    		<textarea class="form-control" name="question" id="exampleFormControlTextarea1" placeholder="질문" rows="3" style="width:500px;"></textarea>
		    		<br>
		    		<textarea class="form-control" name="answer" id="exampleFormControlTextarea1" placeholder="답변" rows="3" style="width:500px;"></textarea>
	  			</div>
	
				<div class="form-group col-sm-3">
			  			<input id="textinput" name="keywords" type="text" placeholder="키워드" class="form-control input-md"><br><br>
			  			<input id="textinput" name="appliedCompany" type="text" placeholder="지원회사" class="form-control input-md"><br><br>
			  			<input id="textinput" name="writeDate" type="DATE" placeholder="지원일자" class="form-control input-md"><br><br>	
						<input id="hidden" name="action" value="insert">	

				</div>    		
    		</div>

			<div class="from-group">
				<input type="submit" value="저장" class="btn btn-dark" style="width:100px">
				<input type="reset" value="취소" class="btn btn-dark" style="width:100px">	
			</div>		
    	</form>
    </div>
	<%@ include file="footer.jsp" %>

</div>

<script>
	var event;
	function showContent(e) {
		var id = e.dataset.id;
		var dom = document.querySelector('.post-content-box[data-id="'+id+'"]');

		if(dom.style.display=="block"){
			dom.style.display="none";
		}
		else{
			dom.style.display="block";
		}
		
	}
	
	var myexample = function(e){
		var xhr = new XMLHttpRequest();
		var sdom = document.getElementById("search");
		var svalue = sdom.options[sdom.selectedIndex].value;
		var ivalue = document.getElementById("input").value;
		xhr.onload = function(e){
				if(xhr.status == 200){
					var str = xhr.responseText;
					var result = JSON.parse(str); // str값은 JSON파싱함, //자동으로 배열로 변경
					var output = "";
					/* console.log(result);
					console.log(result[0].appliedcompany); */ // 배열안에 이름과 동일해야만 찾을 수 있다.
					for(var i in result){
						output += "<ul><li>"+result[i].keywords+"</li><li>"+result[i].appliedCompany+"</li><li>"+result[i].applyDate+"</li></ul>";											
					} 
					document.getElementById("one").innerHTML = output;
			}
		};
		xhr.open('GET','/oive/self_introduce/search?boundary='+svalue+'&input='+ivalue,true);
		xhr.send();
	}
</script>
  </body>
</html>