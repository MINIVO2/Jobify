package in.sp.register;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/JobSeekerProfileServlet")
public class job_seeker extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");

        HttpSession session = req.getSession();
        int jobSeekerId = (int) session.getAttribute("session_userid");

        // Collect form data
        String fullName = req.getParameter("full_name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String education = req.getParameter("education");
        String skills = req.getParameter("skills");
        int experience = Integer.parseInt(req.getParameter("experience"));
        String resume = req.getParameter("resume"); // Optional: handle upload later

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobify", "root", "Anwesha2014$");

            // Insert into job_seekers table
            String query = "INSERT INTO job_seekers (job_seeker_id, full_name, phone, address, education, skills, experience, resume) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setInt(1, jobSeekerId);
            pst.setString(2, fullName);
            pst.setString(3, phone);
            pst.setString(4, address);
            pst.setString(5, education);
            pst.setString(6, skills);
            pst.setInt(7, experience);
            pst.setString(8, resume);

            int count = pst.executeUpdate();

            if (count > 0) {
                req.setAttribute("message", "Profile saved successfully!");
                RequestDispatcher rd = req.getRequestDispatcher("/login.jsp");
                rd.forward(req, resp);
            } else {
                req.setAttribute("errorMessage", "Profile submission failed.");
                RequestDispatcher rd = req.getRequestDispatcher("/job_seeker.jsp");
                rd.include(req, resp);
            }

            pst.close();
            con.close();

        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            RequestDispatcher rd = req.getRequestDispatcher("/job_seeker.jsp");
            rd.include(req, resp);
        }
    }
}
