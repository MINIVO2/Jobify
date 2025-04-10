<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Registration Form</title>
    <link rel="stylesheet" href="regstyle.css" />
</head>
<body>
    <div class="form-container">
        <form action="regForm" method="post">
            <h2>Registration Form</h2>

            <label for="name">Name:</label>
            <input type="text" name="name1" required />

            <label for="email">Email:</label>
            <input type="email" name="email1" required />

            <label for="password">Password:</label>
            <input type="password" name="pass1" required />

            <label for="role">Role:</label>
            <select name="role1" required>
                <option value="">Select Role</option>
                <option value="job_seeker">Job Seeker</option>
                <option value="employer">Employer</option>
                
            </select>

            <input type="submit" value="Register" />
        </form>
    </div>
</body>
</html>
