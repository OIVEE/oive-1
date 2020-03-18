
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.springframework.web.context.annotation.RequestScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>프로필</title>
	<!-- 링크 넣어주기  -->
	<!-- <link rel="canonical" href="https://getbootstrap.com/docs/4.4/examples/starter-template/"> -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/oive.css" >	
	<link href="https://fonts.googleapis.com/css?family=Song+Myung:400" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Gamja+Flower:400" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
<style>*{font-family:/* Song Myung */ Noto Sans} 
 h2{
 margin-left:-10px;
 font-size:1.3em;
 }
 h3{
 font-size:1.1em;
 }
  </style>
<!-- <style>form.profile{margin-bottom:30px;}</style> -->
  </head>
	<body>
		<%@ include file="header.jsp" %>

	  	<div id="body" class="container"> 
	  	<div class="row">
		    <div class="col-sm-2" style="/* display:none; margin-top:-50px;*/"><!-- nav 감추기 -->
		    	<ul class="nav" style="display:inline-block;position:fixed;">
			    	<li class="nav-item"><a href="#university" class="nav-link">학력 사항</a></li>
			    		<ul class="nav" style="display:inline-block;">
			    			<li class="nav-item" style="margin-left:40px; font-size:"><a href="#university">대학교</a></li>
			    			<li class="nav-item" style="margin-left:40px"><a href="#education">교육사항</a></li>
			    		</ul>
			    	<li class="nav-item"><a href="#certifications" class="nav-link">자격증</a></li>
			    	<li class="nav-item"><a href="#languages" class="nav-link">외국어</a></li>
			    	<li class="nav-item"><a href="#skills" class="nav-link">기술</a></li>
			    	<li class="nav-item"><a href="#award" class="nav-link">수상이력</a></li>
			    	<li class="nav-item"><a href="#patent" class="nav-link">특허</a></li>
			    	<li class="nav-item"><a href="#publications" class="nav-link">논문 &middot; 저서</a></li>
			    	<li class="nav-item"><a href="#workExperience" class="nav-link">경력</a></li>
		    	</ul>
		    </div>
		    <div class="col-sm profile" style="display:inline-flex;flex-direction:column">
		    	<h2 style="">학력사항</h2> 
		    	<h3 id="university">대학교</h3>
		    	<c:import url="/form/university"/>
		    	<div id="university-add"></div>

				<h3 id="education">교육사항</h3>
		    	<c:import url="/form/education"/>
		    	<div id="education-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="certifications">자격증</h2> 
		    	<c:import url="/form/certifications"/>
		    	<div id="certifications-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="languages">외국어</h2> 
		    	<c:import url="/form/languages"/>
		    	<div id="languages-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="skills">기술</h2> 
<%-- 		    	<c:import url="/form/skills"/> --%>
		    	<div id="skills-add"><!-- 이곳에 추가된 form이 붙음.--></div>
	
		    	
		    	<h2 id="award">수상이력</h2> 
		    	<c:import url="/form/award"/>
		    	<div id="award-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="patent">특허</h2> 
		    	<c:import url="/form/patent"/>
		    	<div id="patent-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="publications">논문 &middot; 저서</h2> 
		    	<c:import url="/form/publications"/>
		    	<div id="publications-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
		    	<h2 id="workExperience">경력</h2> 
		    	<c:import url="/form/workExperience"/>
		    	<div id="workExperience-add"><!-- 이곳에 추가된 form이 붙음.--></div>
		    	
			</div>

<!-- 	    	<aside>어사이드입니다. 작업이 끝나면 지워주세요.</aside>  -->
		 </div>
		 </div>
	<%@ include file="footer.jsp" %>

	
	 	<script>
		    function add(id){
		      var target = document.getElementById(id.split("_")[0]);
		      var category = id.split("-")[0];
		      console.log(target);
		      var xhr = new XMLHttpRequest();
		      xhr.onload=function(){
		        if(xhr.status==200){
		          target.innerHTML += this.responseText;
		        }
		      };
		      xhr.open("GET", "/oive/insert/"+category, true);
		      xhr.send();
		    }
// 폼 수정하기		    
    function edit(id){    	
//     	window.alert("form_"+id);    	
    	var formElement = document.getElementById("form_"+id);  
//     	window.alert(formElement);
//     	window.alert(formElement.action);
    	var formData = new FormData(formElement);
//     	window.alert(formData.get('id'));
//     	window.alert(formData.get('uName'));

		var xhr= new XMLHttpRequest();
    	xhr.onload=function(){
    		if(xhr.status==200){
    			window.alert("성공하였습니다: "+ xhr.responseText);    			
    		} else
    			window.alert("실패하였습니다: "+ xhr.responseText);
    	}
    	xhr.open("POST", "/oive/edit", true);
    	xhr.send(formData);    	
    }
    
    	function del(btId){
    		var category = btId.split("/")[1];
    		var id = btId.split("/")[2];	
//     		window.alert("formGroup_"+category+"_"+id);
    		var target
    			= document.getElementById("formGroup_"+category+"_"+id);
    		var xhr = new XMLHttpRequest();
    		xhr.onload=function(){
    			if(xhr.status==200){
    				var msg = xhr.responseText==1?"삭제 성공":"삭제 실패";
    				window.alert(msg);
    				target.innerHTML = '';
    			} 
    			else{
    				window.alert("삭제가 실패하였습니다.");
    			}    				
    		}
    		xhr.open("GET", btId, true);
    		xhr.send();    		
    	}
    	
	    function hide(id){
    		var target = document.getElementById(id);
    		console.log(target);
			target.style.display ='none';
    	}
    	
    </script>
	</body>
  </html>