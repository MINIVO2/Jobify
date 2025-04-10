package in.sp.register; // Replace with your actual package name

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String applicationIdStr = request.getParameter("application_id");
        String newStatus = request.getParameter("new_status");

        if (applicationIdStr == null || newStatus == null || applicationIdStr.isEmpty() || newStatus.isEmpty()) {
            response.getWriter().println("<p style='color:red;'>Invalid input provided.</p>");
            return;
        }

        int applicationId = Integer.parseInt(applicationIdStr);

        Connection con = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            String query = "UPDATE applications SET status = ? WHERE application_id = ?";
            pst = con.prepareStatement(query);
            pst.setString(1, newStatus);
            pst.setInt(2, applicationId);

            int updated = pst.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("viewApplications.jsp");
            } else {
                response.getWriter().println("<p style='color:red;'>❌ Failed to update status.</p>");
            }

        } catch (Exception e) {
            response.getWriter().println("<p style='color:red;'>Exception: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException se) {
                response.getWriter().println("<p style='color:red;'>Cleanup Error: " + se.getMessage() + "</p>");
            }
        }
    }
}
