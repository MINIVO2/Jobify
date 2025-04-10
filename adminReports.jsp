<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Reports</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #ecf0f1;
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        .report-container {
            width: 80%;
            margin: auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }
        .report {
            margin: 20px 0;
            font-size: 18px;
            color: #34495e;
        }
        table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #3498db;
            color: #fff;
        }
        .back {
            text-align: center;
            margin-top: 30px;
        }
        .back a {
            color: #2980b9;
            text-decoration: none;
        }
    </style>
</head>
<body>

<h2>📊 Admin Reports</h2>

<div class="report-container">
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");
        stmt = conn.createStatement();

        // Total jobs
        rs = stmt.executeQuery("SELECT COUNT(*) AS totalJobs FROM jobs");
        rs.next();
        int totalJobs = rs.getInt("totalJobs");
        rs.close();

        // Total applications
        rs = stmt.executeQuery("SELECT COUNT(*) AS totalApps FROM applications");
        rs.next();
        int totalApps = rs.getInt("totalApps");
        rs.close();

        // Applications per job
        ResultSet appsPerJob = stmt.executeQuery(
            "SELECT j.title, COUNT(a.application_id) AS totalApplications " +
            "FROM jobs j LEFT JOIN applications a ON j.job_id = a.job_id " +
            "GROUP BY j.job_id"
        );

        // Applications by status
        ResultSet appsByStatus = stmt.executeQuery(
            "SELECT status, COUNT(*) AS count FROM applications GROUP BY status"
        );
%>

    <div class="report">📌 Total Jobs Posted: <strong><%= totalJobs %></strong></div>
    <div class="report">📌 Total Applications Submitted: <strong><%= totalApps %></strong></div>

    <h3>📁 Applications Per Job</h3>
    <table>
        <tr>
            <th>Job Title</th>
            <th>Total Applications</th>
        </tr>
        <%
            while (appsPerJob.next()) {
        %>
        <tr>
            <td><%= appsPerJob.getString("title") %></td>
            <td><%= appsPerJob.getInt("totalApplications") %></td>
        </tr>
        <%
            }
            appsPerJob.close();
        %>
    </table>

    <h3>📂 Applications By Status</h3>
    <table>
        <tr>
            <th>Status</th>
            <th>Count</th>
        </tr>
        <%
            while (appsByStatus.next()) {
        %>
        <tr>
            <td><%= appsByStatus.getString("status") %></td>
            <td><%= appsByStatus.getInt("count") %></td>
        </tr>
        <%
            }
            appsByStatus.close();
        %>
    </table>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
</div>

<div class="back">
    <a href="admin.jsp">⬅ Back to Admin Dashboard</a>
</div>

</body>
</html>
