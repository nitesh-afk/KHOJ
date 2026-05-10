package com.khoj.controller;

import com.khoj.dao.ApplicationDAO;
import com.khoj.dao.NotificationDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/landlord/update-application")
public class ApplicationStatusServlet extends HttpServlet {
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized");
            return;
        }

        String appIdStr = request.getParameter("appId");
        String status = request.getParameter("status"); // ACCEPTED or REJECTED
        String tenantIdStr = request.getParameter("tenantId");

        if (appIdStr != null && status != null) {
            try {
                int appId = Integer.parseInt(appIdStr);
                boolean success = applicationDAO.updateApplicationStatusPrecise(appId, status, user.getId());

                if (success) {
                    // Phase 5: Notification Bridge
                    if ("ACCEPTED".equalsIgnoreCase(status) && tenantIdStr != null) {
                        int tenantId = Integer.parseInt(tenantIdStr);
                        notificationDAO.addNotification(tenantId, 
                            "Your application for a property has been ACCEPTED by the landlord!", 
                            "APPLICATION_ACCEPTED");
                    } else if ("REJECTED".equalsIgnoreCase(status) && tenantIdStr != null) {
                        int tenantId = Integer.parseInt(tenantIdStr);
                        notificationDAO.addNotification(tenantId, 
                            "Your application for a property has been rejected.", 
                            "APPLICATION_REJECTED");
                    }
                    response.sendRedirect(request.getContextPath() + "/landlord/inbound-applications?success=StatusUpdated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/landlord/inbound-applications?error=UpdateFailed");
                }
            } catch (NumberFormatException | SQLException e) {
                response.sendRedirect(request.getContextPath() + "/landlord/dashboard?error=InvalidData");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/landlord/dashboard");
        }
    }
}
