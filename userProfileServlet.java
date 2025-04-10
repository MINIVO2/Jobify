package in.sp.profile;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateJobSeekerProfile")
public class userProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("session_email") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("session_email");

        // Form data
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String education = req.getParameter("education");
        String skills = req.getParameter("skills");
        int experience = Integer.parseInt(req.getParameter("experience"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbURL = "jdbc:mysql://localhost:3306/jobify";
            String dbUser = "root";
            String dbPass = "Anwesha2014$";

            con = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Get user_id
            ps = con.prepareStatement("SELECT user_id FROM users WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();

            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt("user_id");
            }
            rs.close();
            ps.close();

            // Update job_seekers
            ps = con.prepareStatement(
                    "UPDATE job_seekers SET full_name=?, phone=?, address=?, education=?, skills=?, experience=? WHERE job_seeker_id=?");
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, education);
            ps.setString(5, skills);
            ps.setInt(6, experience);
            ps.setInt(7, userId);

            int updated = ps.executeUpdate();

            resp.setContentType("text/html");
            PrintWriter out = resp.getWriter();

            if (updated > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Profile updated successfully!');");
                out.println("window.location.href='user.jsp';");
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Update failed. Please try again.');");
                out.println("window.location.href='userProfile.jsp';");
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setContentType("text/html");
            PrintWriter out = resp.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('An error occurred: " + e.getMessage() + "');");
            out.println("window.location.href='userProfile.jsp';");
            out.println("</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
