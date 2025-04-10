<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Seeker Profile</title>
    <link rel="stylesheet" href="jobseekerformstyle.css" />
</head>
<body>

<div class="form-container">
    <h2>Complete Your<br>Job Seeker Profile</h2>

    <%-- Show success or error message from servlet --%>
    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("errorMessage");
        if (message != null) {
    %>
        <p class="success-message"><%= message %></p>
    <% } else if (error != null) { %>
        <p class="error-message"><%= error %></p>
    <% } %>

    <form action="JobSeekerProfileServlet" method="post">
        <label for="full_name">Full Name:</label>
        <input type="text" id="full_name" name="full_name" required>

        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" required>

        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required>

        <label for="education">Education:</label>
        <textarea id="education" name="education" rows="3" placeholder="Your qualifications..." required></textarea>

        <label for="skills">Skills (comma-separated):</label>
        <textarea id="skills" name="skills" rows="2" placeholder="e.g. Java, Python, SQL" required></textarea>

        <label for="experience">Years of Experience:</label>
        <input type="number" id="experience" name="experience" min="0" required>

        <label for="resume">Resume File Name:</label>
        <input type="text" id="resume" name="resume" placeholder="example_resume.pdf" required>

        <button type="submit">Save Profile</button>
    </form>
</div>

</body>
</html>
