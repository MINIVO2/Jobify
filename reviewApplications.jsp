<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Applications - Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        table {
            width: 95%;
            margin: auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }
        th {
            background-color: #34495e;
            color: white;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .status {
            font-weight: bold;
        }
        .back {
            text-align: center;
            margin-top: 20px;
        }
        .back a {
            text-decoration: none;
            color: #2980b9;
        }
    </style>
</head>
<body>

<h2>📄 All Submitted Applications</h2>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");
        stmt = conn.createStatement();

        String sql = "SELECT a.application_id, a.job_id, a.job_seeker_id, a.resume, a.cover_letter, a.status, a.applied_date, " +
                     "j.title AS job_title, u.name AS applicant_name, u.email AS applicant_email " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN users u ON a.job_seeker_id = u.user_id " +
                     "ORDER BY a.applied_date DESC";

        rs = stmt.executeQuery(sql);
%>

<table>
    <tr>
        <th>Application ID</th>
        <th>Job Title</th>
        <th>Applicant Name</th>
        <th>Email</th>
        <th>Resume</th>
        <th>Cover Letter</th>
        <th>Status</th>
        <th>Applied Date</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("application_id") %></td>
        <td><%= rs.getString("job_title") %></td>
        <td><%= rs.getString("applicant_name") %></td>
        <td><%= rs.getString("applicant_email") %></td>
        <td><a href="resumes/<%= rs.getString("resume") %>" target="_blank">View</a></td>
        <td><%= rs.getString("cover_letter") %></td>
        <td class="status"><%= rs.getString("status") %></td>
        <td><%= rs.getTimestamp("applied_date") %></td>
    </tr>
<%
    }
%>
</table>

<%
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<div class="back">
    <a href="admin.jsp">⬅ Back to Admin Dashboard</a>
</div>

</body>
</html>
