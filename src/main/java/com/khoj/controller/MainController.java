package com.khoj.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/admin/dashboard", "/landlord/dashboard", "/tenant/dashboard", "/admin/property-verification", "/admin/user-approval", "/landlord/inbound-applications"})
public class MainController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                com.khoj.dao.AdminDAO adminDAO = new com.khoj.dao.AdminDAO();
                request.setAttribute("stats", adminDAO.getSystemSummary());
                request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
                break;
            case "/admin/property-verification":
                com.khoj.dao.AdminDAO adminDAOVerify = new com.khoj.dao.AdminDAO();
                request.setAttribute("rooms", adminDAOVerify.getUnverifiedProperties());
                request.getRequestDispatcher("/views/admin/rooms.jsp").forward(request, response);
                break;
            case "/admin/user-approval":
                com.khoj.dao.AdminDAO adminDAOUsers = new com.khoj.dao.AdminDAO();
                request.setAttribute("landlords", adminDAOUsers.getPendingLandlords());
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
                break;
            case "/landlord/dashboard":
                com.khoj.model.User landlord = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.PropertyDAO propDAO = new com.khoj.dao.PropertyDAO();
                request.setAttribute("properties", propDAO.getPropertiesByLandlord(landlord.getId()));
                request.setAttribute("stats", propDAO.getPropertyCountByStatus(landlord.getId()));
                com.khoj.dao.MessageDAO msgDAO = new com.khoj.dao.MessageDAO();
                try {
                    request.setAttribute("unreadMessages", msgDAO.getTotalUnreadCount(landlord.getId()));
                } catch (Exception e) { e.printStackTrace(); }
                request.getRequestDispatcher("/views/landlord/dashboard.jsp").forward(request, response);
                break;
            case "/landlord/inbound-applications":
                com.khoj.model.User landlordApps = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.ApplicationDAO appDAO = new com.khoj.dao.ApplicationDAO();
                request.setAttribute("applications", appDAO.getApplicationsByLandlord(landlordApps.getId()));
                request.getRequestDispatcher("/views/landlord/applications.jsp").forward(request, response);
                break;
            case "/tenant/dashboard":
                com.khoj.model.User tenant = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.ApplicationDAO tenantAppDAO = new com.khoj.dao.ApplicationDAO();
                com.khoj.dao.NotificationDAO notifDAO = new com.khoj.dao.NotificationDAO();
                request.setAttribute("applications", tenantAppDAO.getApplicationsByTenant(tenant.getId()));
                request.setAttribute("notifications", notifDAO.getNotificationsByUser(tenant.getId()));
                com.khoj.dao.MessageDAO tenantMsgDAO = new com.khoj.dao.MessageDAO();
                try {
                    request.setAttribute("unreadMessages", tenantMsgDAO.getTotalUnreadCount(tenant.getId()));
                } catch (Exception e) { e.printStackTrace(); }
                request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }
}
