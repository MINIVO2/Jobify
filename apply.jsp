<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Apply for Job</title>
</head>
<body>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("session_email") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String jobIdParam = request.getParameter("job");
    if (jobIdParam == null || jobIdParam.isEmpty()) {
%>
        <p>❌ Error: No job ID provided.</p>
<%
        return;
    }

    int jobId = 0;
    try {
        jobId = Integer.parseInt(jobIdParam);
    } catch (NumberFormatException e) {
%>
        <p>❌ Error: Invalid job ID provided.</p>
<%
        return;
    }

    String email = (String) currentSession.getAttribute("session_email");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

    // Fetch job seeker info using session_email
    PreparedStatement seekerPst = con.prepareStatement(
        "SELECT * FROM users u JOIN job_seekers js ON u.user_id = js.job_seeker_id WHERE u.email = ?");
    seekerPst.setString(1, email);
    ResultSet seekerRs = seekerPst.executeQuery();

    // Fetch job info
    PreparedStatement jobPst = con.prepareStatement("SELECT title, location FROM jobs WHERE job_id = ?");
    jobPst.setInt(1, jobId);
    ResultSet jobRs = jobPst.executeQuery();

    if (seekerRs.next() && jobRs.next()) {
%>

<h2>Apply for: <%= jobRs.getString("title") %> - <%= jobRs.getString("location") %></h2>

<form action="ApplyJobServlet" method="post">
    <input type="hidden" name="job_id" value="<%= jobId %>">
    <input type="hidden" name="job_seeker_id" value="<%= seekerRs.getInt("job_seeker_id") %>">
    <input type="hidden" name="resume" value="<%= seekerRs.getString("resume") %>">

    <label>Full Name:</label>
    <input type="text" name="name" value="<%= seekerRs.getString("full_name") %>" readonly><br><br>

    <label>Email:</label>
    <input type="email" name="email" value="<%= seekerRs.getString("email") %>" readonly><br><br>

    <label>Phone:</label>
    <input type="text" name="phone" value="<%= seekerRs.getString("phone") %>" readonly><br><br>

    <label>Cover Letter:</label><br>
    <textarea name="cover_letter" rows="6" cols="60" required></textarea><br><br>

    <button type="submit">Submit Application</button>
</form>

<%
    } else {
%>
    <p>❌ Error: Unable to load job or user details.</p>
<%
    }

    jobRs.close();
    seekerRs.close();
    jobPst.close();
    seekerPst.close();
    con.close();
%>

</body>
</html>
