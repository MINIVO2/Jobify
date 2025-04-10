<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Jobs - Admin Panel</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        .message {
            text-align: center;
            padding: 10px;
            font-weight: bold;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }

        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #34495e;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        a.btn {
            text-decoration: none;
            padding: 6px 12px;
            color: white;
            border-radius: 4px;
            font-size: 14px;
        }

        a.edit {
            background-color: #27ae60;
        }

        a.delete {
            background-color: #e74c3c;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
        }

        .back a {
            color: #3498db;
            text-decoration: none;
        }
    </style>
</head>
<body>

<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    if (msg != null) {
%>
    <div class="message success"><%= msg %></div>
<%
    } else if (error != null) {
%>
    <div class="message error"><%= error %></div>
<%
    }
%>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");
        stmt = conn.createStatement();
        String sql = "SELECT * FROM jobs";
        rs = stmt.executeQuery(sql);
%>

<h2>🛠 Manage Job Listings</h2>
<table>
    <tr>
        <th>Job-Id</th>
        <th>Employer-Id</th>
        <th>Title</th>
        <th>Description</th>
        <th>Category</th>
        <th>Salary</th>
        <th>Location</th>
        <th>Experience</th>
        <th>Job Type</th>
        <th>Actions</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("job_id") %></td>
        <td><%= rs.getInt("employer_id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getString("salary") %></td>
        <td><%= rs.getString("location") %></td>
        <td><%= rs.getString("experience") %></td>
        <td><%= rs.getString("job_type") %></td>
        <td>
            <a class="btn edit" href="editjobAdmin.jsp?id=<%= rs.getInt("job_id") %>">Edit</a>
            <a class="btn delete" href="DeleteJobAdminServlet?id=<%= rs.getInt("job_id") %>"
               onclick="return confirm('Are you sure you want to delete this job?');">Delete</a>
        </td>
    </tr>
<%
    }
%>
</table>

<%
    } catch (Exception e) {
        out.println("<p class='error' style='text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<div class="back">
    <a href="admin.jsp">⬅ Back to Dashboard</a>
</div>

</body>
</html>
