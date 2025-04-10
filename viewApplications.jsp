<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Applications</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        form {
            display: inline;
        }
        select {
            padding: 5px;
        }
        input[type="submit"] {
            padding: 6px 10px;
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<%
    if (session == null || session.getAttribute("session_userid") == null || !"employer".equals(session.getAttribute("session_role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int employerId = (int) session.getAttribute("session_userid");

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

        String query = "SELECT a.application_id, a.job_id, j.title AS job_title, u.name AS applicant_name, u.email, a.resume, a.cover_letter, a.status " +
                       "FROM applications a " +
                       "JOIN jobs j ON a.job_id = j.job_id " +
                       "JOIN users u ON a.job_seeker_id = u.user_id " +
                       "WHERE j.employer_id = ?";
        pst = con.prepareStatement(query);
        pst.setInt(1, employerId);
        rs = pst.executeQuery();
%>

<h2>📄 Applications for Your Posted Jobs</h2>

<table>
    <tr>
        <th>Job Title</th>
        <th>Applicant Name</th>
        <th>Email</th>
        <th>Resume</th>
        <th>Cover Letter</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("job_title") %></td>
        <td><%= rs.getString("applicant_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><a href="<%= rs.getString("resume") %>" target="_blank">View Resume</a></td>
        <td><%= rs.getString("cover_letter") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
            <form action="UpdateStatusServlet" method="post">
                <input type="hidden" name="application_id" value="<%= rs.getInt("application_id") %>">
                <select name="new_status">
                    <option value="Pending">Pending</option>
                    <option value="Reviewed">Reviewed</option>
                    <option value="Shortlisted">Shortlisted</option>
                    <option value="Rejected">Rejected</option>
                    <option value="Hired">Hired</option>
                </select>
                <input type="submit" value="Update">
            </form>
        </td>
    </tr>
<%
    }
%>
</table>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>

</body>
</html>
