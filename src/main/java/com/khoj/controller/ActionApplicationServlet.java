package com.khoj.controller;

import com.khoj.dao.ApplicationDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/landlord/action-application")
public class ActionApplicationServlet extends HttpServlet {
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=Unauthorized");
            return;
        }

        String appIdStr = request.getParameter("appId");
        String action = request.getParameter("action");

        if (appIdStr != null && action != null) {
            try {
                int appId = Integer.parseInt(appIdStr);
                String newStatus = "ACCEPT".equalsIgnoreCase(action) ? "ACCEPTED" : "REJECTED";
                
                boolean success = applicationDAO.updateApplicationStatusPrecise(appId, newStatus, user.getId());

                if (success) {
                    session.setAttribute("successMsg", "Application successfully " + newStatus.toLowerCase() + ".");
                } else {
                    session.setAttribute("errorMsg", "Failed to update application. It may already be processed.");
                }
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "System error occurred during processing.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/landlord/inbound-applications");
    }
}
