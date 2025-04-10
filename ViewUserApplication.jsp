<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Applications</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #666;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #ddd;
        }
    </style>
</head>
<body>

<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("session_email") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email = (String) currentSession.getAttribute("session_email");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

        // Get job_seeker_id from email
        PreparedStatement userStmt = con.prepareStatement(
            "SELECT js.job_seeker_id FROM users u JOIN job_seekers js ON u.user_id = js.job_seeker_id WHERE u.email = ?");
        userStmt.setString(1, email);
        ResultSet userRs = userStmt.executeQuery();

        int jobSeekerId = -1;
        if (userRs.next()) {
            jobSeekerId = userRs.getInt("job_seeker_id");

            PreparedStatement pst = con.prepareStatement(
                "SELECT a.application_id, a.applied_date, a.status, j.title, j.location, j.salary, j.job_type " +
                "FROM applications a JOIN jobs j ON a.job_id = j.job_id " +
                "WHERE a.job_seeker_id = ?");
            pst.setInt(1, jobSeekerId);
            ResultSet rs = pst.executeQuery();

%>
<h2>📄 My Job Applications</h2>

<%
            boolean hasApplications = false;
            while (rs.next()) {
                if (!hasApplications) {
%>
<table>
    <tr>
        <th>Job Title</th>
        <th>Location</th>
        <th>Salary</th>
        <th>Type</th>
        <th>Applied On</th>
        <th>Status</th>
    </tr>
<%
                    hasApplications = true;
                }
%>
    <tr>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("location") %></td>
        <td>₹<%= rs.getString("salary") %></td>
        <td><%= rs.getString("job_type") %></td>
        <td><%= rs.getTimestamp("applied_date") %></td>
        <td><%= rs.getString("status") %></td>
    </tr>
<%
            } // end while

            if (!hasApplications) {
%>
    <p>You have not applied to any jobs yet.</p>
<%
            } else {
%>
</table>
<%
            }

            rs.close();
            pst.close();

        } else {
%>
    <p>❌ Error: Could not find your user details.</p>
<%
        }

        userRs.close();
        userStmt.close();
        con.close();

    } catch (Exception e) {
%>
    <p style="color:red;">Exception: <%= e.getMessage() %></p>
<%
    }
%>

</body>
</html>
