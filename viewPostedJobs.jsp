<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session == null || session.getAttribute("session_userid") == null || !"employer".equals(session.getAttribute("session_role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int employerId = (Integer) session.getAttribute("session_userid");

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Posted Jobs</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0px 0px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px 15px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>

<h2>📋 Jobs You Have Posted</h2>

<table>
    <tr>
        <th>Job ID</th>
        <th>Title</th>
        <th>Category</th>
        <th>Description</th>
        <th>Salary</th>
        <th>Location</th>
        <th>Experience</th>
        <th>Type</th>
    </tr>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

        String sql = "SELECT * FROM jobs WHERE employer_id = ?";
        pst = con.prepareStatement(sql);
        pst.setInt(1, employerId);
        rs = pst.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("job_id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getInt("salary") %></td>
        <td><%= rs.getString("location") %></td>
        <td><%= rs.getInt("experience") %> yrs</td>
        <td><%= rs.getString("job_type") %></td>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>

</table>
</body>
</html>
