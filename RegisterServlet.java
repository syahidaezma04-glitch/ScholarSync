package controller;

import database.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // If password validation fails, send them right back to login.jsp
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("registerError", "Passwords do not match.");
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            
            // Matches your exact singular user schema columns
            String sql = "INSERT INTO user (fullName, email, password) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);
            
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                // Success! Force the page to refresh back into the Sign In tab view with an explicit hint
                request.setAttribute("loginError", "Account created successfully! Please sign in.");
                request.getRequestDispatcher("/view/login.jsp").forward(request, response);
            } else {
                request.setAttribute("registerError", "Registration failed. Please try again.");
                request.getRequestDispatcher("/view/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("registerError", "Email might already be registered or database error occurred.");
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}