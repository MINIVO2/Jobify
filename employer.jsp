<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employer Dashboard - Job Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f7f9fc;
            margin: 0;
            padding: 0;
        }
        .container {
            text-align: center;
            margin-top: 50px;
        }
        h1 {
            color: #333;
        }
        .nav {
            margin-top: 30px;
        }
        .nav a {
            margin: 10px;
            padding: 12px 20px;
            text-decoration: none;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            display: inline-block;
            transition: background-color 0.3s;
        }
        .nav a:hover {
            background-color: #0056b3;
        }
        .logout-button {
            margin-top: 40px;
        }
        button {
            padding: 10px 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
<%
    HttpSession employerSession = request.getSession(false);
    if (employerSession == null || employerSession.getAttribute("session_name") == null ||
        !"employer".equals(employerSession.getAttribute("session_role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = (String) employerSession.getAttribute("session_name");
%>

<div class="container">
    <h1>👨‍💼 Welcome, <%= name %> (Employer)</h1>
    <p>Your personalized employer dashboard.</p>

    <div class="nav">
        <a href="jobs.jsp">📢 Post a Job</a>
        <a href="viewPostedJobs.jsp">📋 View Posted Jobs</a>
        <a href="viewApplications.jsp">📂 View Applications</a>
        <a href="employerEditProfile.jsp">📝 Edit Profile</a>
    </div>

    <div class="logout-button">
        <form action="LogoutServlet" method="post">
            <button type="submit">🚪 Logout</button>
        </form>
    </div>
</div>
</body>
</html>