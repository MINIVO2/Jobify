<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
</head>
<body>
<%
    String searchQuery = request.getParameter("query");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

    PreparedStatement pst = con.prepareStatement(
        "SELECT job_id, title, location, salary, job_type FROM jobs WHERE title = ?"
    );
    pst.setString(1, searchQuery);

    ResultSet rs = pst.executeQuery();
%>

<center>
    <h1>🔍 Search Results</h1>
    <table border="1" cellpadding="10" cellspacing="0" width="80%">
        <tr>
            <th>Job Title</th>
            <th>Location</th>
            <th>Salary</th>
            <th>Type</th>
            <th>Apply</th>
        </tr>

        <%
            boolean found = false;
            while (rs.next()) {
                found = true;
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("location") %></td>
            <td>₹<%= rs.getDouble("salary") %></td>
            <td><%= rs.getString("job_type") %></td>
            <td><a href="apply.jsp?job=<%= rs.getInt("job_id") %>">Apply Now</a></td>
        </tr>
        <%
            }
            if (!found) {
        %>
        <tr>
            <td colspan="5">No jobs found matching your search.</td>
        </tr>
        <%
            }
            rs.close();
            pst.close();
            con.close();
        %>
    </table>

    <br>

</center>
</body>
</html>
