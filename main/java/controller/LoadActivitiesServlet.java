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

@WebServlet("/LoadActivitiesServlet")
public class LoadActivitiesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	 HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("userEmail") : null;

        ArrayList<Map<String, String>> pendingPlans = new ArrayList<>();
        ArrayList<Map<String, String>> completedPlans = new ArrayList<>();
        ArrayList<Map<String, String>> overduePlans = new ArrayList<>();
        LocalDate today = LocalDate.now();
        ArrayList<Map<String, String>> subjectList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Fetch subjects for dropdown menu
            String subSql = "SELECT subjectID, subjectName FROM subject";
            try (PreparedStatement psSub = conn.prepareStatement(subSql);
                 ResultSet rsSub = psSub.executeQuery()) {
                while(rsSub.next()) {
                    Map<String, String> sub = new HashMap<>();
                    sub.put("id", rsSub.getString("subjectID"));
                    sub.put("name", rsSub.getString("subjectName"));
                    subjectList.add(sub);
                }
            }
            request.setAttribute("subjects", subjectList);

            // 2. BROAD FETCH: Get ALL records using LEFT JOIN so missing details don't hide the row
            String sql = "SELECT p.planID, p.title, p.detail, p.planDate, p.studyHour, p.priorityLevel, p.status, s.subjectName " +
                         "FROM plan p " +
                         "LEFT JOIN subject s ON p.subjectID = s.subjectID";
            
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, String> plan = new HashMap<>();
                    plan.put("id", rs.getString("planID"));
                    
                    // Fallbacks if columns are empty/null in your older rows
                    String rawTitle = rs.getString("title");
                    plan.put("title", (rawTitle != null && !rawTitle.isEmpty()) ? rawTitle : "Untitled Session (" + rs.getString("planID") + ")");
                    
                    plan.put("detail", rs.getString("detail") != null ? rs.getString("detail") : "No description provided.");
                    plan.put("subject", rs.getString("subjectName") != null ? rs.getString("subjectName") : "General Study");
                    plan.put("time", rs.getString("studyHour") != null ? rs.getString("studyHour") + " Hours" : "0 Hours");
                    
                    String planDateStr = rs.getString("planDate");
                    plan.put("days", planDateStr != null ? planDateStr : today.toString());
                    
                    String priority = rs.getString("priorityLevel");
                    plan.put("priority", priority != null ? priority : "Medium");
                    
                    String status = rs.getString("status");

                    // Route to correct layout list array mapping
                    if ("Completed".equalsIgnoreCase(status) || "Past".equalsIgnoreCase(status)) {
                        plan.put("status", "Completed");
                        completedPlans.add(plan);
                    } else {
                        if (planDateStr != null && !planDateStr.isEmpty()) {
                            try {
                                if (LocalDate.parse(planDateStr).isBefore(today)) {
                                    plan.put("status", "Overdue");
                                    overduePlans.add(plan);
                                } else {
                                    plan.put("status", "Pending");
                                    pendingPlans.add(plan);
                                }
                            } catch (Exception parseEx) {
                                // If your date string format is mismatched, default to pending list safely
                                plan.put("status", "Pending");
                                pendingPlans.add(plan);
                            }
                        } else {
                            plan.put("status", "Pending");
                            pendingPlans.add(plan);
                        }
                    }
                }
            }
            
            // Push lists out to JSTL loops
            request.setAttribute("pendingPlans", pendingPlans);
            request.setAttribute("completedPlans", completedPlans);
            request.setAttribute("overduePlans", overduePlans);
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/view/activities.jsp").forward(request, response);
    }}