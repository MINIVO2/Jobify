<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Job Listings</title>
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

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM jobs");
%>

<h1>💼 All Job Listings</h1>

<%
    boolean hasJobs = false;
    while (rs.next()) {
        if (!hasJobs) {
%>
        <table>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Category</th>
                <th>Salary</th>
                <th>Location</th>
                <th>Experience</th>
                <th>Type</th>
                <th>Posted Date</th>
                <th>Apply</th>
            </tr>
<%
            hasJobs = true;
        }

        int jobId = rs.getInt("job_id");
%>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= rs.getString("category") %></td>
            <td>₹<%= rs.getString("salary") %></td>
            <td><%= rs.getString("location") %></td>
            <td><%= rs.getInt("experience") %> years</td>
            <td><%= rs.getString("job_type") %></td>
            <td><%= rs.getString("posted_date") %></td>
            <td><a href="apply.jsp?job=<%= jobId %>">Apply Now</a></td>
        </tr>
<%
    }

    if (!hasJobs) {
%>
    <p>No jobs found.</p>
<%
    } else {
%>
    </table>
<%
    }

    rs.close();
    stmt.close();
    con.close();
%>

</body>
</html>
