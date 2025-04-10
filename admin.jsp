<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Jobify</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 40px auto;
            background: #fff;
            padding: 20px 40px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .admin-options {
            margin-top: 30px;
        }

        .admin-options a {
            display: block;
            padding: 12px;
            margin: 10px 0;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }

        .admin-options a:hover {
            background-color: #0056b3;
        }

        .logout-btn {
            margin-top: 20px;
            text-align: center;
        }

        .logout-btn form button {
            padding: 10px 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .logout-btn form button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
<%
    // Check session
    String adminName = (session != null) ? (String) session.getAttribute("session_name") : null;
    if (adminName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="container">
    <h1>👨‍💼 Welcome, <%= adminName %> (Admin)</h1>

    <div class="admin-options">
        <a href="viewAllUsers.jsp">👥 View All Users</a>
        <a href="manageJobs.jsp">🛠 Manage Job Listings</a>
        <a href="reviewApplications.jsp">📄 Review Applications</a>
        <a href="jobs.jsp">📝 Post New Job</a>
        <a href="adminReports.jsp">📊 View Reports</a>
    </div>

    <div class="logout-btn">
        <form action="LogoutServlet" method="post">
            <button type="submit">🚪 Logout</button>
        </form>
    </div>
</div>

</body>
</html>
