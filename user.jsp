<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Portal Dashboard</title>
    <style>
        #suggestions {
            width: 400px;
            border: 1px solid #ccc;
            max-height: 150px;
            overflow-y: auto;
            position: absolute;
            background: #fff;
            z-index: 999;
            font-size: 16px;
        }

        #suggestions div {
            padding: 8px;
            cursor: pointer;
        }

        #suggestions div:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("session_name") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String name = (String) userSession.getAttribute("session_name");
    String email = (String) userSession.getAttribute("session_email");
    String role = (String) userSession.getAttribute("session_role");
%>

<center>
    <h1>🚀 Welcome to Job Portal, <%= name %>! 🚀</h1>
    <hr width="70%">

    <h2>🔍 Search for Jobs</h2>
    <form action="searchJobs.jsp" method="get" autocomplete="off">
        <input type="text" id="searchInput" name="query"
               placeholder="Enter job title, company or location"
               style="width: 400px; height: 35px; font-size: 16px; padding: 5px;" required>
        <button type="submit" style="height: 45px; font-size: 16px;">Search</button>
        <div id="suggestions"></div>
    </form>

    <hr width="70%">

    <h2>💼 Latest Job Openings</h2>
    <!-- Static job listings for now -->
    <table border="1" cellpadding="10" cellspacing="0" width="80%">
        <tr>
            <th>Job Title</th>
            <th>Company</th>
            <th>Location</th>
            <th>Apply</th>
        </tr>
        <tr>
            <td>Software Developer</td>
            <td>Google</td>
            <td>Remote</td>
            <td><a href="apply.jsp?job=1">Apply Now</a></td>
        </tr>
        <tr>
            <td>Data Analyst</td>
            <td>Amazon</td>
            <td>New York</td>
            <td><a href="apply.jsp?job=2">Apply Now</a></td>
        </tr>
        <tr>
            <td>Web Developer</td>
            <td>Microsoft</td>
            <td>Seattle</td>
            <td><a href="apply.jsp?job=3">Apply Now</a></td>
        </tr>
    </table>

    <hr width="70%">

    <h2>🔍 Explore</h2>
    <a href="userProfile.jsp">📝 Edit Profile</a> |
    <a href="ViewAllJobsPosted.jsp">💼 View All Jobs</a> |
    <a href="ViewUserApplication.jsp">📂 My Applications</a>

    <br><br>
    <form action="LogoutServlet" method="post">
        <button type="submit">🚪 Logout</button>
    </form>
</center>

<script>
    const searchInput = document.getElementById("searchInput");
    const suggestionsDiv = document.getElementById("suggestions");

    searchInput.addEventListener("input", () => {
        const query = searchInput.value.trim();
        if (query.length > 1) {
           fetch("GeminiSuggestServlet?query=" + encodeURIComponent(query))
                .then(response => response.json())
                .then(data => {
                    suggestionsDiv.innerHTML = "";
                    data.suggestions.forEach(suggestion => {
                        const div = document.createElement("div");
                        div.textContent = suggestion;
                        div.addEventListener("click", () => {
                            searchInput.value = suggestion;
                            suggestionsDiv.innerHTML = "";
                        });
                        suggestionsDiv.appendChild(div);
                    });
                });
        } else {
            suggestionsDiv.innerHTML = "";
        }
    });
</script>
</body>
</html>
