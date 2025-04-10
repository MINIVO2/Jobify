package in.sp.register; // Change this to match your actual package name

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EmployerUpdateProfileServlet")
public class EmployerUpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("session_email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String sessionEmail = (String) session.getAttribute("session_email");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        // DB connection
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            String sql = "UPDATE users SET name = ?, password = ? WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, password);
            pst.setString(3, sessionEmail);

            int updated = pst.executeUpdate();

            pst.close();
            con.close();

            if (updated > 0) {
                response.sendRedirect("employer.jsp"); // change if needed
            } else {
                response.getWriter().println("<p style='color:red;'>❌ Failed to update profile.</p>");
            }

        } catch (Exception e) {
            response.getWriter().println("<p style='color:red;'>Exception: " + e.getMessage() + "</p>");
        }
    }
}