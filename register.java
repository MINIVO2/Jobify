package in.sp.register;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/regForm")
public class register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();

        String myname = req.getParameter("name1");
        String myemail = req.getParameter("email1");
        String mypass = req.getParameter("pass1");
        String myrole = req.getParameter("role1");

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            // Insert user
            String query = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pst.setString(1, myname);
            pst.setString(2, myemail);
            pst.setString(3, mypass);
            pst.setString(4, myrole);

            int count = pst.executeUpdate();

            if (count > 0) {
                ResultSet rs = pst.getGeneratedKeys();
                int userId = 0;
                if (rs.next()) {
                    userId = rs.getInt(1);
                }

                // ✅ Save user data in session
                HttpSession session = req.getSession();
                session.setAttribute("session_userid", userId);
                session.setAttribute("session_name", myname);
                session.setAttribute("session_email", myemail);
                session.setAttribute("session_role", myrole);

                // ✅ Redirect based on role
                if ("employer".equals(myrole)) {
                    RequestDispatcher rd = req.getRequestDispatcher("/jobs.jsp");
                    rd.forward(req, resp);
                } else if ("job_seeker".equals(myrole)) {
                    RequestDispatcher rd = req.getRequestDispatcher("/job_seeker.jsp");
                    rd.forward(req, resp);
                } else {
                    RequestDispatcher rd = req.getRequestDispatcher("/login.jsp");
                    rd.forward(req, resp);
                }

            } else {
                out.print("<h3 style='color:red'>User not registered due to some error</h3>");
                RequestDispatcher rd = req.getRequestDispatcher("/register.jsp");
                rd.include(req, resp);
            }

            pst.close();
            con.close();

        } catch (Exception e) {
            out.print("<h3 style='color:red'>Exception Occurred: " + e.getMessage() + "</h3>");
            RequestDispatcher rd = req.getRequestDispatcher("/register.jsp");
            rd.include(req, resp);
        }
    }
}
