package in.sp.register;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EditJobServlet")
public class EditJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("job_id"));
        int employerId = Integer.parseInt(request.getParameter("employer_id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        double salary = Double.parseDouble(request.getParameter("salary"));
        String location = request.getParameter("location");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String jobType = request.getParameter("job_type");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            String sql = "UPDATE jobs SET title=?, description=?, category=?, salary=?, location=?, experience=?, job_type=? WHERE job_id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setString(3, category);
            stmt.setDouble(4, salary);
            stmt.setString(5, location);
            stmt.setInt(6, experience);
            stmt.setString(7, jobType);
            stmt.setInt(8, jobId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("manageJobs.jsp?updated=true");
            } else {
                response.sendRedirect("manageJobs.jsp?updated=false");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageJobs.jsp?updated=false");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
