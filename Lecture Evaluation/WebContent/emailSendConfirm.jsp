<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<meta name="viewport" content="width=device-width, initial-scale-1, shrink-to-fit=no">
	<title>Lecture Evaluation</title>
	<!-- Bootstrap CSS added -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- custom CSS added -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("usereID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Login,SVP!');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">Lecture Evaluation</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">Main</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						Membership
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID == null) {
%>
						<a class="dropdown-item" href="userLogin.jsp">Login</a>
						<a class="dropdown-item" href="userJoin.jsp">Signup</a>
<%
	} else {
%>
						<a class="dropdown-item" href="userLogout.jsp">Logout</a>
<%
	} 
%>		
					</div>
				</li>
			</ul> 
			<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
				<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="Recherche.." aria-label="Search">
				<button class="btn btn-outline-sucess my-2 my-sm-0" type="submit">Recherche</button>
			</form>
		</div>
	</nav>
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-warning mt-r4" role="alert">
		Vous devez valider votre e-mail.Merci de verifier votre e-mail. 
		</div>
		<a href="emailSendAction.jsp" class="btn btn-primary">Renvoyer la verification de e-mail</a>
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; David Baek,2020, All Rights Reserved
	</footer>
	<!-- jQuery js added  -->
	<script src="./js/jquery.min.js"></script>
	<!-- pooper js added  -->
	<script src="./js/pooper.js"></script>
	<!-- bootstrap js added  -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>