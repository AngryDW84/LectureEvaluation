<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<!-- PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>강의평가 웹사이트</title>
<!-- 부트스트랩 CSS 추가 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- Custom CSS 추가 -->
<link rel="stylesheet" href="./css/custom.css">
</head>

<body>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- popper 자바 자바스크립트 추가하기 -->
	<script src="./js/popper.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
	
	<%
	request.setCharacterEncoding("UTF-8");
	String lectureDivide ="전체" ;
	String searchType = "최신순" ; 
	String search = "" ;
	int pageNumber= 0 ; 
	
	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide")  ; 
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType")  ; 
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search")  ; 
	}
	if(request.getParameter("pageNumber") != null) {
		try{
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"))  ; 
		} catch ( Exception e) {
			System.out.println("검색 페이지 번호 오류") ; 
			
		}
	}
	
	
			String userID = null;
			if (session.getAttribute("userID") != null) {
				userID = (String) session.getAttribute("userID");
			}

			if (userID == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 해주세요') ; ");
				script.println("location.href = 'userLogin.jsp';");
				script.println("</script>");
				script.close();
				return;
			} else {
				System.out.println("userID :" + userID);
				System.out.println("LOG++++++++++++++4");
			}
			
			boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
			System.out.println("userID :" + userID);
			System.out.println("emailChecked :" + emailChecked);
			System.out.println("LOG++++++++++++++7");		
			if (emailChecked == false) {
				
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'emailSendConfirm.jsp';");
				script.println("</script>");
				script.close();
				return;
			}
			
		%>

	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-time active"><a class="nav-link"
					href="index.jsp">메인</a></li>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="dropdown"> 회원관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					
<%
	if(userID == null ) {
%>		
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> 
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a> 
<%
	} else  {
%>
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>
			</ul>

			<form class="form-inline my-2 my-lg-0 action="./index.jsp" method="get">
				<input type="text" name="search" class="form-control mr-sm-2" type="search"
					placeholder="내용을 입력하세요." aria-lable="search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>

	<section class="container">
		<form class="form-inline mt-2" action="./index.jsp" method="get">
			<select class="form-control mx-1 mt-2" name="lectureDivide">
				<option value="전체">전체</option>
				<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected") ;%>>전공</option>
				<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected") ;%>>교양</option>
				<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected") ;%>>기타</option>
			</select>
			<select class="form-control mx-1 mt-2" name="searchType">
				<option value="최신순">전체</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected") ;%>>전공 </option>
			</select> 
			<input class="form-control mx-1 mt-2" type="text" name="search"
				placeholder="내용을 입력하세요">
			<button class="btn btn-primary mx-1 mt-2" type="submit">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal"
				href="#registerModal">등록하기</a> <a class="btn btn-danger mx-1 mt-2"
				data-toggle="modal" href="#reportModal">신고하기</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>() ;
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber) ;
	if(evaluationList != null) {
		for(int i = 0 ; i < evaluationList.size() ; i++ ){
			 if(i ==5 ) break ; 
			 EvaluationDTO evaluation = evaluationList.get(i) ; 
%>


		<div class="card gb-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>&nbsp; <small><%= evaluation.getProfessorName() %></small></div>
					<div class="col-4 text-right"><%= evaluation.getTotalScore() %><span style="color: red;">A</span></div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %>.&nbsp;<small><%= evaluaiton.getLectreYear() %>년 <%= evaluation.getLectureSemesterDivide() %></small>
				</h5>
				<p class="card-text"><%= evaluaiton.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color: red;"><%= evaluaiton.getCreditScore() %></span>
						널널<span style="color: red;"><%= evaluaiton.getComfortableScore() %></span>
						강의<span style="color: red;"><%= evaluaiton.getLectureScore() %></span>
						종합<span style="color: red;"><%= evaluaiton.getTotalScore() %></span>
						<span style="color: green;">(추천: <%= evaluaiton.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')"	 href="./likeAction.jsp?evalutionID=">추천</a> 
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evalutionID=">삭제</a>
					</div>
				</div>
			</div>
		</div>
<%
	}
%>
		
<%--	
		<div class="card gb-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						미술학개론&nbsp;<small>홍보람</small>
					</div>
					<div class="col-4 text-right">
						종합<span style="color: red;">A</span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					gooooooooooooooooooood정말 좋은 강의예요.&nbsp;<small>2015년 가을학기</small>
				</h5>
				<p class="card-text">이래저래 좋았습니다만 안좋은것도 있었어요.</p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color: red;">A</span> 널널<span style="color: red;">A</span>
						강의<span style="color: red;">C</span> 종합<span style="color: red;">B</span>
						<span style="color: green;">(추천: 20)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')"
							href="./likeAction.jsp?evalutionID=">추천</a> <a
							onclick="return confirm('삭재하시겠습니까?')"
							href="./deleteAction.jsp?evalutionID=">삭제</a>
					</div>
				</div>
			</div>
		</div>
		<div class="card gb-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						수학개론&nbsp;<small>김동원</small>
					</div>
					<div class="col-4 text-right">
						종합<span style="color: red;">A</span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					재밌지만 어렵네요.&nbsp;<small>2013년 가을학기</small>
				</h5>
				<p class="card-text">어려웠지만 좋았습니다.</p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color: red;">A</span> 널널<span style="color: red;">A</span>
						강의<span style="color: red;">C</span> 종합<span style="color: red;">B</span>
						<span style="color: green;">(추천: 20)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')"
							href="./likeAction.jsp?evalutionID=">추천</a> <a
							onclick="return confirm('삭재하시겠습니까?')"
							href="./deleteAction.jsp?evalutionID=">삭제</a>
					</div>
				</div>
			</div>
		</div>
 --%>
	</section>
	
	<ul	class="pagination" justify-content-center mt-3">
		<li class ="page-item">
		
<%
if(pageNumber <= 0 ) {
%>
<a class="page-link disabled">이전</a>

<%
} else {
%>
	<a class="page-link"
	href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>
	&search=<%= URLEncoder.encode(search, "UTF-8") %>
	&pageNumber=<%= pageNumber - 1 %>">
	이전
	</a>
	
<%
	}
%>
		</li>
		<li>
<%
if(evaluationList.size() < 6 ) {
%>
<a class="page-link disabled">다음</a>

<%
} else {
%>
	<a class="page-link"
	href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>
	&search=<%= URLEncoder.encode(search, "UTF-8") %>
	&pageNumber=<%= pageNumber + 1 %>">
	다음
	</a>
	
	<%
		}
	%>
		</li>
		
	</ul>
	<%-- 등록하기 시작--%>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog"
		aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가등록</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="close">
						<span aria-hidden="true"> &times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>강의명</label> <input type="text" name="lectureName"
									value="" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label> <input type="text" name="professorName"
									value="" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>수강연도</label> <select class="form-control"
									name="lectureYear">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018" selected>2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="">수강학기</label> <select class="form-control"
									name="semesterDivide">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="">강의구분</label> <select class="form-control"
									name="lectureDivide">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="">제목</label> <input class="form-control" type="text"
								name="evaluationTitle" value="" maxlength="30">
						</div>
						<div class="form-group">
							<label for="">내용</label>
							<textarea class="form-control" name="evaluationContent"
								maxlength="2048" style="height: 180px;">
                </textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label for="">성적</label> <select class="form-control"
									name="creditScore">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="">널널</label> <select class="form-control"
									name="comfortableScore">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="">강의</label> <select class="form-control"
									name="lectureScore">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="">종합</label> <select class="form-control"
									name="totalScore">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button class="btn btn-secondary" type="button" name="button"
								data-dismiss="modal">취소</button>
							<button class="btn btn-primary" type="submit" name="button">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<%-- 등록하기 끝--%>


	<%-- 신고하기 시작--%>
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog"
		aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="close">
						<span aria-hidden="true"> &times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label for="">신고제목</label> <input class="form-control"
								type="text" name="reportTitle" value="" maxlength="30">
						</div>
						<div class="form-group">
							<label for="">신고내용</label>
							<textarea class="form-control" name="reportContent"
								maxlength="2048" style="height: 180px;">
                </textarea>
						</div>
						<div class="modal-footer">
							<button class="btn btn-secondary" type="button" name="button"
								data-dismiss="modal">취소</button>
							<button class="btn btn-danger" type="submit" name="button">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<%-- 신고하기 끝--%>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2018 김동원 All Right Reserved. </footer>

</body>
</html>


<!-- 강의평가 웹사이트 만들기 https://www.inflearn.com/course-status-2/ -->
