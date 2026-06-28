package controller;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        int totalPending = 0;
        int totalCompleted = 0;
        int totalOverdue = 0;
        double totalStudyHours = 0.0;

        ArrayList<Map<String, String>> todaysSchedule = new ArrayList<>();
        LocalDate today = LocalDate.now();

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Fetch metrics and dynamic state distributions
            String metricsSql = "SELECT planDate, status, studyHour FROM plan";
            try (PreparedStatement psMetrics = conn.prepareStatement(metricsSql);
                 ResultSet rsMetrics = psMetrics.executeQuery()) {
                
                while (rsMetrics.next()) {
                    String status = rsMetrics.getString("status");
                    String planDateStr = rsMetrics.getString("planDate");
                    double hours = rsMetrics.getDouble("studyHour");

                    if ("Completed".equalsIgnoreCase(status)) {
                        totalCompleted++;
                        totalStudyHours += hours; // Count completed hours toward progress tracking
                    } else {
                        if (planDateStr != null && LocalDate.parse(planDateStr).isBefore(today)) {
                            totalOverdue++;
                        } else {
                            totalPending++;
                        }
                    }
                }
            }

            // 2. Fetch today's actual agenda schedule to display on the dashboard list view
            String agendaSql = "SELECT p.title, p.studyHour, p.priorityLevel, s.subjectName " +
                               "FROM plan p LEFT JOIN subject s ON p.subjectID = s.subjectID " +
                               "WHERE p.planDate = ? AND p.status = 'Pending'";
            
            try (PreparedStatement psAgenda = conn.prepareStatement(agendaSql)) {
                psAgenda.setString(1, today.toString());
                try (ResultSet rsAgenda = psAgenda.executeQuery()) {
                    while (rsAgenda.next()) {
                        Map<String, String> item = new HashMap<>();
                        item.put("title", rsAgenda.getString("title"));
                        item.put("hours", rsAgenda.getString("studyHour"));
                        item.put("priority", rsAgenda.getString("priorityLevel"));
                        item.put("subject", rsAgenda.getString("subjectName") != null ? rsAgenda.getString("subjectName") : "General");
                        todaysSchedule.add(item);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set attributes for dashboard counters
        request.setAttribute("pendingCount", totalPending);
        request.setAttribute("completedCount", totalCompleted);
        request.setAttribute("overdueCount", totalOverdue);
        request.setAttribute("totalStudyHours", totalStudyHours);
        request.setAttribute("todaysSchedule", todaysSchedule);

        // Forward to your dashboard view
        request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
    }
}