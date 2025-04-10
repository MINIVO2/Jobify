package in.sp.register;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/ApplyJobServlet")
public class ApplyJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("session_email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int jobId = Integer.parseInt(request.getParameter("job_id"));
        String coverLetter = request.getParameter("cover_letter");

        String email = (String) session.getAttribute("session_email");

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            // Get job_seeker_id and resume path from job_seekers table using session_email
            pst = con.prepareStatement("SELECT u.user_id, js.resume FROM users u JOIN job_seekers js ON u.user_id = js.job_seeker_id WHERE u.email = ?");
            pst.setString(1, email);
            rs = pst.executeQuery();

            if (rs.next()) {
                int jobSeekerId = rs.getInt("user_id");
                String resume = rs.getString("resume");

                // Insert application
                pst = con.prepareStatement("INSERT INTO applications (job_id, job_seeker_id, resume, cover_letter) VALUES (?, ?, ?, ?)");
                pst.setInt(1, jobId);
                pst.setInt(2, jobSeekerId);
                pst.setString(3, resume);
                pst.setString(4, coverLetter);

                int row = pst.executeUpdate();
                if (row > 0) {
                    out.println("<script>alert('Application submitted successfully!'); window.location='user.jsp';</script>");
                } else {
                    out.println("<script>alert('Failed to apply for the job.'); window.location='apply.jsp?job=" + jobId + "';</script>");
                }
            } else {
                out.println("<script>alert('Job seeker details not found.'); window.location='login.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Exception: " + e.getMessage() + "</h3>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pst != null) pst.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
