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

@WebServlet("/AddActivityServlet")
public class AddActivityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Extract inputs exactly matching the JSP 'name' attributes
        String title = request.getParameter("title");
        String detail = request.getParameter("detail");
        String subjectIDStr = request.getParameter("subjectID"); 
        String timeStr = request.getParameter("time"); 
        String planDate = request.getParameter("planDate");
        String priorityLevel = request.getParameter("priorityLevel");

        try (Connection conn = DBConnection.getConnection()) {
            // 2. SQL structured exactly like your phpMyAdmin table columns
            String sql = "INSERT INTO plan (planDate, studyHour, priorityLevel, status, userID, title, detail, subjectID) " +
                         "VALUES (?, ?, ?, 'Pending', NULL, ?, ?, ?)";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, planDate);
                ps.setDouble(2, Double.parseDouble(timeStr));
                ps.setString(3, priorityLevel);
                ps.setString(4, title);
                ps.setString(5, (detail != null && !detail.trim().isEmpty()) ? detail : null);
                
                // Handle optional subject foreign key cleanly
                if (subjectIDStr != null && !subjectIDStr.trim().isEmpty()) {
                    ps.setInt(6, Integer.parseInt(subjectIDStr));
                } else {
                    ps.setNull(6, java.sql.Types.INTEGER);
                }
                
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Add Activity Insertion Error:");
            e.printStackTrace();
        }

        // 3. Always redirect back through the loader to refresh calculation states
        response.sendRedirect(request.getContextPath() + "/LoadActivitiesServlet");
    }
}