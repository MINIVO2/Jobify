<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
</head>
<body>
<%
    if (session == null || session.getAttribute("session_email") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email = (String) session.getAttribute("session_email");
    String dbURL = "jdbc:mysql://localhost:3306/jobify";
    String dbUser = "root";
    String dbPass = "Anwesha2014$";

    String fullName = "", phone = "", address = "", education = "", skills = "";
    int experience = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        PreparedStatement ps = con.prepareStatement(
            "SELECT js.full_name, js.phone, js.address, js.education, js.skills, js.experience " +
            "FROM users u INNER JOIN job_seekers js ON u.user_id = js.job_seeker_id WHERE u.email = ?"
        );
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("full_name");
            phone = rs.getString("phone");
            address = rs.getString("address");
            education = rs.getString("education");
            skills = rs.getString("skills");
            experience = rs.getInt("experience");
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading profile: " + e.getMessage() + "</p>");
    }
%>

<center>
    <h1>Edit Your Profile</h1>
    <form action="UpdateJobSeekerProfile" method="post">
        <table cellpadding="10">
            <tr>
                <td>Full Name:</td>
                <td><input type="text" name="fullName" value="<%= fullName %>" required></td>
            </tr>
            <tr>
                <td>Phone:</td>
                <td><input type="text" name="phone" value="<%= phone %>" required></td>
            </tr>
            <tr>
                <td>Address:</td>
                <td><textarea name="address" rows="3" cols="30"><%= address %></textarea></td>
            </tr>
            <tr>
                <td>Education:</td>
                <td><textarea name="education" rows="3" cols="30"><%= education %></textarea></td>
            </tr>
            <tr>
                <td>Skills:</td>
                <td><input type="text" name="skills" value="<%= skills %>"></td>
            </tr>
            <tr>
                <td>Experience (in years):</td>
                <td><input type="number" name="experience" value="<%= experience %>" min="0"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <button type="submit">Update Profile</button>
                </td>
            </tr>
        </table>
    </form>
</center>

</body>
</html>
