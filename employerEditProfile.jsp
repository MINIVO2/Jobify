<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Employer Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        input[type=text], input[type=email], input[type=password] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
        }
        input[type=submit] {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
        }
        label {
            font-weight: bold;
        }
    </style>
</head>
<body>

<%
    if (session == null || session.getAttribute("session_email") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email = (String) session.getAttribute("session_email");
    String name = "";
    String password = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

        PreparedStatement pst = con.prepareStatement("SELECT name, password FROM users WHERE email = ?");
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            password = rs.getString("password");
        } else {
%>
            <p style="color:red;">❌ Error: Employer profile not found.</p>
<%
        }

        rs.close();
        pst.close();
        con.close();

    } catch (Exception e) {
%>
    <p style="color:red;">Exception: <%= e.getMessage() %></p>
<%
    }
%>

<h2>📝 Edit Employer Profile</h2>
<form action="EmployerUpdateProfileServlet" method="post">
    <label for="name">Name</label>
    <input type="text" name="name" value="<%= name %>" required>

    <label for="email">Email</label>
    <input type="email" name="email" value="<%= email %>" readonly>

    <label for="password">Password</label>
    <input type="password" name="password" id="password" value="<%= password %>" required>

    <input type="checkbox" onclick="togglePassword()"> Show Password

    <br><br>
    <input type="submit" value="Update Profile">
</form>

<script>
    function togglePassword() {
        var pwd = document.getElementById("password");
        if (pwd.type === "password") {
            pwd.type = "text";
        } else {
            pwd.type = "password";
        }
    }
</script>

</body>
</html>
