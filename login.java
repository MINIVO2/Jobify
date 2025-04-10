package in.sp.register;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginForm")
public class login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");

        String myemail = req.getParameter("email");
        String mypass = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            PreparedStatement ps = con.prepareStatement("SELECT user_id, name, email, role FROM users WHERE email=? AND password=?");
            ps.setString(1, myemail);
            ps.setString(2, mypass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int user_id = rs.getInt("user_id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String role = rs.getString("role");

                HttpSession session = req.getSession();
                session.setAttribute("session_userid", user_id);
                session.setAttribute("session_name", name);
                session.setAttribute("session_email", email);
                session.setAttribute("session_role", role);

                if ("job_seeker".equals(role)) {
                    resp.sendRedirect("user.jsp");
                } else if ("employer".equals(role)) {
                    resp.sendRedirect("employer.jsp");
                } else if ("admin".equals(role)) {
                    resp.sendRedirect("admin.jsp");
                } else {
                    resp.sendRedirect("login.jsp");
                }
            } else {
                req.setAttribute("errorMessage", "Invalid Email or Password!");
                RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                rd.forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
            rd.forward(req, resp);
        }
    }
}
