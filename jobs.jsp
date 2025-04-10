<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Form</title>
</head>
<body>
    <h2>Enter Job Details</h2>

    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("errorMessage");
    %>

    <% if (message != null) { %>
        <p style="color:green;"><%= message %></p>
    <% } else if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <form action="JobServlet" method="post">
        <label for="title">Job Title:</label>
        <input type="text" id="title" name="title" required><br><br>

        <label for="description">Job Description:</label><br>
        <textarea id="description" name="description" rows="4" cols="50" required></textarea><br><br>

        <label for="category">Category:</label>
        <input type="text" id="category" name="category" required><br><br>

        <label for="salary">Salary:</label>
        <input type="number" id="salary" name="salary" step="0.01" required><br><br>

        <label for="location">Location:</label>
        <input type="text" id="location" name="location" required><br><br>

        <label for="experience">Experience (years):</label>
        <input type="number" id="experience" name="experience" required><br><br>

        <label for="job_type">Job Type:</label>
        <select id="job_type" name="job_type" required>
            <option value="Full-Time">Full-Time</option>
            <option value="Part-Time">Part-Time</option>
            <option value="Internship">Internship</option>
            <option value="Contract">Contract</option>
        </select><br><br>

        <input type="submit" value="Submit">
    </form>
</body>
</html>
