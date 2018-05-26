<!-- 26:42초 https://www.youtube.com/watch?v=e_XHILt7QUo&list=PLRx0vPvlEmdAdWCQeUPnyMZ4PsW3dGuFB&index=9 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="javax.mail.Authenticator"%>


<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.Gmail"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>


<%
	UserDAO userDAO = new UserDAO() ;
	String userID = null ;
	if(session.getAttribute("userID") != null ) {
		userID = (String) session.getAttribute("userID") ;
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.') ; ");
		script.println("'location.href=userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

	boolean emailChecked = userDAO.getUserEmailChecked(userID) ;
	if(emailChecked == true) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.') ; ");
		script.println("'location.href=index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

	String host = "http://localhost:8080/JspEvaluation/" ;
	String from = "06sinji@gmail.com" ;
	String to = userDAO.getUserEmail(userID) ;
	String subject = "강의평가를 위한 이메일 인증입니다." ;
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요." +
	"<a href = '" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>" ;

		Properties p = new Properties() ;
		p.put("mail.smtp.user",from) ;
		p.put("mail.smtp.host","smtp.googlemail.com") ;
		p.put("mail.smtp.port","465") ;
		p.put("mail.smtp.starttls.enable","true") ;
		p.put("mail.smtp.auth","true") ;
		p.put("mail.smtp.debug","true") ;
		p.put("mail.smtp.socketFactory.port","true") ;
		p.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory") ;
		p.put("mail.smtp.socketFactory.fallback","false") ;


		try {
			Authenticator auth = new Gmail() ;
			Session ses = Session.getInstance(p, auth) ;
			ses.setDebug(true) ;
			MimeMessage msg = new MimeMessage(ses) ;
			msg.setSubject(subject) ;
			Address fromAddr = new InternetAddress(from) ;
			msg.setFrom(fromAddr) ; 
			Address toAddr = new InternetAddress(to) ; 
			msg.addRecipient(Message.RecipientType.TO, toAddr) ;
			msg.setContent(content, "text/html;charset=UTF-8") ; 
			Transport.send(msg) ; 
		} catch (Exception e) {
			e.printStackTrace() ;
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('오류가 발생했습니다.') ; ");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			return;
		}


%>


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

		//String userID = null ; 
		if(session.getAttribute("userID") != null ){
			userID = (String) session.getAttribute("userID") ;
		}
		if(userID != null ){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 된 상태입니다.') ; ");
			script.println("location.href = 'index.jsp';");
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
						<a class="dropdown-item" href="userLogout.jps">로그아웃</a>
<%
	}
%>
					</div>
				</li>
			</ul>

			<form class="form-inline my-2 my-lg-0">
				<input class="form-control mr-sm-2" type="search"
					placeholder="내용을 입력하세요." aria-lable="search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>

	<section class="container mt-3" style="max-width: 560px;">
   		<div class = "alert alert-success mt-4" role ="alert">
   			이메일 주소로 인증메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가서 인증해주세요.
   		</div>
	</section>


  <footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
    Copyright &copy; 2018 김동원 All Right Reserved.
  </footer>

</body>
</html>


<!-- 강의평가 웹사이트 만들기 https://www.inflearn.com/course-status-2/ -->



