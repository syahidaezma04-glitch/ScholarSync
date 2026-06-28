package controller;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteActivityServlet")
public class DeleteActivityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String planIdStr = request.getParameter("id");

        if (planIdStr != null && !planIdStr.trim().isEmpty()) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM plan WHERE planID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(planIdStr));
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Refresh lists seamlessly by reloading page state
        response.sendRedirect(request.getContextPath() + "/LoadActivitiesServlet");
    }
}