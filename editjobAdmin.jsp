<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%
    String jobIdParam = request.getParameter("id");
    if (jobIdParam == null || jobIdParam.isEmpty()) {
        out.println("<h3 style='color:red; text-align:center;'>Invalid Job ID provided.</h3>");
        return;
    }

    int jobId = Integer.parseInt(jobIdParam);
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

        String sql = "SELECT * FROM jobs WHERE job_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, jobId);
        rs = stmt.executeQuery();

        if (!rs.next()) {
            out.println("<h3 style='color:red; text-align:center;'>No job found with the provided ID.</h3>");
            return;
        }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Job</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #34495e;
        }

        form {
            width: 500px;
            margin: 20px auto;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
        }

        input, textarea, select {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            background-color: #27ae60;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #219150;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #2980b9;
            text-decoration: none;
        }
    </style>
</head>
<body>

<h2>✏️ Edit Job Posting</h2>

<form action="EditJobServlet" method="post">
    <input type="hidden" name="job_id" value="<%= rs.getInt("job_id") %>">

    <label>Employer ID</label>
    <input type="text" name="employer_id" value="<%= rs.getInt("employer_id") %>" readonly>

    <label>Title</label>
    <input type="text" name="title" value="<%= rs.getString("title") %>" required>

    <label>Description</label>
    <textarea name="description" rows="4" required><%= rs.getString("description") %></textarea>

    <label>Category</label>
    <input type="text" name="category" value="<%= rs.getString("category") %>" required>

    <label>Salary</label>
    <input type="text" name="salary" value="<%= rs.getString("salary") %>" required>

    <label>Location</label>
    <input type="text" name="location" value="<%= rs.getString("location") %>" required>

    <label>Experience (years)</label>
    <input type="number" name="experience" value="<%= rs.getInt("experience") %>" required>

    <label>Job Type</label>
    <select name="job_type">
        <option value="Full-time" <%= "Full-time".equals(rs.getString("job_type")) ? "selected" : "" %>>Full-time</option>
        <option value="Part-time" <%= "Part-time".equals(rs.getString("job_type")) ? "selected" : "" %>>Part-time</option>
        <option value="Internship" <%= "Internship".equals(rs.getString("job_type")) ? "selected" : "" %>>Internship</option>
    </select>

    <button type="submit">Update Job</button>
</form>

<div class="back-link">
    <a href="manageJobs.jsp">⬅ Back to Manage Jobs</a>
</div>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
