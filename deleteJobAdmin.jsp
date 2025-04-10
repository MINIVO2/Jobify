<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Job</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        .confirm-box {
            width: 500px;
            border: 1px solid #dc3545;
            background-color: #f8d7da;
            padding: 20px;
        }
        .confirm-box h2 {
            color: #721c24;
        }
        .btn-danger {
            background-color: #dc3545;
            border: none;
            color: white;
            padding: 10px 15px;
            margin-right: 10px;
            cursor: pointer;
        }
        .btn-cancel {
            background-color: #6c757d;
            border: none;
            color: white;
            padding: 10px 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<%
    String dbURL = "jdbc:mysql://localhost:3306/your_database";
    String dbUser = "your_username";
    String dbPass = "your_password";

    String jobIdStr = request.getParameter("job_id");
    int jobId = Integer.parseInt(jobIdStr);

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String title = "", company = "", location = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String sql = "SELECT title, location FROM jobs WHERE job_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, jobId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            location = rs.getString("location");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<h2>⚠️ Confirm Deletion</h2>
<div class="confirm-box">
    <h2>Are you sure you want to delete this job?</h2>
    <p><strong>Title:</strong> <%= title %></p>
    <p><strong>Location:</strong> <%= location %></p>

    <form action="deleteJobServlet" method="post" style="display: inline;">
        <input type="hidden" name="job_id" value="<%= jobId %>">
        <button type="submit" class="btn-danger">Yes, Delete</button>
    </form>

    <a href="manageJobs.jsp"><button class="btn-cancel">Cancel</button></a>
</div>

</body>
</html>
