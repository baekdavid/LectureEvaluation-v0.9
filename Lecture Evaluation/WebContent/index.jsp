<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>Lecture Evaluation</title>
	<!-- Bootstrap CSS added -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- custom CSS added -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String lectureDivde = "All";
	String searchType = "Newer";
	String search = "";
	int pageNumber = 0;
	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) {
			System.out.println("searchPageNumber error");
		}
	}
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Login,SVP!');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
	}
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp';");
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
						<a class="dropdown-item" href="userRegister.jsp">Signup</a>
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
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="All">All</option>
				<option value="Coding" <% if(lectureDivide.equals("Coding")) out.println("selected"); %>>Coding</option>
				<option value="Coaching"<% if(lectureDivide.equals("Coaching")) out.println("selected"); %>>Coaching</option>
				<option value="Common"<% if(lectureDivide.equals("Common")) out.println("selected"); %>>Common</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="Newer">Category</option>
				<option value="Recommanded" <% if(lectureDivide.equals("Recommanded")) out.println("selected"); %>>Recommanded</option>
			</select>
			<input type="text" name="search" class="form-contrl mx-1 mt-2" placeholder="Saisir les categories">
			<button type="submit" class="btn btn-primary mx-1 mt-2">Recherche</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">Ecrire</a>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#reportModal">Reclamer</a>
		</form>
	</section>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i = 0; i < evaluationList.size(); i++) {
			if(i == 5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %> La structure de base d'un ordinateur&nbsp;<small><%= evaluation.getProfessorName() %></small></div>
					<div class="col-4 text-right">
						Total<span style="color: red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
		<div class="card-body">
			<h5 class="card-title">
			<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>année <%= evaluation.getSemesterDivide() %>)</small>
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %></p> 
				<div class="row">
					<div class="col-9 text-left">
					Notes <span style="color: red;"><%= evaluation.getCreditScore() %></span>
					Ambiance <span style="color: red;"><%= evaluation.getComfortableScore() %></span>
					Enseignement <span style="color: red;"><%= evaluation.getLectureScore() %></span>
					<span style="color: green;">(recommande: <%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('j'aime')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">J'aime</a>
						<a onclick="return confirm('supprime')" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">Supprime</a>
					</div>
				</div>
		</div>
<%
	}
%>	

	</div>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <= 0) {
%> 
	<a class="page-link disabled">avant</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>&searchType=
	<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=
	<%=pageNumber - 1%>">avant</a>
<%
	}
%>
		</li>
		<li class="page-item">
<%
	if(evaluationList.size() < 6) {
%> 
	<a class="page-link disabled">suivant</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8")%>&pageNumber=
	<%= pageNumber+1 %>">suivant</a>
<%
	}
%>
	</li>
	</ul>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labaellledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal=header">
				<h5 class="modal-title" id="modal">Nouvelle evaluation</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
		<div class="modal-body">
			<form action="./evalutionRegisterAction.jsp" method="post"></form>
				<div class="form-row">
					<div class="form-group col-sm-6">
						<label>Cours</label>>
						<input type="text" name="lectureName" class="form-control" maxlength="20">
					</div>
					<div class="form-group col-sm-6">
						<label>Professeur</label>>
						<input type="text" name="ProfessorName" class="form-control" maxlength="20">
					</div>
				</div>
				<div class="form-row">
					<div class="form-group col-sm-4">
						<label>Année</label>
								<select name="lectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020" selected>2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>semestre</label>
								<select name="semesterDivide" class="form-control">
									<option value="1er semestre" selected>1er semestre</option>
									<option value="1er vacance" selected>1er vacance</option>
									<option value="2eme semestre" selected>2eme semestre</option>
									<option value="2eme vacance" selected>2eme vacance</option>
								</select>						
							</div>
							<div class="form-group col-sm-4">
								<label>Categorie</label>
								<select name="lectureDivide" class="form-control">
									<option value="Coding" selected>Coding</option>
									<option value="Coaching" selected>Coaching</option>
									<option value="Common" selected>Common</option>
								</select>
							</div>
						</div>
					<div class="form-group">
						<label>Titre</label>
						<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-group">
						<label>Content</label>
						<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="form-row">
						<div class="form-group col-sm-3">
							<label>Totale</label>
							<select name="totalScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B" selected>B</option>
								<option value="C" selected>C</option>
								<option value="D" selected>D</option>
								<option value="F" selected>F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>Notes</label>
							<select name="creditScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B" selected>B</option>
								<option value="C" selected>C</option>
								<option value="D" selected>D</option>
								<option value="F" selected>F</option>	
							</select>
						</div>	
						<div class="form-group col-sm-3">
							<label>Ambiance</label>
							<select name="comfortScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B" selected>B</option>
								<option value="C" selected>C</option>
								<option value="D" selected>D</option>
								<option value="F" selected>F</option>	
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>Enseignement</label>
							<select name="lectureScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B" selected>B</option>
								<option value="C" selected>C</option>
								<option value="D" selected>D</option>
								<option value="F" selected>F</option>	
							</select>
						</div>
					</div>		
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">annule</button>
							<button type="submit" class="btn btn-primary">valide</button>
					</div>				
				</div>				
			</div>
		</div>
		
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal=header">
				<h5 class="modal-title" id="modal">Réclamation</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
		<div class="modal-body">
	
			<form action="./reportAction.jsp" method="post">
					<div class="form-group">
						<label>Titre de la réclamation</label>
						<input type="text" name="reportTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-group">
						<label>Contenu de la réclamation</label>
						<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">annule</button>
							<button type="submit" class="btn btn-danger">Réclamation</button>
					</div>
				</form>				
			</div>				
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; baek.david@gmail.com 2020, All Rights Reserved
	</footer>
	<!-- jQuery js added  -->
	<script src="./js/jquery.min.js"></script>
	<!-- pooper js added  -->
	<script src="./js/pooper.js"></script>
	<!-- bootstrap js added  -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>