package controller;

import database.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Grab values matching the HTML "name" parameter property
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            // Modify this SQL statement according to your exact table definition schema
            String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // Note: For real builds, use hashed passwords!
            
            rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                
                // Make sure this matches your 'email' column exactly!
                session.setAttribute("userEmail", rs.getString("email")); 
                
                // Forward the user straight to the dashboard view
                request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
            } else {
                // If the email/password combination doesn't match any row in phpMyAdmin
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("/view/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("loginError", "An unhandled database anomaly occurred.");
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
        } finally {
            // Memory cleanup structures
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}