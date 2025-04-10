package in.sp.register;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteJobAdminServlet")
public class manageJobs extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("id");

        if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
            response.sendRedirect("manageJobs.jsp?error=Invalid+Job+ID");
            return;
        }

        int jobId = Integer.parseInt(jobIdStr);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            String sql = "DELETE FROM jobs WHERE job_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, jobId);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("manageJobs.jsp?msg=Job+Deleted+Successfully");
            } else {
                response.sendRedirect("manageJobs.jsp?error=Job+Not+Found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageJobs.jsp?error=Server+Error");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
